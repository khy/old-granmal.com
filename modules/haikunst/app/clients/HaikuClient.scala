package clients.haikunst

import java.util.UUID
import scala.concurrent.{Future, ExecutionContext}
import play.api.{Application, Play}
import play.api.libs.ws.WS
import play.api.libs.json._

object HaikuClient {

  def anon()(implicit ec: ExecutionContext, app: Application): AnonHaikuClient = {
    new DefaultAnonHaikuClient()
  }

  def auth(accessToken: String)(implicit ec: ExecutionContext, app: Application): AuthHaikuClient = {
    new DefaultAuthHaikuClient(accessToken)
  }

}

trait AnonHaikuClient {

  def getHaikus(
    handle: Option[String] = None,
    until: Option[String] = None
  ): Future[Seq[JsObject]]

}

trait AuthHaikuClient extends AnonHaikuClient {

  def createHaiku(lines: Seq[String]): Future[Either[JsArray, JsObject]]

}

class DefaultAnonHaikuClient()(implicit ec: ExecutionContext, app: Application) extends AnonHaikuClient {

  protected lazy val baseUrl = {
    Play.configuration.getString("useless.haiku.baseUrl").getOrElse {
      throw new RuntimeException("useless.haiku.baseUrl not configured")
    }
  }

  protected lazy val collectionUrl = baseUrl + "/haikus"

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

}

class DefaultAuthHaikuClient(
  accessToken: String
)(implicit ec: ExecutionContext, app: Application) extends DefaultAnonHaikuClient with AuthHaikuClient {

  def createHaiku(lines: Seq[String]) = {
    val futureResponse = WS.url(collectionUrl).
      withHeaders(("Authorization", accessToken)).
      post(Json.obj("lines" -> lines))

    futureResponse.map { response =>
      response.status match {
        case 201 => Right(response.json.as[JsObject])
        case _ => Left(response.json.as[JsArray])
      }
    }
  }

}
