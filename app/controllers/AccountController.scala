package controllers

import scala.concurrent.Future
import play.api._
import play.api.mvc._
import play.api.libs.json._
import play.api.data._
import play.api.data.Forms._
import play.api.libs.concurrent.Execution.Implicits.defaultContext

import com.granmal.models.account.PublicAccount.Json._
import com.granmal.auth.AuthKeys
import com.granmal.models.account.Account

import clients.useless.TrustedUselessClient
import services.UselessAccessTokenService

object AccountController extends Controller {

  case class SignUpData(
    email: String,
    password: String,
    handle: String,
    name: String
  )

  val signUpForm = Form {
    mapping(
      "email" -> email,
      "password" -> nonEmptyText,
      "handle" -> nonEmptyText,
      "name" -> nonEmptyText
    )(SignUpData.apply)(SignUpData.unapply)
  }

  def form = Action { implicit request =>
    Ok(views.html.account.form(signUpForm))
  }

  def create = Action.async { implicit request =>
    signUpForm.bindFromRequest.fold(
      formWithErrors => {
        Future.successful(UnprocessableEntity(views.html.account.form(formWithErrors)))
      },
      signUpData => {
        Account.create(
          Some(signUpData.email),
          Some(signUpData.handle),
          Some(signUpData.name),
          Some(signUpData.password)
        ).flatMap { result =>
          result.fold(
            error => {
              Future.successful(UnprocessableEntity(error))
            },
            account => {
              val trustedUselessClient = TrustedUselessClient.instance
              val uselessAccessTokenService = new UselessAccessTokenService(trustedUselessClient)

              uselessAccessTokenService.ensureAccessToken(account.guid).map { result =>
                result.fold(
                  error => Logger.warn(s"Could not ensure Useless access token [${error}]"),
                  accessToken => Logger.debug(s"Useless access token ensured [${accessToken.guid}]")
                )

                Created(Json.toJson(account.toPublic)).
                  withSession(request.session + (AuthKeys.session -> account.guid.toString))
              }
            }
          )
        }
      }
    )
  }

}
