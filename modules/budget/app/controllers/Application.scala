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
      routes.javascript.Accounts.create
    )

    Ok(views.html.budget.app(javascriptRouter))
  }

  def bootstrap = Action.auth.async { implicit request =>
    jsonClient().find("/accounts").map { page =>
      Ok(Json.obj(
        "account" -> Json.toJson(request.account.map(_.toPublic)),
        "accounts" -> Json.toJson(page.items)
      ))
    }
  }

}
