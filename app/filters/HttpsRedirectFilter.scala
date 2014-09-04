package filters

import scala.concurrent.Future
import play.api.mvc._
import play.api.libs.concurrent.Execution.Implicits._
import play.api.Play
import Play.current

class HttpsRedirectFilter extends Filter with Results {

  lazy val optRequiredProtocol = Play.configuration.getString("application.protocol")

  override def apply(next: RequestHeader => Future[Result])(request: RequestHeader): Future[Result] = {
    val requestHasRequiredProtocol =
      request.headers.get("X-Forwarded-Proto").flatMap { requestProtocol =>
        optRequiredProtocol.map { requiredProtocol =>
          requestProtocol == requiredProtocol
        }
      }.getOrElse(true)

    if (requestHasRequiredProtocol) {
      next(request)
    } else {
      optRequiredProtocol.map { requiredProtocol =>
        val redirectLocation = requiredProtocol + "://" + request.host + request.uri
        Future.successful(MovedPermanently(redirectLocation))
      }.getOrElse(next(request))
    }
  }

}
