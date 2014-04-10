package clients.haikunst

import java.util.UUID
import scala.concurrent.Future
import play.api.Play
import Play.current
import play.api.libs.concurrent.Execution.Implicits._
import play.api.libs.ws.WS
import play.api.libs.json._

object UselessHaikuClient {

  def instance(accessToken: Option[String] = None): UselessHaikuClient =
    new StandardUselessHaikuClient(accessToken)

}

trait UselessHaikuClient {

  def getHaikus(after: Option[String] = None): Future[Seq[JsObject]]

}

class StandardUselessHaikuClient(
  accessToken: Option[String]
) extends UselessHaikuClient {

  private lazy val baseUrl = {
    Play.configuration.getString("useless.haiku.baseUrl").getOrElse {
      throw new RuntimeException("useless.haiku.baseUrl not configured")
    }
  }

  def getHaikus(after: Option[String] = None) = {
    WS.url(baseUrl + "/haikus").get.map { response =>
      response.json.as[Seq[JsObject]]
    }
  }

}
