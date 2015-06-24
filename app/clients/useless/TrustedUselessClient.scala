package clients.useless

import java.util.UUID
import scala.concurrent.Future
import play.api.Application
import play.api.libs.json.Json
import play.api.libs.concurrent.Execution.Implicits._
import io.useless.play.client.ResourceClient
import io.useless.accesstoken.{ AccessToken => UselessAccessToken }
import io.useless.account.{ Account => UselessAccount }
import io.useless.play.json.accesstoken.AccessTokenJson._
import io.useless.play.json.account.AccountJson._

object TrustedUselessClient {

  def instance()(implicit app: Application): TrustedUselessClient = new StandardTrustedUselessClient

}

trait TrustedUselessClient {

  def getUserByEmail(email: String): Future[Option[UselessAccount]]

  def getUserByHandle(handle: String): Future[Option[UselessAccount]]

  def createUser(
    email: String,
    handle: String,
    name: Option[String]
  ): Future[Either[String, UselessAccount]]

  def createAccessToken(accountGuid: UUID): Future[Either[String, UselessAccessToken]]

}

class StandardTrustedUselessClient()(implicit protected val app: Application)
  extends TrustedUselessClient
  with CoreApplicationResourceClient
{

  def getUserByEmail(email: String) = {
    resourceClient.find[UselessAccount]("/accounts", "email" -> email).map { accounts =>
      accounts.items.headOption
    }
  }

  def getUserByHandle(handle: String) = {
    resourceClient.find[UselessAccount]("/accounts", "handle" -> handle).map { accounts =>
      accounts.items.headOption
    }
  }

  def createUser(
    email: String,
    handle: String,
    name: Option[String]
  ) = {
    val body = Json.obj(
      "email" -> email,
      "handle" -> handle,
      "name" -> name
    )

    resourceClient.create[UselessAccount]("/users", body)
  }

  def createAccessToken(accountGuid: UUID) = {
    val path = s"/accounts/$accountGuid/access_tokens"
    resourceClient.create[UselessAccessToken](path, Json.obj())
  }

}
