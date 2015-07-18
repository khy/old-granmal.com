package controllers.haikunst

import scala.concurrent.Future
import play.api._
import play.api.mvc._
import play.api.libs.json._
import play.api.data._
import play.api.data.Forms._
import play.api.libs.concurrent.Execution.Implicits._

import com.granmal.models.account.PublicAccount.Json._
import com.granmal.auth.AuthAction._
import com.granmal.auth.AuthKeys
import clients.haikunst.UselessHaikuClient

object Assets extends controllers.AssetsBuilder

object Application extends Controller {

  val anonymousClient = UselessHaikuClient.instance()

  def app(path: String = "") = Action.auth { implicit request =>
    Ok(views.html.haikunst.app(buildJavascriptRouter()))
  }

  private def buildJavascriptRouter()(implicit request: RequestHeader) = {
    import routes.javascript

    Routes.javascriptRouter()(
      javascript.Application.bootstrap,
      javascript.Application.create
    )
  }

  def bootstrap = Action.auth.async { request =>
    anonymousClient.getHaikus().map { haikuJsons =>
      Ok(Json.obj(
        "account" -> Json.toJson(request.account.map(_.toPublic)),
        "haikus" -> haikuJsons
      ))
    }
  }

  private case class HaikuCreateData(one: String, two: String, three: String)
  private implicit val hcdReads = Json.reads[HaikuCreateData]

  def create = Action.auth.async(parse.json) { implicit request =>
    request.account.map { account =>
      request.body.validate[HaikuCreateData].fold(
        error => Future.successful(InternalServerError),
        data => account.uselessAccessToken.map { accessToken =>
          val client = UselessHaikuClient.instance(Some(accessToken.token))
          val haiku = Seq(data.one, data.two, data.three)

          client.createHaiku(haiku).map { result =>
            result.fold(
              error => Conflict(error),
              json => Created(json)
            )
          }
        }.getOrElse {
          Future.successful(Unauthorized)
        }
      )
    }.getOrElse {
      Future.successful(Unauthorized)
    }
  }

}
