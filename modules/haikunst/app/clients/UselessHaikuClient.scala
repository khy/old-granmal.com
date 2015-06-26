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

  def getHaikus(
    handle: Option[String] = None,
    until: Option[String] = None
  ): Future[Seq[JsObject]]

  def createHaiku(lines: Seq[String]): Future[Either[JsArray, JsObject]]

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

  def getHaikus(
    handle: Option[String] = None,
    until: Option[String] = None
  ) = {
    var request = WS.url(collectionUrl)

    handle.foreach { handle =>
      request = request.withQueryString("user" -> handle)
    }

    until.foreach { until =>
      request = request.withQueryString("since" -> until)
    }

    request.get.map { response =>
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
          case _ => Left(response.json.as[JsArray])
        }
      }
    }.getOrElse {
      throw new RuntimeException("An access token is required to create haikus.")
    }
  }

}
