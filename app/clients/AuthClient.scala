package clients

import scala.concurrent.Future

import models.account.ExternalAccessToken
import models.account.AuthProvider.AuthProvider

trait AuthClient {

  def authProvider: AuthProvider

  def getAccessToken(code: String): Future[Option[ExternalAccessToken]]

}
