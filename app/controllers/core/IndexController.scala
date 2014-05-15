package controllers.core

import play.api._
import play.api.mvc._
import Play.current

import controllers.auth.AuthAction._

object IndexController extends Controller {

  def index = Action { implicit request =>
    if (shouldShowMasthead(request)) {
      Ok(views.html.core.masthead())
    } else {
      Ok(views.html.core.apps())
    }
  }

  def masthead = Action {
    Ok(views.html.core.masthead())
  }

  def apps = Action { implicit request =>
    Ok(views.html.core.apps())
  }

  private def shouldShowMasthead[T](request: Request[T]): Boolean = {
    request.headers.get("Referer").map { referer =>
      val domain = Play.configuration.getString("application.domain").get
      !referer.contains(domain)
    }.getOrElse(true)
  }

}
