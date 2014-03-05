package models.account

import java.util.UUID
import org.joda.time.DateTime
import org.specs2.mutable.{ Specification, Before }
import play.api.test.Helpers
import Helpers._
import play.api.libs.concurrent.Execution.Implicits.{defaultContext => executionContext}
import io.useless.util.mongo.MongoUtil

import mongo.AccountDocument
import AccountDocument._

class AccountSpec extends Specification {

  trait Context extends Before {
    def before = MongoUtil.clearDb()
  }

  "AccountDao.accountForGuid" should {
    "return the account corresponding to the specified GUID" in new Context {
      val accountDocument = createAccount()
      val optAccount = Helpers.await { Account.accountForGuid(accountDocument.guid) }
      optAccount.get.guid must beEqualTo(accountDocument.guid)
    }
  }

  def createAccount() = {
    val document = new AccountDocument(
      guid = UUID.randomUUID,
      email = None,
      handle = None,
      name = None,
      password = None,
      accessTokens = Seq.empty,
      createdAt = DateTime.now,
      updatedAt = DateTime.now,
      deletedAt = None
    )
    
    Helpers.await {
      Account.collection.insert(document).map { lastError =>
        if (lastError.ok) {
          Right(document)
        } else {
          throw lastError
        }
      }
    }.right.toOption.get
  }

}
