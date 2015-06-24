package services

import java.util.UUID
import scala.concurrent.Future
import org.specs2.mutable.{ Specification, Before }
import play.api.test.Helpers
import Helpers._
import io.useless.util.mongo.MongoUtil
import io.useless.accesstoken.AccessToken
import io.useless.account.{ User, AuthorizedUser, App }

import com.granmal.models.account.{ Account, OAuthProvider }
import com.granmal.test.AccountFactory
import clients.useless.TrustedUselessClient

class UselessAccessTokenServiceSpec extends Specification {

  trait Context extends Before {
    def before = MongoUtil.clearDb("mongo.uri")
  }

  class MockTrustedUselessClient(
    accessToken: Option[AccessToken],
    private var users: Seq[AuthorizedUser]
  ) extends TrustedUselessClient {

    def getUserByEmail(email: String) = Future.successful {
      users.find(_.email == email)
    }

    def getUserByHandle(handle: String) = Future.successful {
      users.find(_.handle == handle)
    }

    def createUser(
      email: String,
      handle: String,
      name: Option[String]
    ) = Future.successful {
      val user = User.authorized(UUID.randomUUID, email, handle, name)
      users = users :+ user
      Right(user)
    }

    def createAccessToken(accountGuid: UUID) = Future.successful {
      users.find(_.guid == accountGuid).map { resourceOwner =>
        val newAccessToken = AccessToken(
          guid = UUID.randomUUID,
          resourceOwner = resourceOwner,
          client = accessToken.map(_.resourceOwner),
          scopes = Seq.empty
        )

        Right(newAccessToken)
      }.getOrElse {
        Left("No such user")
      }
    }

  }

  "UselessAccessTokenServiceSpec.MockTrustedUselessClient" should {

    "return a user specified at initialization from getUserByEmail" in new Context {
      val user = User.authorized(UUID.randomUUID, "khy@granmal.com", "khy", None)
      val client = new MockTrustedUselessClient(accessToken = None, users = Seq(user))
      val result = Helpers.await { client.getUserByEmail("khy@granmal.com") }
      result.get.guid must beEqualTo(user.guid)
    }

    "return a user from getUserByEmail created via createUser" in new Context {
      val client = new MockTrustedUselessClient(accessToken = None, users = Seq.empty)
      val result1 = Helpers.await { client.createUser("khy@granmal.com", "khy", None) }
      val user = result1.right.get
      val result2 = Helpers.await { client.getUserByEmail("khy@granmal.com") }
      result2.get.guid must beEqualTo(user.guid)
    }

    "return None from getUserByEmail if the user was never added" in new Context {
      val user = User.authorized(UUID.randomUUID, "khy@granmal.com", "khy", None)
      val client = new MockTrustedUselessClient(accessToken = None, users = Seq(user))
      val result = Helpers.await { client.getUserByEmail("bill@granmal.com") }
      result must beNone
    }

    "return a user specified at initialization from getUserByHandle" in new Context {
      val user = User.authorized(UUID.randomUUID, "khy@granmal.com", "khy", None)
      val client = new MockTrustedUselessClient(accessToken = None, users = Seq(user))
      val result = Helpers.await { client.getUserByHandle("khy") }
      result.get.guid must beEqualTo(user.guid)
    }

    "return a user from getUserByHandle created via createUser" in new Context {
      val client = new MockTrustedUselessClient(accessToken = None, users = Seq.empty)
      val result1 = Helpers.await { client.createUser("khy@granmal.com", "khy", None) }
      val user = result1.right.get
      val result2 = Helpers.await { client.getUserByHandle("khy") }
      result2.get.guid must beEqualTo(user.guid)
    }

    "return None from getUserByEmail if the user was never added" in new Context {
      val user = User.authorized(UUID.randomUUID, "khy@granmal.com", "khy", None)
      val client = new MockTrustedUselessClient(accessToken = None, users = Seq(user))
      val result = Helpers.await { client.getUserByHandle("bill") }
      result must beNone
    }

    "return Left from createAccessToken if the specified accountId doesn't " +
    "correspond to an added User's GUID" in new Context {
      val user = User.authorized(UUID.randomUUID, "khy@granmal.com", "khy", None)
      val client = new MockTrustedUselessClient(accessToken = None, users = Seq(user))
      val result = Helpers.await { client.createAccessToken(UUID.randomUUID) }
      result must beLeft
    }

    "return a new AccessToken from createAccessToken if the specified accountID " +
    "exists, with the specified AccessToken resource owner as client" in new Context {
      val app = App(guid = UUID.randomUUID, name = "Gran Mal", url = "granmal.com")
      val appAccessToken = AccessToken(
        guid = UUID.randomUUID, resourceOwner = app, client = None, scopes = Seq.empty
      )
      val user = User.authorized(UUID.randomUUID, "khy@granmal.com", "khy", None)
      val _client = new MockTrustedUselessClient(Some(appAccessToken), Seq(user))
      val result = Helpers.await { _client.createAccessToken(user.guid) }
      val newAccessToken = result.right.get
      newAccessToken.resourceOwner.guid must beEqualTo(user.guid)
      newAccessToken.client.get.guid must beEqualTo(app.guid)
    }

  }

