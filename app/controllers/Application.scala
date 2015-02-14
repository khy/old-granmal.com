package controllers

import play.api._
import play.api.mvc._
import play.api.libs.json.Json

import com.granmal.auth.AuthRequest
import com.granmal.auth.AuthAction._
import com.granmal.models.account.PublicAccount.Json._

object Application extends Controller {

  def app(path: String = "") = Action.auth { implicit request =>
    Ok(views.html.app(
      appConfig = appConfig(),
      javascriptRouter = javascriptRouter()
    ))
  }

  private def appConfig[T]()(implicit request: AuthRequest[T]) = {
    var config = Json.obj()

    request.account.map(_.toPublic).foreach { account =>
      config = config ++ Json.obj("account" -> Json.toJson(account))
    }

    config
  }

  private def javascriptRouter()(implicit request: RequestHeader) = {
    import routes.javascript._

    Routes.javascriptRouter()(
      SessionController.create,
      SessionController.delete,
      AccountController.create
    )
  }

}
