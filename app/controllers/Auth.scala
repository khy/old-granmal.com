package controllers

import play.api._
import play.api.mvc._

object Auth extends Controller {

  lazy val config = Play.current.configuration

  def toUseless = Action {
    val baseUrl = config.getString("useless.auth.baseUrl").get
    val appGuid = config.getString("useless.account.guid").get
    val url = baseUrl + s"/auth?app_guid=$appGuid"
    Redirect(url)
  }

}
