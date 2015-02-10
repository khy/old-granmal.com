package controllers

import play.api._
import play.api.mvc._

import com.granmal.auth.AuthAction._

object Application extends Controller {

  def app(path: String = "") = Action.auth { request =>
    Ok(views.html.app(request.account.map(_.toPublic)))
  }

}
