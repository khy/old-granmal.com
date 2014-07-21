package services.core

import java.util.UUID
import scala.concurrent.Future
import play.api.libs.concurrent.Execution.Implicits._
import clients.core.useless.TrustedUselessClient

import models.core.account.{ Account, AccessToken, OAuthProvider }
import models.core.external.ExternalAccessToken

class UselessAccessTokenService(trustedUselessClient: TrustedUselessClient) {

  // Need to avoid creating access tokens when I already have one.
  def ensureAccessToken(account: Account): Future[Either[String, AccessToken]] = {

    def createAndAddAccessToken(accountGuid: UUID): Future[Either[String, AccessToken]] = {
      trustedUselessClient.createAccessToken(accountGuid).flatMap { result =>
        result.fold(
          error => Future.successful(Left(error)),
          accessToken => {
            val externalAccessToken = new ExternalAccessToken(
              oauthProvider = OAuthProvider.Useless,
              accountId = accessToken.resourceOwner.guid.toString,
              token = accessToken.guid.toString,
              code = None,
              scopes = accessToken.scopes.map(_.toString)
            )

            account.addAccessToken(externalAccessToken)
          }
        )
      }
    }

    account.email.map { email =>
      trustedUselessClient.getUserByEmail(email).flatMap { optAccount =>
        optAccount.map { account =>
          createAndAddAccessToken(account.guid)
        }.getOrElse {
          trustedUselessClient.createUser(email, account.handle, account.name).flatMap { result =>
            result.fold(
              error => Future.successful(Left(error)),
              account => createAndAddAccessToken(account.guid)
            )
          }
        }
      }
    }.getOrElse {
      Future.successful(Left("access_token.error.no_account_email"))
    }

  }

}
