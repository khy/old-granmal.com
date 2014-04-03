package helpers.core

import play.api.Play

object OAuthUrlHelper {

  lazy val config = Play.current.configuration

  def uselessUrl = {
    val baseUrl = config.getString("useless.auth.baseUrl").get
    val appGuid = config.getString("useless.account.guid").get
    baseUrl + s"/auth?app_guid=$appGuid"
  }

}
