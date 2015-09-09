package controllers.budget

import scala.concurrent.Future
import play.api._
import play.api.mvc._
import play.api.libs.json._

import com.granmal.auth.AuthAction._

object Accounts extends Controller {

  def create = Action.auth {
    Created
  }

}
