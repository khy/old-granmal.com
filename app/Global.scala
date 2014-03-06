import play.api.{ Application, Logger }
import play.api.mvc.WithFilters
import io.useless.play.filter.{ AccessLogFilter, RequestTimeFilter }
import models.account.Account

object Global
  extends WithFilters(
    new AccessLogFilter,
    new RequestTimeFilter
  )
{

  override def onStart(app: Application) {
    Logger.info("Ensuring indexes...")
    Account.ensureIndexes()
  }

}
