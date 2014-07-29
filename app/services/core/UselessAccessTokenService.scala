package services.core

import java.util.UUID
import scala.concurrent.Future
import play.api.libs.concurrent.Execution.Implicits._
import clients.core.useless.TrustedUselessClient

import models.core.account.{ Account, AccessToken, OAuthProvider }
import models.core.external.ExternalAccessToken

class UselessAccessTokenService(trustedUselessClient: TrustedUselessClient) {

  /**
   * Idempotently ensures that the account corresponding to the specified
   * `accountGuid` has a Useless access token. No guarantees are made about
   * thread safety.
   *
   * This method is made possible by the TrustedUselessClient, which provides
   * an API for creating Useless access token without OAuth. In order to
   * function, the TrustedUselessClient must use a Useless access token with
   * "Trusted" scope.
   *
   * The goal of this is to ease the sign-up process, and not force all new
   * users to go through an OAuth flow for Useless, which could be quite
   * confusing.
   */
  def ensureAccessToken(accountGuid: UUID): Future[Either[String, AccessToken]] = {

    def createAndAddAccessToken(
      account: Account,
      uselessAccountGuid: UUID
    ): Future[Either[String, AccessToken]] = {
      trustedUselessClient.createAccessToken(uselessAccountGuid).flatMap { result =>
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

    Account.accountForGuid(accountGuid).flatMap { optAccount =>
      optAccount.map { account =>
        if (account.uselessAccessToken.isDefined) {
          Future.successful(Right(account.uselessAccessToken.get))
        } else {
          account.email.map { email =>
            trustedUselessClient.getUserByEmail(email).flatMap { optUselessAccount =>
              optUselessAccount.map { uselessAccount =>
                createAndAddAccessToken(account, uselessAccount.guid)
              }.getOrElse {
                trustedUselessClient.createUser(email, account.handle, account.name).flatMap { result =>
                  result.fold(
                    error => Future.successful(Left(error)),
                    uselessAccount => createAndAddAccessToken(account, uselessAccount.guid)
                  )
                }
              }
            }
          }.getOrElse {
            Future.successful(Left("useless_access_token.error.no_account_email"))
          }
        }
      }.getOrElse {
        Future.successful(Left("useless_access_token.error.no_account_for_guid"))
      }
    }

  }

}
