package controllers.budget

import scala.concurrent.Future
import play.api._
import play.api.mvc._
import play.api.libs.json._

import com.granmal.auth.AuthAction._
import com.granmal.models.account.PublicAccount.Json._

object Assets extends controllers.AssetsBuilder

object Application extends Controller {

  def app(path: String = "") = Action.auth { implicit request =>
    val javascriptRouter = Routes.javascriptRouter()(
      routes.javascript.Application.bootstrap,
      routes.javascript.Accounts.create
    )

    Ok(views.html.budget.app(javascriptRouter))
  }

  def bootstrap = Action.auth.async { request =>
    Future.successful {
      Ok(Json.obj(
        "account" -> Json.toJson(request.account.map(_.toPublic))
      ))
    }
  }

}
