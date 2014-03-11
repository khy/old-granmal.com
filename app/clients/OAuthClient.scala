package clients

import scala.concurrent.Future

import models.account.AccessToken
import models.account.OAuthProvider.OAuthProvider
import models.external.{ ExternalAccessToken, ExternalAccount }

trait OAuthClient {

  def provider: OAuthProvider

  def getAccessToken(code: String): Future[Option[ExternalAccessToken]]

  def getAccount(accessToken: AccessToken): Future[Option[ExternalAccount]]

}
