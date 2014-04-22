package controllers.core

import play.api._
import play.api.mvc._
import Play.current

import controllers.auth.AuthAction._

object IndexController extends Controller {

  def index = Action { request =>
    Ok(views.html.core.index(shouldShowMasthead(request)))
  }

  def shouldShowMasthead[T](request: Request[T]): Boolean = {
    request.headers.get("Referer").map { referer =>
      val domain = Play.configuration.getString("application.domain").get
      !referer.contains(domain)
    }.getOrElse(true)
  }

}
