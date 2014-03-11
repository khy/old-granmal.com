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

  "Account.accountForGuid" should {
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

  "Account.accountForAccessTokenCode" should {
    "return None for a non-existant access token code" in new Context {
      val optAccount = Helpers.await {
        Account.accountForAccessTokenCode(OAuthProvider.Useless, "non-existant-code")
      }
      optAccount must beNone
    }

    "return the account with an access token with the specified code" in new Context {
      val accessTokenDocument = factory.buildAccessTokenDocument(
        oauthProvider = OAuthProvider.Useless,
        code = Some("code")
      )
      val accountDocument = factory.buildAccountDocument(accessTokens = Seq(accessTokenDocument))
      factory.createAccount(accountDocument)

      val optAccount = Helpers.await {
        Account.accountForAccessTokenCode(OAuthProvider.Useless, "code")
      }
      val accessToken = optAccount.get.accessTokens.head
      accessToken.oauthProvider must beEqualTo(OAuthProvider.Useless)
      accessToken.code must beEqualTo(Some("code"))
    }
  }

  "Account.create" should {
    "create an empty account if no parameters are specified" in new Context {
      val account = Helpers.await { Account.create() }.right.get
      account.email should beNone
      account.handle should beNone
      account.name should beNone
      account.password should beNone
    }
  }

  "Account#addAccessToken" should {
    "add the specified ExternalAccessToken to the Account" in new Context {
      val token = UUID.randomUUID.toString
      val externalAccessToken = new ExternalAccessToken(
        oauthProvider = OAuthProvider.Useless,
        accountId = UUID.randomUUID.toString,
        token = token,
        code = None,
        scopes = Seq.empty
      )

      val accountDocument = factory.buildAccountDocument()
      val account = factory.createAccount(accountDocument)
      account.addAccessToken(externalAccessToken)

      val _account = Helpers.await { account.reload() }
      _account.accessTokens.find(_.token == token) must beSome
    }
  }

}
