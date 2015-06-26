package com.granmal.helpers

import play.api.Play

object FontsHelper {

  lazy val config = Play.current.configuration

  def stylesheetUrl(family: String) = {
    config.getString("google.fonts.baseUrl").get + "/css?family=" + family
  }

}
