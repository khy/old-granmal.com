package clients

import scala.concurrent.Future

import models.account.ExternalAccessToken

trait AuthClient {

  def getAccessToken(code: String): Future[Option[ExternalAccessToken]]

}
