package controllers.core

import scala.concurrent.Future
import play.api._
import play.api.mvc._
import play.api.data._
import play.api.data.Forms._
import play.api.libs.concurrent.Execution.Implicits.defaultContext

import controllers.auth.AuthKeys
import models.core.account.Account

object SessionController extends Controller {

  case class SignInData(email: String, password: String)

  val signInForm = Form {
    mapping(
      "email" -> email,
      "password" -> nonEmptyText
    )(SignInData.apply)(SignInData.unapply)
  }

  def form = Action { implicit request =>
    Ok(views.html.core.session.form(signInForm))
  }

  def create = Action.async { implicit request =>
    signInForm.bindFromRequest.fold(
      formWithErrors => {
        Future.successful(UnprocessableEntity(views.html.core.session.form(formWithErrors)))
      },
      signInData => {
        Account.auth(signInData.email, signInData.password).map { optAccount =>
          optAccount.map { account =>
            val redirectPath = request.cookies.get(AuthKeys.authRedirectPath).
              map(_.value).getOrElse("/")

            Redirect(redirectPath).
              withSession(session + (AuthKeys.session -> account.guid.toString)).
              discardingCookies(DiscardingCookie(AuthKeys.authRedirectPath)).
              flashing("success" -> "Signed in successfully")
          }.getOrElse {
            val formWithError = signInForm.fill(signInData).
              withGlobalError("Invalid email / password combination")

            Unauthorized(views.html.core.session.form(formWithError))
          }
        }
      }
    )
  }

  def delete = Action { implicit request =>
    Redirect("/").
      withSession(session - AuthKeys.session).
      flashing("success" -> "You have been signed out.")
  }

}
