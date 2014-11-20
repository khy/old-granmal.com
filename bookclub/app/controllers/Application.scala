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

  def index(path: String = "") = Action.async { implicit request =>
    Future.successful(Ok(views.html.bookclub.index()))
  }

  case class Author(guid: UUID, name: String)
  implicit val authorFormat = Json.format[Author]

  def findAuthors(name: String) = Action.async {
    Future.successful(Ok(Json.arr()))
  }

  def createAuthor = Action.auth.async(parse.json) { implicit request =>
    client.create[Author]("/authors", request.body).map { result =>
      result.fold(
        error => Conflict(error),
        author => Created(Json.toJson(author))
      )
    }
  }

  private def client()(implicit request: AuthRequest[_]) = {
    request.account.flatMap(_.uselessAccessToken).map { accessToken =>
      resourceClient.withAuth(accessToken.token)
    }.getOrElse {
      throw new RuntimeException("NEED TO FIGURE THIS OUT")
    }
  }

}
