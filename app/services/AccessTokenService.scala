package services

import scala.concurrent.Future
import play.api.libs.concurrent.Execution.Implicits._

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
