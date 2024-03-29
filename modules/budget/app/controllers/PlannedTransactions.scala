package controllers.budget

import scala.concurrent.Future
import play.api._
import play.api.mvc._
import play.api.Play.current
import play.api.libs.concurrent.Execution.Implicits._
import play.api.libs.json._

import com.granmal.auth.AuthAction._
import clients.budget.BudgetClient

object PlannedTransactions extends Controller with BudgetClient {

  val configuration = Play.configuration

  def create = Action.auth.async(parse.json) { implicit request =>
    jsonClient().create("/plannedTransactions", request.body).map { result =>
      result.fold(
        error => Conflict(error),
        plannedTransaction => Created(plannedTransaction)
      )
    }
  }

}
