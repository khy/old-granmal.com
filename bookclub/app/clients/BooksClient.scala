package clients.bookclub

import scala.concurrent.Future
import play.api.mvc._
import io.useless.client.ClientConfiguration
import io.useless.util.Logger
import io.useless.play.client._

import com.granmal.auth.AuthRequest

trait BooksClient
  extends DefaultResourceClientComponent
  with    DefaultJsonClientComponent
  with    ConfigurableBaseClientComponent
  with    ClientConfiguration
  with    Logger
{

  override val baseUrlConfigKey = "useless.books.baseUrl"

  lazy val baseClient = new ConfigurableBaseClient

  def jsonClient = new DefaultJsonClient(baseClient)

  def resourceClient = new DefaultResourceClient(jsonClient)

  def withUselessClient(
    block: ResourceClient => Future[Result]
  )(
    implicit request: AuthRequest[_]
  ): Future[Result] = {
    request.account.map { account =>
      account.uselessAccessToken.map { accessToken =>
        val client = resourceClient.withAuth(accessToken.token)
        play.api.Logger.debug(s"Using Useless Books client for access token [${accessToken.token}]")
        block(client)
      }.getOrElse {
        Future.successful(Results.Unauthorized("Need access token"))
      }
    }.getOrElse {
      Future.successful(Results.Unauthorized("Need to log in"))
    }
  }

}
