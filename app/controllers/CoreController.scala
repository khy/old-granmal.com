package controllers

import play.api._
import play.api.mvc._

import auth.AuthAction._

object CoreController extends Controller {

  def index = Action {
    Ok(views.html.core.index())
  }

  def menu = Action.auth { request =>
    Ok(views.html.core.menu())
  }

}