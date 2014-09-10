package clients.core

import scala.concurrent.Future

import com.granmal.models.account.AccessToken
import com.granmal.models.account.OAuthProvider.OAuthProvider
import com.granmal.models.external.{ ExternalAccessToken, ExternalAccount }

trait OAuthClient {

  def provider: OAuthProvider

  def getAccessToken(code: String): Future[Option[ExternalAccessToken]]

  def getAccount(accountId: String): Future[Option[ExternalAccount]]

}
