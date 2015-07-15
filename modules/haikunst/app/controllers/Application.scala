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
        "haikus" -> Json.toJson(haikuJsons.map(buildHaikuPresenter))
      ))
    }
  }

  case class HaikuPresenter(
    firstLine: String,
    secondLine: String,
    thirdLine: String,
    authorName: String,
    authorHandle: String,
    authorUrl: String
  )

  implicit val hpFormat = Json.format[HaikuPresenter]

  def buildHaikuPresenter(json: JsObject) = {
    val authorHandle = (json \ "created_by" \ "handle").as[String]

    HaikuPresenter(
      firstLine = (json \ "lines")(0).as[String],
      secondLine = (json \ "lines")(1).as[String],
      thirdLine = (json \ "lines")(2).as[String],
      authorName = (json \ "created_by" \ "name").as[String],
      authorHandle = authorHandle,
      authorUrl = routes.Application.byUser(authorHandle).url
    )
  }

  def index = Action.async {
    anonymousClient.getHaikus().map { haikuJsons =>
      val haikus = haikuJsons.map(buildHaikuPresenter)
      Ok(views.html.haikunst.index(haikus))
    }
  }

  def byUser(handle: String) = Action.async {
    anonymousClient.getHaikus(handle = Some(handle)).map { haikuJsons =>
      val haikus = haikuJsons.map(buildHaikuPresenter)
      Ok(views.html.haikunst.index(haikus))
    }
  }

  case class HaikuData(one: String, two: String, three: String)

  val haikuForm = Form {
    mapping(
      "one" -> nonEmptyText,
      "two" -> nonEmptyText,
      "three" -> nonEmptyText
    )(HaikuData.apply)(HaikuData.unapply)
  }

  def form = Action.auth { request =>
    request.account.map { account =>
      account.uselessAccessToken.map { accessToken =>
        Ok(views.html.haikunst.form(haikuForm))
      }.getOrElse {
        throw new RuntimeException("You must have a useless account.")
      }
    }.getOrElse {
      Redirect("/sign-in").
        flashing("failure" -> "You must sign-in first.").
        withCookies(Cookie(AuthKeys.authRedirectPath, routes.Application.form.url))
    }
  }

  def create = Action.auth.async { implicit request =>
    request.account.map { account =>
      haikuForm.bindFromRequest.fold(
        formWithErrors => Future.successful {
          UnprocessableEntity(views.html.haikunst.form(formWithErrors))
        },
        haikuData => {
          account.uselessAccessToken.map { accessToken =>
            val client = UselessHaikuClient.instance(Some(accessToken.token))
            val haiku = Seq(haikuData.one, haikuData.two, haikuData.three)

            client.createHaiku(haiku).map { result =>
              result.fold(
                error => {
                  var formWithError = haikuForm.fill(haikuData)

                  Seq((0, "one"), (1, "two"), (2, "three")).foreach { case (index, key) =>
                    error(index).asOpt[String].foreach { error =>
                      formWithError = formWithError.withError(key, error)
                    }
                  }

                  Ok(views.html.haikunst.form(formWithError))
                },
                json => Redirect(routes.Application.app(""))
              )
            }
          }.getOrElse {
            Future.successful(Redirect(routes.Application.form))
          }
        }
      )
    }.getOrElse {
      Future.successful(Redirect(routes.Application.form))
    }
  }

  def menu = Action {
    Ok(views.html.haikunst.menu())
  }

}
