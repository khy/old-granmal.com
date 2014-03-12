package controllers

import play.api._
import play.api.mvc._

object CoreController extends Controller {

  def index = Action {
    Ok(views.html.core.index())
  }

}
