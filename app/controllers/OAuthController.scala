package controllers

import play.api._
import play.api.mvc._
import play.api.libs.concurrent.Execution.Implicits._

import auth.AuthAction._
import clients.useless.UselessClient
import services.AccessTokenService

object OAuthController extends Controller {

  def useless(code: String) = Action.auth.async { request =>
    val uselessClient = UselessClient.instance
    val accessTokenService = new AccessTokenService(uselessClient)

    accessTokenService.ensureAccessToken(code, request.account).map { result =>
      result.fold(
        error => Redirect("/").
          flashing("error" -> s"Connection with useless.io failed: ${error}"),
        accessToken => Redirect("/").
          withSession("auth" -> accessToken.account.guid.toString).
          flashing("success" -> "Connected successfully with useless.io")
      )
    }
  }

}
