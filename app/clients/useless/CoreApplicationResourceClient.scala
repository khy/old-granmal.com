package clients.useless

import play.api.{Play, Application}
import io.useless.play.client.ResourceClient

trait CoreApplicationResourceClient {

  implicit protected def app: Application

  lazy val resourceClient = {
    val baseUrl = Play.configuration.underlying.getString("useless.books.baseUrl")
    val auth = Play.configuration.underlying.getString("useless.client.baseUrl")
    ResourceClient(baseUrl, auth)
  }

}
