package services.core

import java.util.UUID
import scala.concurrent.Future
import play.api.libs.concurrent.Execution.Implicits._
import play.api.Logger

import clients.core.useless.TrustedUselessClient
import com.granmal.models.account.{ Account, AccessToken, OAuthProvider }
import com.granmal.models.external.ExternalAccessToken

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
            Logger.debug(s"Created Useless access token found for account [${account.guid}].")

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
          val accessToken = account.uselessAccessToken.get
          Logger.debug(s"Found existing Useless access token [${accessToken.guid}] for account [${account.guid}].")
          Future.successful(Right(accessToken))
        } else {
          account.email.map { email =>
            trustedUselessClient.getUserByEmail(email).flatMap { optUselessAccount =>
              optUselessAccount.map { uselessAccount =>
                Logger.debug(s"Useless account [${uselessAccount.guid}] found for email [${email}].")
                createAndAddAccessToken(account, uselessAccount.guid)
              }.getOrElse {
                trustedUselessClient.createUser(email, account.handle, account.name).flatMap { result =>

                  result.fold(
                    error => Future.successful(Left(error)),
                    uselessAccount => {
                      Logger.debug(s"Created Useless account for email [${email}].")
                      createAndAddAccessToken(account, uselessAccount.guid)
                    }
                  )
                }
              }
            }
          }.getOrElse {
            Logger.debug(s"Could not ensure Useless acess token for account [${account.guid}] because it had no email.")
            Future.successful(Left("useless_access_token.error.no_account_email"))
          }
        }
      }.getOrElse {
        Logger.debug(s"Could not ensure Useless acess token for account [${accountGuid}] because there is no such GUID.")
        Future.successful(Left("useless_access_token.error.no_account_for_guid"))
      }
    }

  }

}
