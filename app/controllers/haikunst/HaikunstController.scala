package controllers.haikunst

import scala.concurrent.Future
import play.api._
import play.api.mvc._
import play.api.libs.json._
import play.api.data._
import play.api.data.Forms._
import play.api.libs.concurrent.Execution.Implicits._

import controllers.auth.AuthAction._
import controllers.auth.AuthKeys
import clients.haikunst.UselessHaikuClient

object HaikunstController extends Controller {

  class HaikuPresenter(json: JsObject) {
    val firstLine: String = (json \ "lines")(0).as[String]
    val secondLine: String = (json \ "lines")(1).as[String]
    val thirdLine: String = (json \ "lines")(2).as[String]
    val author: String = (json \ "created_by" \ "name").as[String]
  }

  def index = Action.async {
    UselessHaikuClient.instance().getHaikus().map { haikuJsons =>
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
        Ok(views.html.haikunst.connectUseless())
      }
    }.getOrElse {
      Redirect(controllers.core.routes.SessionController.form).
        flashing("failure" -> "You must sign-in first.").
        withCookies(Cookie(AuthKeys.authRedirectPath, routes.HaikunstController.form.url))
    }
  }

  def create = Action.auth.async { implicit request =>
    request.account.map { account =>
      haikuForm.bindFromRequest.fold(
        formWithErrors => {
          Future.successful(InternalServerError)
        },
        haikuForm => {
          account.uselessAccessToken.map { accessToken =>
            val client = UselessHaikuClient.instance(Some(accessToken.token))
            val haiku = Seq(haikuForm.one, haikuForm.two, haikuForm.three)

            client.createHaiku(haiku).map { result =>
              result.fold(
                error => UnprocessableEntity(error),
                json => Ok(json.toString)
              )
            }
          }.getOrElse {
            Future.successful(UnprocessableEntity("Get more access tokens"))
          }
        }
      )
    }.getOrElse {
      Future.successful(UnprocessableEntity("Get more access tokens"))
    }

  }

  def menu = Action {
    Ok(views.html.haikunst.menu())
  }

}
