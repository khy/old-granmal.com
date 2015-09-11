package clients.budget

import play.api.{Application, Configuration}
import play.api.mvc._
import io.useless.play.client._

import com.granmal.auth.AuthRequest

trait BudgetClient {

  def configuration: Configuration

  lazy val baseUrl = configuration.underlying.getString("useless.budget.baseUrl")

  def jsonClient()(implicit request: Request[_], app: Application): JsonClient = {
    optJsonClient().getOrElse {
      throw new RuntimeException("must be logged in to use budget")
    }
  }

  def optJsonClient()(implicit request: Request[_], app: Application): Option[JsonClient] = {
    val optAccessToken = request match {
      case authRequest: AuthRequest[_] => authRequest.account.flatMap { account =>
        account.uselessAccessToken.map(_.token)
      }
      case _ => None
    }

    optAccessToken.map { accessToken =>
      JsonClient(baseUrl, accessToken)
    }
  }

}
