package controllers.auth

import java.util.UUID
import scala.concurrent.Future
import scala.concurrent.ExecutionContext.Implicits.global
import play.api.mvc._

import models.account.Account

object AuthAction {

  implicit class ActionWithAuth(action: ActionBuilder[Request]) {
    def auth = AuthActionBuilder
  }

}

class AuthRequest[A](
  val account: Option[Account],
  private val request: Request[A]
) extends WrappedRequest[A](request)

object AuthActionBuilder extends ActionBuilder[AuthRequest] {

  def invokeBlock[A](
    request: Request[A],
    action: AuthRequest[A] => Future[SimpleResult]
  ): Future[SimpleResult] = {
    request.session.get("auth").map { accountGuidString =>
      val accountGuid = UUID.fromString(accountGuidString)

      Account.accountForGuid(accountGuid).flatMap { optAccount =>
        val _request = new AuthRequest(optAccount, request)
        action(_request)
      }
    }.getOrElse {
      val _request = new AuthRequest(None, request)
      action(_request)
    }
  }

}
