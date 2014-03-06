package test.support

import java.util.UUID
import org.joda.time.DateTime
import reactivemongo.api.collections.default.BSONCollection
import play.api.libs.concurrent.Execution.Implicits._
import play.api.test.Helpers
import Helpers._

import models.account.AuthProvider
import models.account.mongo._

class AccountFactory(collection: BSONCollection) {

  def buildAccountDocument(accessTokens: Seq[AccessTokenDocument] = Seq.empty) = {
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

  def buildAccessTokenDocument(code: Option[String] = None) = {
    new AccessTokenDocument(
      guid = UUID.randomUUID,
      authProvider = AuthProvider.Useless,
      token = UUID.randomUUID.toString,
      code = code,
      scopes = Seq.empty,
      createdAt = DateTime.now,
      deletedAt = None
    )
  }

  def createAccount(): AccountDocument = {
    val document = buildAccountDocument()
    createAccount(document)
  }

  def createAccount(document: AccountDocument): AccountDocument = {
    Helpers.await {
      collection.insert(document).map { lastError =>
        if (lastError.ok) {
          Right(document)
        } else {
          throw lastError
        }
      }
    }.right.toOption.get
  }

}
