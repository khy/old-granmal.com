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

}
