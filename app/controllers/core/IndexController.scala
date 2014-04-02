package controllers.core

import play.api._
import play.api.mvc._

import controllers.auth.AuthAction._

object IndexController extends Controller {

  def index = Action {
    Ok(views.html.core.index())
  }

}
