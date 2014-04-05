package controllers.haikunst

import play.api._
import play.api.mvc._

import controllers.auth.AuthAction._

object AppController extends Controller {

  def index = Action {
    Ok(views.html.haikunst.index())
  }

  def menu = Action {
    Ok(views.html.haikunst.menu())
  }

}
