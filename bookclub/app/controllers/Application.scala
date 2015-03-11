package controllers.bookclub

import java.util.UUID
import scala.concurrent.Future
import play.api._
import play.api.mvc._
import play.api.libs.json._
import play.api.libs.concurrent.Execution.Implicits._
import io.useless.account.Account
import io.useless.play.json.account.AccountJson

import com.granmal.auth.AuthRequest
import com.granmal.auth.AuthAction._
import com.granmal.helpers.UrlHelper
import com.granmal.models.account.PublicAccount
import com.granmal.models.account.PublicAccount.Json._

import clients.bookclub.BooksClient

object Assets extends controllers.AssetsBuilder

object Application extends Controller with BooksClient {

  case class Bootstrap(
    account: Option[PublicAccount],
    initialNotes: Seq[JsValue],
    nextPageQuery: Option[String],
    lastNote: Option[JsValue],
    currentNote: Option[JsValue]
  )
  implicit val bootstrapFormat = Json.format[Bootstrap]

  def app(path: String = "") = Action.auth.async { implicit request =>
    buildBootstrap().map { bootstrap =>
      Ok(views.html.bookclub.app(
        bootstrap = bootstrap,
        javascriptRouter = buildJavascriptRouter()
      ))
    }
  }

  case class Author(guid: UUID, name: String)
  implicit val authorFormat = Json.format[Author]

  def findAuthors(name: String) = Action.async { implicit request =>
    request.queryString.get("name").flatMap(_.headOption).map { name =>
      jsonClient.find("/authors", "name" -> name).map { authors =>
        Ok(Json.toJson(authors.items))
      }
    }.getOrElse {
      Future.successful(Ok(Json.arr()))
    }
  }

  def createAuthor = Action.auth.async(parse.json) { implicit request =>
    withUselessClient { client =>
      client.create[Author]("/authors", request.body).map { result =>
        result.fold(
          error => Conflict(error),
          author => Created(Json.toJson(author))
        )
      }
    }
  }

  case class Edition(guid: UUID, page_count: Int)
  implicit val editionFormat = Json.format[Edition]

  case class Book(guid: UUID, title: String, author: Author, editions: Seq[Edition])
  implicit val bookFormat = Json.format[Book]

  def findBooks(title: String) = Action.async { implicit request =>
    request.queryString.get("title").flatMap(_.headOption).map { title =>
      jsonClient.find("/books", "title" -> title).map { books =>
        Ok(Json.toJson(books.items))
      }
    }.getOrElse {
      Future.successful(Ok(Json.arr()))
    }
  }

  def createBook = Action.auth.async(parse.json) { implicit request =>
    withUselessClient { client =>
      client.create[Book]("/books", request.body).map { result =>
        result.fold(
          error => Conflict(error),
          book => Created(Json.toJson(book))
        )
      }
    }
  }

  implicit private val accountFormat =
    Format(AccountJson.accountReads, AccountJson.accountWrites)

  case class NewNote(book_guid: UUID, page_number: Int, page_total: Int, content: String)
  implicit val newNoteFormat = Json.format[NewNote]

  case class Note(guid: UUID, page_number: Int, content: String, edition: Edition, book: Book, created_by: Account)
  implicit val newNote = Json.format[Note]

  def getNote(guid: UUID) = Action.auth.async { implicit request =>
    val futOptCurrentNote = jsonClient.get(s"/notes/${guid}")

    render.async {
      case Accepts.Html() => buildBootstrap().map { bootstrap =>
        Ok(views.html.bookclub.app(
          bootstrap = bootstrap,
          javascriptRouter = buildJavascriptRouter()
        ))
      }

      case Accepts.Json() => futOptCurrentNote.map { optNote =>
        optNote.map(Ok(_)).getOrElse(NotFound)
      }
    }
  }

  def findNotes = Action.auth.async { request =>
    val query = request.queryString.mapValues { value => value.head }
    jsonClient.find("/notes", query.toSeq:_*).map { page =>
      val headers = page.next.
        flatMap { nextUrl => UrlHelper.getRawQueryString(nextUrl) }.
        map { nextPageQuery => "X-Next-Page-Query" -> nextPageQuery }.
        toSeq

      Ok(Json.toJson(page.items)).withHeaders(headers:_*)
    }
  }

  def createNote = Action.auth.async(parse.json) { implicit request =>
    request.body.validate[NewNote].fold(
      error => Future.successful(Conflict),
      newNote => withUselessClient { client =>

        // We first need to get the book for which this note is being created.
        client.get[Book](s"/books/${newNote.book_guid}").flatMap { optBook =>
          optBook.map { book =>

            // Look for and edition whose page_count that corresponds to the
            // specified page_total.
            val optEdition = book.editions.find { edition =>
              edition.page_count == newNote.page_total
            }

            val futOptEdition = if (optEdition.isDefined) {
              // If we found an appropriate edition, use it.
              Future.successful(optEdition)
            } else {
              // Otherwise, create a new edition and use that.
              client.create[Edition]("/editions", Json.obj(
                "book_guid" -> book.guid,
                "page_count" -> newNote.page_total
              )).map { result =>
                result.right.toOption
              }
            }

            futOptEdition.flatMap { optEdition =>
              optEdition.map { edition =>

                // Now that we have the edition, we can attempt to create the note.
                client.create[Note]("/notes", Json.obj(
                  "edition_guid" -> edition.guid,
                  "page_number" -> newNote.page_number,
                  "content" -> newNote.content
                )).map { result =>
                  result.fold(
                    error => Conflict(error),
                    note => Created(Json.toJson(note))
                  )
                }
              }.getOrElse {
                // If we couldn't come up with an edition, it's our fault.
                Future.successful(InternalServerError)
              }
            }
          }.getOrElse {
            // If we couldn't find the book, then it's the client's fault.
            Future.successful(Conflict)
          }
        }
      }
    )

  }

  private def buildBootstrap[T]()(implicit request: AuthRequest[T]): Future[Bootstrap] = {
    for {
      initialNotes <- getInitialNotes()
      lastNote <- getLastNote()
    } yield Bootstrap(
      account = request.account.map(_.toPublic),
      initialNotes = initialNotes.items,
      nextPageQuery = initialNotes.next.flatMap(UrlHelper.getRawQueryString(_)),
      lastNote = lastNote,
      currentNote = None
    )
  }

  private def buildJavascriptRouter()(implicit request: RequestHeader) = {
    import routes.javascript

    Routes.javascriptRouter()(
      javascript.Application.findNotes,
      javascript.Application.findAuthors,
      javascript.Application.findBooks,
      javascript.Application.createBook,
      javascript.Application.createNote
    )
  }

  private def getInitialNotes() = jsonClient.find("/notes", "p.limit" -> "10")

  // The last note of the current user.
  private def getLastNote()(implicit request: AuthRequest[_]) = {
    request.account.flatMap(_.uselessAccessToken).map { accessToken =>
      jsonClient.find("/notes",
        "account_guid" -> accessToken.accountId,
        "p.limit" -> "1"
      ).map(_.items.headOption)
    }.getOrElse(Future.successful(None))
  }

}
