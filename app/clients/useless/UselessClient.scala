package clients.useless

import scala.concurrent.Future
import play.api.Application
import play.api.libs.json.Json
import play.api.libs.concurrent.Execution.Implicits._
import io.useless.accesstoken.{ AccessToken => UselessAccessToken }
import io.useless.account.{ Account => UselessAccount, User }
import io.useless.play.json.accesstoken.AccessTokenJson._
import io.useless.play.json.account.AccountJson._

import clients.OAuthClient
import com.granmal.models.account.{ AccessToken, OAuthProvider }
import com.granmal.models.external.{ ExternalAccessToken, ExternalAccount }

object UselessClient {

  def instance()(implicit app: Application): UselessClient = new StandardUselessClient

}

trait UselessClient extends OAuthClient {

  def provider = OAuthProvider.Useless

}

class StandardUselessClient()(implicit protected val app: Application)
  extends UselessClient
  with CoreApplicationResourceClient
{

  def getAccessToken(code: String) = {
    val path = s"/access_tokens/authorizations/$code"
    resourceClient.create[UselessAccessToken](path, Json.obj()).map { result =>
      result.right.toOption.map { accessToken =>
        new ExternalAccessToken(
          oauthProvider = this.provider,
          accountId = accessToken.resourceOwner.guid.toString,
          token = accessToken.guid.toString,
          code = Some(code),
          scopes = accessToken.scopes.map(_.toString)
        )
      }
    }
  }

  def getAccount(accountId: String) = {
    val path = s"/accounts/${accountId}"
    resourceClient.get[UselessAccount](path).map { optAccount =>
      optAccount.map { account =>
        account match {
          case user: User => new ExternalAccount(
            email = None,
            handle = Some(user.handle),
            name = user.name
          )
          case other => throw new RuntimeException(s"Unexpected account type for GUID [$account.guid]")
        }
      }
    }
  }

}
