package com.granmal.helpers

import java.net.URI

object UrlHelper {

  def getRawQueryString(url: String): Option[String] = {
    Option(new URI(url).getRawQuery)
  }

}
