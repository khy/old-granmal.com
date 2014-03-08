package clients

import scala.concurrent.Future

import models.account.ExternalAccessToken
import models.account.OAuthProvider.OAuthProvider

trait OAuthClient {

  def provider: OAuthProvider

  def getAccessToken(code: String): Future[Option[ExternalAccessToken]]

}
