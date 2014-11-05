package controllers.bookclub

import scala.concurrent.Future
import play.api._
import play.api.mvc._
import play.api.libs.json._
import play.api.libs.concurrent.Execution.Implicits._

import com.granmal.auth.AuthAction._

object Assets extends controllers.AssetsBuilder

object Application extends Controller {

  def index = Action.async {
    Future.successful(Ok(views.html.bookclub.index()))
  }

}
