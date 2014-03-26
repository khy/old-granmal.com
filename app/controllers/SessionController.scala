package controllers

import play.api._
import play.api.mvc._
import play.api.data._
import play.api.data.Forms._

object SessionController extends Controller {

  case class SignInData(email: String, password: String)

  val signInForm = Form {
    mapping(
      "email" -> email,
      "password" -> nonEmptyText
    )(SignInData.apply)(SignInData.unapply)
  }

  def form = Action {
    Ok(views.html.session.form(signInForm))
  }

  def create = Action {
    Ok("Hiya!")
  }

  def delete = Action { implicit request =>
    Redirect("/").
      withSession(session - "auth").
      flashing("success" -> "You have been signed out.")
  }

}
