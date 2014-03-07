package models.account

import java.util.UUID
import scala.concurrent.Future
import org.specs2.mutable.{ Specification, Before }
import play.api.test.Helpers
import Helpers._
import io.useless.util.mongo.MongoUtil

import clients.AuthClient
import services.AccessTokenService
import test.support.AccountFactory

class AccessTokenServiceSpec extends Specification {

  trait Context extends Before {
    def before = MongoUtil.clearDb()
  }

  class MockAuthClient(accessTokens: ExternalAccessToken*) extends AuthClient {
    def getAccessToken(code: String) = Future.successful {
      accessTokens.find(_.code == code)
    }
  }

  def buildService(accessTokens: ExternalAccessToken*) = {
    val client = new MockAuthClient(accessTokens: _*)
    new AccessTokenService(client)
  }

  def factory = new AccountFactory(Account.collection)

  "AccessTokenService#ensureAccessToken" should {

    "it should return the access token with the specified code, if the specified account has one" in new Context {
      val accessTokenDocument = factory.buildAccessTokenDocument(
        authProvider = AuthProvider.Useless,
        code = Some("code")
      )
      val accountDocument = factory.buildAccountDocument(accessTokens = Seq(accessTokenDocument))
      val account = factory.createAccount(accountDocument)

      val service = buildService()
      val optAccessToken = Helpers.await { service.ensureAccessToken("code", Some(account)) }
      optAccessToken.right.get.guid must beEqualTo(accessTokenDocument.guid)
    }

  }

}
