package controllers.haikunst

import scala.concurrent.Future
import play.api._
import play.api.mvc._
import play.api.libs.json._
import play.api.data._
import play.api.data.Forms._
import play.api.libs.concurrent.Execution.Implicits._

import com.granmal.auth.AuthAction._
import com.granmal.auth.AuthKeys
import clients.haikunst.UselessHaikuClient

object Assets extends controllers.AssetsBuilder

object Application extends Controller {

  def app(path: String = "") = Action.auth { request =>
    Ok(views.html.haikunst.app())
  }

  class HaikuPresenter(json: JsObject) {
    val firstLine: String = (json \ "lines")(0).as[String]
    val secondLine: String = (json \ "lines")(1).as[String]
    val thirdLine: String = (json \ "lines")(2).as[String]
    val authorName: String = (json \ "created_by" \ "name").as[String]
    val authorHandle = (json \ "created_by" \ "handle").as[String]
    val authorUrl = routes.Application.byUser(authorHandle)
  }

  lazy val anonymousClient = UselessHaikuClient.instance()

  def index = Action.async {
    anonymousClient.getHaikus().map { haikuJsons =>
      val haikus = haikuJsons.map(new HaikuPresenter(_))
      Ok(views.html.haikunst.index(haikus))
    }
  }

  def byUser(handle: String) = Action.async {
    anonymousClient.getHaikus(handle = Some(handle)).map { haikuJsons =>
      val haikus = haikuJsons.map(new HaikuPresenter(_))
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
