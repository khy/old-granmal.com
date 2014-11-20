package clients.bookclub

import io.useless.client.ClientConfiguration
import io.useless.util.LoggerComponent
import io.useless.play.client._


trait BooksClient
  extends DefaultResourceClientComponent
  with    ConfigurableBaseClientComponent
  with    ClientConfiguration
  with    LoggerComponent
{

  override val baseUrlConfigKey = "useless.books.baseUrl"

  lazy val logger = play.api.Logger

  lazy val baseClient = new ConfigurableBaseClient

  def resourceClient = new DefaultResourceClient(baseClient)

}