  def buildService(
    accessToken: Option[AccessToken] = None,
    users: Seq[AuthorizedUser] = Seq.empty
  ) = {
    val client = new MockTrustedUselessClient(accessToken, users)
    new UselessAccessTokenService(client)
  }

  def factory = new AccountFactory(Account.collection)

  "UselessAccessTokenService#ensureAccessToken" should {

    "it should return Left if the specified account GUID is non-existant" in new Context {
      val service = buildService()
      val result = Helpers.await { service.ensureAccessToken(UUID.randomUUID) }
      result must beLeft
    }

    "it should return the access token with the Useless OAuth provider, if the " +
    "specified account has one" in new Context {
      val accessTokenDocument = factory.buildAccessTokenDocument(
        oauthProvider = OAuthProvider.Useless,
        code = Some("code")
      )
      val accountDocument = factory.buildAccountDocument(accessTokens = Seq(accessTokenDocument))
      val account = factory.createAccount(accountDocument)

      val service = buildService()
      val result = Helpers.await { service.ensureAccessToken(account.guid) }
      result.right.get.guid must beEqualTo(accessTokenDocument.guid)
    }

    "it should return a Left if the specified account doesn't have an email" in new Context {
      val accountDocument = factory.buildAccountDocument(handle = Some("khy"))
      val account = factory.createAccount(accountDocument)

      val service = buildService()
      val result = Helpers.await { service.ensureAccessToken(account.guid) }
      result must beLeft
    }

    "it should return a Left if the specified account doesn't have an handle" in new Context {
      val accountDocument = factory.buildAccountDocument(email = Some("khy@me.com"))
      val account = factory.createAccount(accountDocument)

      val service = buildService()
      val result = Helpers.await { service.ensureAccessToken(account.guid) }
      result must beLeft
    }

    "it should add an access token to the Useless user corresponding to the " +
    "account's email, and store it" in new Context {
      val accountDocument = factory.buildAccountDocument(email = Some("khy@granmal.com"), handle = Some("khy"))
      val account = factory.createAccount(accountDocument)

      val uselessUser = User.authorized(UUID.randomUUID, "khy@granmal.com", "khy", None)
      val service = buildService(users = Seq(uselessUser))
      Helpers.await { service.ensureAccessToken(account.guid) }
      val _account = Helpers.await{ account.reload() }
      _account.uselessAccessToken must not beNone
    }

    "it should add a Useless user and an access token, and store the access token" in new Context {
      val accountDocument = factory.buildAccountDocument(email = Some("khy@granmal.com"), handle = Some("khy"))
      val account = factory.createAccount(accountDocument)

      val service = buildService()
      Helpers.await { service.ensureAccessToken(account.guid) }
      val _account = Helpers.await{ account.reload() }
      _account.uselessAccessToken must not beNone
    }
  }

}
