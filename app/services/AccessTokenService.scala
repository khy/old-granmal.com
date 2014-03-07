package services

import scala.concurrent.Future

import models.account.{ Account, AccessToken }
import clients.AuthClient

class AccessTokenService(authClient: AuthClient) {

  def ensureAccessToken(
    code: String,
    optAccount: Option[Account] = None
  ): Future[Either[String, AccessToken]] = {
    optAccount.map { account =>
      account.accessTokens.find(_.code == Some(code)).map { accessToken =>
        Future.successful { Right(accessToken) }
      }.getOrElse {
        Future.successful { Left("TODO") }
      }
    }.getOrElse {
      Future.successful { Left("TODO") }
    }
  }

}
