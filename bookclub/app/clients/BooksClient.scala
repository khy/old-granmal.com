package clients.bookclub

import scala.concurrent.Future
import play.api.mvc._
import io.useless.client.ClientConfiguration
import io.useless.util.Logger
import io.useless.play.client._

import com.granmal.auth.AuthRequest

trait BooksClient
  extends DefaultResourceClientComponent
  with    ConfigurableBaseClientComponent
  with    ClientConfiguration
  with    Logger
{

  override val baseUrlConfigKey = "useless.books.baseUrl"

  lazy val baseClient = new ConfigurableBaseClient

  def resourceClient = new DefaultResourceClient(baseClient)

  def withUselessClient(
    block: ResourceClient => Future[Result]
  )(
    implicit request: AuthRequest[_]
  ): Future[Result] = {
    request.account.map { account =>
      account.uselessAccessToken.map { accessToken =>
        val client = resourceClient.withAuth(accessToken.token)
        block(client)
      }.getOrElse {
        Future.successful(Results.Unauthorized("Need access token"))
      }
    }.getOrElse {
      Future.successful(Results.Unauthorized("Need to log in"))
    }
  }

}
