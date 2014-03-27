package controllers

import scala.concurrent.Future
import play.api._
import play.api.mvc._
import play.api.data._
import play.api.data.Forms._
import play.api.libs.concurrent.Execution.Implicits.defaultContext

import models.account.Account

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

  def create = Action.async { implicit request =>
    signInForm.bindFromRequest.fold(
      formWithErrors => {
        Future.successful(UnprocessableEntity(views.html.session.form(formWithErrors)))
      },
      signInData => {
        Account.auth(signInData.email, signInData.password).map { optAccount =>
          optAccount.map { account =>
            val redirectPath = request.cookies.get("sign_in_redirect_path").
              map(_.value).getOrElse("/")

            Redirect(redirectPath).
              withSession("auth" -> account.guid.toString).
              flashing("success" -> "Signed in successfully")
          }.getOrElse {
            val formWithError = signInForm.fill(signInData).
              withGlobalError("Invalid email / password combination")

            Unauthorized(views.html.session.form(formWithError))
          }
        }
      }
    )
  }

  def delete = Action { implicit request =>
    Redirect("/").
      withSession(session - "auth").
      flashing("success" -> "You have been signed out.")
  }

}
