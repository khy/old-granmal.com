package clients.core

import scala.concurrent.Future

import models.core.account.AccessToken
import models.core.account.OAuthProvider.OAuthProvider
import models.core.external.{ ExternalAccessToken, ExternalAccount }

trait OAuthClient {

  def provider: OAuthProvider

  def getAccessToken(code: String): Future[Option[ExternalAccessToken]]

  def getAccount(accountId: String): Future[Option[ExternalAccount]]

}
