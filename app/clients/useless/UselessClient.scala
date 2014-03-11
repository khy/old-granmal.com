package clients.useless

import scala.concurrent.Future
import play.api.libs.json.Json
import play.api.libs.concurrent.Execution.Implicits._
import io.useless.play.client.ResourceClient
import io.useless.accesstoken.AccessToken
import io.useless.play.json.accesstoken.AccessTokenJson._

import clients.OAuthClient
import models.account._

object UselessClient {

  def instance: UselessClient = new StandardUselessClient

}

trait UselessClient extends OAuthClient {

  def provider = OAuthProvider.Useless

  def getAccessToken(code: String): Future[Option[ExternalAccessToken]]

}

class StandardUselessClient
  extends UselessClient
  with ResourceClient
{

  def getAccessToken(code: String) = {
    val path = s"/access_tokens/authorizations/$code"
    resourceClient.create[AccessToken](path, Json.obj()).map { result =>
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

}
