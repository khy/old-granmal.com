package models.account

import java.util.UUID
import scala.concurrent.Future
import org.specs2.mutable.{ Specification, Before }
import play.api.test.Helpers
import Helpers._
import io.useless.util.mongo.MongoUtil

import models.external.ExternalAccessToken
import clients.OAuthClient
import services.AccessTokenService
import test.support.AccountFactory

class AccessTokenServiceSpec extends Specification {

  trait Context extends Before {
    def before = MongoUtil.clearDb()
  }

  class MockAuthClient(accessTokens: ExternalAccessToken*) extends OAuthClient {
    val provider = OAuthProvider.Useless

    def getAccessToken(code: String) = Future.successful {
      accessTokens.find(_.code == Some(code))
    }

    def getAccount(accessToken: AccessToken) = Future.successful(None)
  }

  def buildService(accessTokens: ExternalAccessToken*) = {
    val client = new MockAuthClient(accessTokens: _*)
    new AccessTokenService(client)
  }

  def factory = new AccountFactory(Account.collection)

  "AccessTokenService#ensureAccessToken" should {

    "it should return the access token with the specified code, if the " +
    "specified account has one" in new Context {
      val accessTokenDocument = factory.buildAccessTokenDocument(
        oauthProvider = OAuthProvider.Useless,
        code = Some("code")
      )
      val accountDocument = factory.buildAccountDocument(accessTokens = Seq(accessTokenDocument))
      val account = factory.createAccount(accountDocument)

      val service = buildService()
      val result = Helpers.await { service.ensureAccessToken("code", Some(account)) }
      result.right.get.guid must beEqualTo(accessTokenDocument.guid)
    }

    "it should return an error if the specified account does not have an " + 
    "access token corresponding to the specified code, and the AuthClient " +
    "returns None for the code" in new Context {
      val accountDocument = factory.buildAccountDocument()
      val account = factory.createAccount(accountDocument)
      val service = buildService()
      val result = Helpers.await { service.ensureAccessToken("code", Some(account)) }
      result must beLeft
    }

    "it should return a newly created access token if the specified account " +
    "does not have an access token corresponding to the specified code, and " +
    "the AuthClient returns an access token for the code" in new Context {
      val accountDocument = factory.buildAccountDocument()
      val account = factory.createAccount(accountDocument)
      val service = buildService(new ExternalAccessToken(
        oauthProvider = OAuthProvider.Useless,
        accountId = UUID.randomUUID.toString,
        token = UUID.randomUUID.toString,
        code = Some("code"),
        scopes = Seq.empty
      ))

      val result = Helpers.await { service.ensureAccessToken("code", Some(account)) }
      val accessToken = result.right.get
      val _account = Helpers.await { account.reload() }
      _account.accessTokens.find(_.guid == accessToken.guid) must beSome
    }

    "it should return the access token for the specified code, if one exists" +
    "for any account" in new Context {
      val accessTokenDocument = factory.buildAccessTokenDocument(
        oauthProvider = OAuthProvider.Useless,
        code = Some("code")
      )
      val accountDocument = factory.buildAccountDocument(accessTokens = Seq(accessTokenDocument))
      val account = factory.createAccount(accountDocument)

      val service = buildService()
      val result = Helpers.await { service.ensureAccessToken("code", None) }
      result.right.get.guid must beEqualTo(accessTokenDocument.guid)
    }

    "it should return an error if the AuthClient returns None for the code" in new Context {
      val service = buildService()
      val result = Helpers.await { service.ensureAccessToken("code", None) }
      result must beLeft
    }

    "it should return a newly created access token for a newly created " +
    "account if the AuthClient returns an access token for the code" in new Context {
      val token = UUID.randomUUID.toString
      val service = buildService(new ExternalAccessToken(
        oauthProvider = OAuthProvider.Useless,
        accountId = UUID.randomUUID.toString,
        token = token,
        code = Some("code"),
        scopes = Seq.empty
      ))

      val result = Helpers.await { service.ensureAccessToken("code", None) }
      val accessToken = result.right.get
      accessToken.token must beEqualTo(token)
      accessToken.code must beEqualTo(Some("code"))
    }

  }

}
