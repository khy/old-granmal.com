package controllers.core

import scala.concurrent.Future
import play.api._
import play.api.mvc._
import play.api.data._
import play.api.data.Forms._
import play.api.libs.concurrent.Execution.Implicits.defaultContext

import controllers.auth.AuthKeys
import models.core.account.Account

object AccountController extends Controller {

  case class SignUpData(
    email: String,
    name: String,
    handle: String,
    password: String
  )

  val signUpForm = Form {
    mapping(
      "email" -> email,
      "name" -> text,
      "handle" -> text,
      "password" -> nonEmptyText
    )(SignUpData.apply)(SignUpData.unapply)
  }

  def form = Action {
    Ok(views.html.core.account.form(signUpForm))
  }

  def create = Action.async { implicit request =>
    signUpForm.bindFromRequest.fold(
      formWithErrors => {
        Future.successful(UnprocessableEntity(views.html.core.account.form(formWithErrors)))
      },
      signUpData => {
        Account.create(
          Some(signUpData.email),
          Some(signUpData.handle),
          Some(signUpData.name),
          Some(signUpData.password)
        ).map { result =>
          result.fold(
            error => {
              val formWithError = signUpForm.fill(signUpData).withGlobalError(error)
              UnprocessableEntity(views.html.core.account.form(formWithError))
            },
            account => {
              val redirectPath = request.cookies.get("auth_redirect_path").
                map(_.value).getOrElse("/")

              Redirect(redirectPath).
                withSession(AuthKeys.session -> account.guid.toString).
                flashing("success" -> "Signed up successfully")
            }
          )
        }
      }
    )
  }

}
