package services

import scala.concurrent.Future
import play.api.libs.concurrent.Execution.Implicits._

import models.account.{ Account, AccessToken }
import clients.AuthClient

class AccessTokenService(authClient: AuthClient) {

  /**
   * If an access token corresponding to the specified code exists, this method
   * ensures that it is added to some account document, unless it has been
   * already. If the code does not belong to an access token, a Left is returned.
   *
   * If an Account instance is specified, the returned access token is
   * guaranteed to belong to that account.
   *
   * The possible outcomes of this method are:
   *   * an existing access token is returned.
   *   * an access token is added to an existing account, and is returned.
   *   * a new account is created, an access token is added to it, and is
   *     returned.
   *
   * It also takes care not to use the same code to retrieve an access token
   * more than once, since OAuth suggests that the server delete access tokens
   * for which this occurs. Thread safety in this respect is left up to the
   * AuthClient. So, concurrent requests for a single code MAY result in
   * multiple requests, depending upon the implementation of the AuthClient.
   */
  def ensureAccessToken(
    code: String,
    optAccount: Option[Account] = None
  ): Future[Either[String, AccessToken]] = {
    optAccount.map { account =>
      account.accessTokens.find(_.code == Some(code)).map { accessToken =>
        Future.successful { Right(accessToken) }
      }.getOrElse {
        authClient.getAccessToken(code).flatMap { optAccessToken =>
          optAccessToken.map { accessToken =>
            account.addAccessToken(accessToken)
          }.getOrElse {
            Future.successful { Left("access_token.error.unknown_code") }
          }
        }
      }
    }.getOrElse {
      Account.accountForAccessTokenCode(authClient.authProvider, code).flatMap { optAccount =>
        optAccount.flatMap { account =>
          account.accessTokens.find(_.code == Some(code)).map { accessToken =>
            Future.successful { Right(accessToken) }
          }
        }.getOrElse {
          authClient.getAccessToken(code).flatMap { optAccessToken =>
            optAccessToken.map { accessToken =>
              Account.create().flatMap { result =>
                result.fold(
                  error => Future.successful { Left(error) },
                  account => account.addAccessToken(accessToken)
                )
              }
            }.getOrElse {
              Future.successful { Left("access_token.error.unknown_code") }
            }
          }
        }
      }
    }
  }

}
