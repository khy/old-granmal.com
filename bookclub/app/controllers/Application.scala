package controllers.bookclub

import java.util.UUID
import scala.concurrent.Future
import play.api._
import play.api.mvc._
import play.api.libs.json._
import play.api.libs.concurrent.Execution.Implicits._

import com.granmal.auth.AuthRequest
import com.granmal.auth.AuthAction._

import clients.bookclub.BooksClient

object Assets extends controllers.AssetsBuilder

object Application extends Controller with BooksClient {

  def index(path: String = "") = Action.auth.async { implicit request =>
    Future.successful(Ok(views.html.bookclub.index(
      user = request.account.map { account =>
        Json.obj(
          "guid" -> account.guid,
          "handle" -> account.handle,
          "name" -> account.name
        )
      },
      lastNote = None
    )))
  }

  case class Author(guid: UUID, name: String)
  implicit val authorFormat = Json.format[Author]

  def findAuthors(name: String) = Action.async { implicit request =>
    request.queryString.get("name").flatMap(_.headOption).map { name =>
      resourceClient.find[Author]("/authors", "name" -> name).map { authors =>
        Ok(Json.toJson(authors))
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
      resourceClient.find[Book]("/books", "title" -> title).map { books =>
        Ok(Json.toJson(books))
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

  case class NewNote(book_guid: UUID, page_number: Int, page_total: Int, content: String)
  implicit val newNoteFormat = Json.format[NewNote]

  case class Note(guid: UUID, page_number: Int, content: String, edition: Edition, book: Book)
  implicit val newNote = Json.format[Note]

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

}
