package controllers.bookclub

import scala.concurrent.Future
import play.api._
import play.api.mvc._
import play.api.libs.json._
import play.api.libs.concurrent.Execution.Implicits._

import com.granmal.auth.AuthAction._

object Assets extends controllers.AssetsBuilder

object Application extends Controller {

  def index(path: String = "") = Action.async { implicit request =>
    Future.successful(Ok(views.html.bookclub.index()))
  }

  def findAuthors(name: String) = Action.async {
    Future.successful(Ok(Json.arr()))
  }

}
