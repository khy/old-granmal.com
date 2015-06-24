package clients.bookclub

import scala.concurrent.Future
import play.api.{Application, Configuration}
import play.api.mvc._
import io.useless.play.client._

import com.granmal.auth.AuthRequest

trait BooksClient {

  def configuration: Configuration

  lazy val baseUrl = configuration.underlying.getString("useless.books.baseUrl")
  lazy val appAccessTokenGuid = configuration.underlying.getString("useless.client.accessTokenGuid")

  def jsonClient()(implicit request: Request[_], app: Application): JsonClient = {
    val optAccessToken = request match {
      case authRequest: AuthRequest[_] => authRequest.account.flatMap { account =>
        account.uselessAccessToken.map(_.token)
      }
      case _ => None
    }

    val accessToken = optAccessToken.getOrElse(appAccessTokenGuid)
    JsonClient(baseUrl, accessToken)
  }

  def resourceClient()(implicit request: Request[_], app: Application): ResourceClient = {
    new DefaultResourceClient(jsonClient())
  }

}
