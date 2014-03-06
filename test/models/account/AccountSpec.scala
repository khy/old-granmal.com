package models.account

import java.util.UUID
import org.specs2.mutable.{ Specification, Before }
import play.api.test.Helpers
import Helpers._
import io.useless.util.mongo.MongoUtil

import mongo.AccountDocument
import AccountDocument._
import test.support.AccountFactory

class AccountSpec extends Specification {

  trait Context extends Before {
    def before = MongoUtil.clearDb()
  }

  def factory = new AccountFactory(Account.collection)

  "AccountDao.accountForGuid" should {
    "return None for a non-existant GUID" in new Context {
      val optAccount = Helpers.await { Account.accountForGuid(UUID.randomUUID) }
      optAccount must beNone
    }

    "return the account corresponding to the specified GUID" in new Context {
      val accountDocument = factory.createAccount()
      val optAccount = Helpers.await { Account.accountForGuid(accountDocument.guid) }
      optAccount.get.guid must beEqualTo(accountDocument.guid)
    }
  }

  "AccountDao.accountForAccessTokenCode" should {
    "return None for a non-existant access token code" in new Context {
      val optAccount = Helpers.await {
        Account.accountForAccessTokenCode(AuthProvider.Useless, "non-existant-code")
      }
      optAccount must beNone
    }

    "return the account with an access token with the specified code" in new Context {
      val accessTokenDocument = factory.buildAccessTokenDocument(
        authProvider = AuthProvider.Useless,
        code = Some("code")
      )
      val accountDocument = factory.buildAccountDocument(accessTokens = Seq(accessTokenDocument))
      factory.createAccount(accountDocument)

      val optAccount = Helpers.await {
        Account.accountForAccessTokenCode(AuthProvider.Useless, "code")
      }
      val accessToken = optAccount.get.accessTokens.head
      accessToken.authProvider must beEqualTo(AuthProvider.Useless)
      accessToken.code must beEqualTo(Some("code"))
    }
  }

}
