import play.api.{ Application, Logger }
import play.api.mvc.WithFilters
import io.useless.play.filter.{ AccessLogFilter, RequestTimeFilter }
import filters.HttpsRedirectFilter
import com.granmal.models.account.Account

object Global
  extends WithFilters(
    new AccessLogFilter,
    new RequestTimeFilter,
    new HttpsRedirectFilter
  )
{

  override def onStart(app: Application) {
    Logger.info("Ensuring indexes...")
    Account.ensureIndexes()
  }

}
