package controllers.haikunst

import play.api._
import play.api.mvc._
import play.api.libs.json._
import play.api.libs.concurrent.Execution.Implicits._

import controllers.auth.AuthAction._
import clients.haikunst.UselessHaikuClient

object AppController extends Controller {

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

  def menu = Action {
    Ok(views.html.haikunst.menu())
  }

}
