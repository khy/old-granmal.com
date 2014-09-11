package controllers

import play.api._
import play.api.mvc._

import controllers.auth.AuthAction._

object MenuController extends Controller {

  def main = Action.auth { request =>
    Ok(views.html.menu.main(request.account))
  }

}
