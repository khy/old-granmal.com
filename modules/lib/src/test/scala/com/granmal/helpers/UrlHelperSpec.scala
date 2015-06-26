package com.granmal.helpers

import org.scalatest.{ WordSpec, MustMatchers }

class UrlHelperSpec extends WordSpec with MustMatchers {

  "UrlHelper.getRawQueryString" should {

    "return the raw query string part of the specified URL" in {
      val url = "http://localhost:8996/notes?p.limit=2&p.page=2"
      val rawQueryString = UrlHelper.getRawQueryString(url)
      rawQueryString mustBe Some("p.limit=2&p.page=2")
    }

    "return None if the specified URL has no query string part" in {
      val url = "http://localhost:8996/notes"
      val rawQueryString = UrlHelper.getRawQueryString(url)
      rawQueryString mustBe None
    }

  }

}
