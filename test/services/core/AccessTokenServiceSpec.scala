package services.core

import java.util.UUID
import scala.concurrent.Future
import org.specs2.mutable.{ Specification, Before }
import play.api.test.Helpers
import Helpers._
import io.useless.util.mongo.MongoUtil

import com.granmal.models.external.{ ExternalAccessToken, ExternalAccount }
import com.granmal.models.account.{ Account, OAuthProvider }
import com.granmal.test.AccountFactory
import clients.core.OAuthClient

class AccessTokenServiceSpec extends Specification {

  trait Context extends Before {
    def before = MongoUtil.clearDb()
  }

  class MockAuthClient(
    accessToken: Option[ExternalAccessToken],
    account: Option[ExternalAccount]
  ) extends OAuthClient {
    val provider = OAuthProvider.Useless

    def getAccessToken(code: String) = Future.successful { accessToken }

    def getAccount(accountId: String) = Future.successful { account }
  }

  def buildService(
    accessToken: Option[ExternalAccessToken] = None,
    account: Option[ExternalAccount] = None
  ) = {
    val client = new MockAuthClient(accessToken, account)
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
      val externalAccessToken = new ExternalAccessToken(
        oauthProvider = OAuthProvider.Useless,
        accountId = UUID.randomUUID.toString,
        token = UUID.randomUUID.toString,
        code = Some("code"),
        scopes = Seq.empty
      )
      val service = buildService(Some(externalAccessToken))

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
    "account (with the attributes returned by the provider) if the " +
    "AuthClient returns an access token for the code" in new Context {
      val token = UUID.randomUUID.toString
      val externalAccessToken = new ExternalAccessToken(
        oauthProvider = OAuthProvider.Useless,
        accountId = UUID.randomUUID.toString,
        token = token,
        code = Some("code"),
        scopes = Seq.empty
      )
      val externalAccount = new ExternalAccount(
        email = Some("llewlyn@granmal.com"),
        handle = None,
        name = None
      )
      val service = buildService(Some(externalAccessToken), Some(externalAccount))

      val result = Helpers.await { service.ensureAccessToken("code", None) }
      val accessToken = result.right.get
      accessToken.token must beEqualTo(token)
      accessToken.code must beEqualTo(Some("code"))
      accessToken.account.email must beEqualTo(Some("llewlyn@granmal.com"))
    }

  }

}
