package controllers.budget

import scala.concurrent.Future
import play.api._
import play.api.mvc._
import play.api.libs.json._
import play.api.Play.current
import play.api.libs.concurrent.Execution.Implicits._

import com.granmal.auth.AuthAction._
import com.granmal.models.account.PublicAccount.Json._
import clients.budget.BudgetClient

object Assets extends controllers.AssetsBuilder

object Application extends Controller with BudgetClient {

  val configuration = Play.configuration

  def app(path: String = "") = Action.auth { implicit request =>
    val javascriptRouter = Routes.javascriptRouter()(
      routes.javascript.Application.bootstrap,
      routes.javascript.Transactions.create,
      routes.javascript.Accounts.create,
      routes.javascript.TransactionTypes.create
    )

    Ok(views.html.budget.app(javascriptRouter))
  }

  def bootstrap = Action.auth.async { implicit request =>
    optJsonClient().map { jsonClient =>
      val futTransactions = jsonClient.find("/transactions").map(_.items)
      val futAccounts = jsonClient.find("/accounts").map(_.items)
      val futAccountTypes = jsonClient.find("/accountTypes").map(_.items)
      val futTransactionTypes = jsonClient.find( "/transactionTypes").map(_.items)

      for {
        transactions <- futTransactions
        accounts <- futAccounts
        accountTypes <- futAccountTypes
        transactionTypes <- futTransactionTypes
      } yield {
        Ok(Json.obj(
          "account" -> Json.toJson(request.account.map(_.toPublic)),
          "transactions" -> transactions,
          "accounts" -> accounts,
          "accountTypes" -> accountTypes,
          "transactionTypes" -> transactionTypes
        ))
      }
    }.getOrElse {
      Future.successful(Ok(Json.obj()))
    }
  }

}
