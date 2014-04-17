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

  def createHaiku(lines: Seq[String]): Future[Either[String, JsObject]]

}

class StandardUselessHaikuClient(
  accessToken: Option[String]
) extends UselessHaikuClient {

  private lazy val baseUrl = {
    Play.configuration.getString("useless.haiku.baseUrl").getOrElse {
      throw new RuntimeException("useless.haiku.baseUrl not configured")
    }
  }

  val collectionUrl = baseUrl + "/haikus"

  def getHaikus(after: Option[String] = None) = {
    WS.url(collectionUrl).get.map { response =>
      response.json.as[Seq[JsObject]]
    }
  }

  def createHaiku(lines: Seq[String]) = {
    accessToken.map { accessToken =>
      val futureResponse = WS.url(collectionUrl).
        withHeaders(("Authorization", accessToken)).
        post(Json.obj("lines" -> lines))

      futureResponse.map { response =>
        response.status match {
          case 201 => Right(response.json.as[JsObject])
          case _ => Left(response.body)
        }
      }
    }.getOrElse {
      Future.successful(Left("An access token is required to create haikus."))
    }

  }

}
