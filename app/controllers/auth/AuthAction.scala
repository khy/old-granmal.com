package controllers.auth

import java.util.UUID
import scala.concurrent.Future
import scala.concurrent.ExecutionContext.Implicits.global
import play.api.mvc._
import play.api.Logger

import models.core.account.Account

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
    Logger.debug("Attempting to authenticate request. Session: " + request.session)
    request.session.get(AuthKeys.session).map { accountGuidString =>
      Logger.debug(s"Found account GUID [${accountGuidString}] in 'auth'.")
      val accountGuid = UUID.fromString(accountGuidString)

      Account.accountForGuid(accountGuid).flatMap { optAccount =>
        val _request = new AuthRequest(optAccount, request)
        action(_request)
      }
    }.getOrElse {
      Logger.debug("No account GUID found in 'auth'.")
      val _request = new AuthRequest(None, request)
      action(_request)
    }
  }

}
