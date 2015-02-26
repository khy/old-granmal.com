package com.granmal.models.account

import java.util.UUID
import play.api.mvc._
import play.api.test._
import play.api.test.Helpers._
import org.scalatest._
import org.scalatestplus.play._
import io.useless.util.mongo.MongoUtil

import mongo.AccountDocument
import AccountDocument._
import com.granmal.models.external.ExternalAccessToken
import com.granmal.test.AccountFactory

class AccountSpec
  extends PlaySpec
  with OneAppPerSuite
  with BeforeAndAfterEach
{

  override def beforeEach = {
    MongoUtil.clearDb()
    Account.ensureIndexes()
  }

  def factory = new AccountFactory(Account.collection)

  "Account.accountForGuid" should {
    "return None for a non-existant GUID" in {
      val optAccount = await { Account.accountForGuid(UUID.randomUUID) }
      optAccount must be (None)
    }

    "return the account corresponding to the specified GUID" in {
      val accountDocument = factory.createAccount()
      val optAccount = await { Account.accountForGuid(accountDocument.guid) }
      optAccount.get.guid must equal (accountDocument.guid)
    }
  }

  "Account.accountForAccessTokenCode" should {
    "return None for a non-existant access token code" in {
      val optAccount = await {
        Account.accountForAccessTokenCode(OAuthProvider.Useless, "non-existant-code")
      }
      optAccount must be (None)
    }

    "return the account with an access token with the specified code" in {
      val accessTokenDocument = factory.buildAccessTokenDocument(
        oauthProvider = OAuthProvider.Useless,
        code = Some("code")
      )
      val accountDocument = factory.buildAccountDocument(accessTokens = Seq(accessTokenDocument))
      factory.createAccount(accountDocument)

      val optAccount = await {
        Account.accountForAccessTokenCode(OAuthProvider.Useless, "code")
      }
      val accessToken = optAccount.get.accessTokens.head
      accessToken.oauthProvider must equal (OAuthProvider.Useless)
      accessToken.code must equal (Some("code"))
    }
  }

  "Account.create" should {
    "create an empty account if no parameters are specified" in {
      val account = await { Account.create() }.right.get
      account.email must be (None)
      account.handle must be (None)
      account.name must be (None)
      account.password must be (None)
    }

    "return an error if the email is invalid" in {
      val result = await { Account.create(email = Some("khy@me")) }
      result must be (Left("'khy@me' is not a valid email."))
    }

    "return an error if the email has already been used" in {
      await { Account.create(email = Some("khy@me.com")) }
      val result = await { Account.create(email = Some("khy@me.com")) }
      result must be (Left("'khy@me.com' has already been used."))
    }

    "return an error if the handle is invalid" in {
      val result = await { Account.create(handle = Some("Kevin Hyland")) }
      result must be (Left("'Kevin Hyland' is not a valid handle."))
    }

    "return an error if the handle has already been used" in {
      await { Account.create(handle = Some("khy")) }
      val result = await { Account.create(handle = Some("khy")) }
      result must be (Left("'khy' has already been used."))
    }
  }

  "Account.auth" should {
    "return None if the specified email does not exist" in {
      val account = await { Account.auth("non-existant@granmal.com", "secret") }
      account must be (None)
    }

    "return None if the specified email exists, but the password is wrong" in {
      await { Account.create(email = Some("john@granmal.com"), password = Some("secret")) }
      val account = await { Account.auth("john@granmal.com", "private") }
      account must be (None)
    }

    "return an Account if the specified email exists and the password is correct" in {
      await { Account.create(email = Some("john@granmal.com"), password = Some("secret")) }
      val account = await { Account.auth("john@granmal.com", "secret") }
      account.get.email must equal (Some("john@granmal.com"))
    }
  }

  "Account#addAccessToken" should {
    "add the specified ExternalAccessToken to the Account" in {
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

      val _account = await { account.reload() }
      _account.accessTokens.find(_.token == token) must be ('defined)
    }
  }

}
