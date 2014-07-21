package test.support

import java.util.UUID
import org.joda.time.DateTime
import reactivemongo.api.collections.default.BSONCollection
import play.api.libs.concurrent.Execution.Implicits._
import play.api.test.Helpers
import Helpers._

import models.core.account._
import models.core.account.mongo._
import OAuthProvider.OAuthProvider

class AccountFactory(collection: BSONCollection) {

  def buildAccountDocument(
    email: Option[String] = None,
    password: Option[String] = None,
    accessTokens: Seq[AccessTokenDocument] = Seq.empty
  ) = {
    new AccountDocument(
      guid = UUID.randomUUID,
      email = None,
      handle = None,
      name = None,
      password = None,
      accessTokens = accessTokens,
      createdAt = DateTime.now,
      updatedAt = DateTime.now,
      deletedAt = None
    )
  }

  def buildAccessTokenDocument(
    code: Option[String] = None,
    accountId: String = UUID.randomUUID.toString,
    oauthProvider: OAuthProvider = OAuthProvider.Useless
  ) = {
    new AccessTokenDocument(
      guid = UUID.randomUUID,
      oauthProvider = oauthProvider,
      accountId = accountId,
      token = UUID.randomUUID.toString,
      code = code,
      scopes = Seq.empty,
      createdAt = DateTime.now,
      deletedAt = None
    )
  }

  def createAccount(): Account = {
    val document = buildAccountDocument()
    createAccount(document)
  }

  def createAccount(document: AccountDocument): Account = {
    Helpers.await {
      collection.insert(document).map { lastError =>
        if (lastError.ok) {
          Right(document)
        } else {
          throw lastError
        }
      }
    }.right.toOption.map(new Account(_)).get
  }

}
