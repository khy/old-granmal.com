package clients.useless

import java.util.UUID
import scala.concurrent.Future
import play.api.libs.json.Json
import play.api.libs.concurrent.Execution.Implicits._
import io.useless.play.client.ResourceClient
import io.useless.accesstoken.{ AccessToken => UselessAccessToken }
import io.useless.account.{ Account => UselessAccount }
import io.useless.play.json.accesstoken.AccessTokenJson._
import io.useless.play.json.account.AccountJson._

object TrustedUselessClient {

  def instance: TrustedUselessClient = new StandardTrustedUselessClient

}

trait TrustedUselessClient {

  def getUserByEmail(email: String): Future[Option[UselessAccount]]

  def createUser(
    email: String,
    handle: Option[String],
    name: Option[String]
  ): Future[Either[String, UselessAccount]]

  def createAccessToken(accountGuid: UUID): Future[Either[String, UselessAccessToken]]

}

class StandardTrustedUselessClient
  extends TrustedUselessClient
  with ResourceClient
{

  def getUserByEmail(email: String) = {
    resourceClient.find[UselessAccount]("/accounts", "email" -> email).map { accounts =>
      accounts.headOption
    }
  }

  def createUser(
    email: String,
    handle: Option[String],
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
