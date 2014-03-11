package models.account

import java.util.UUID
import scala.concurrent.Future
import org.joda.time.DateTime
import reactivemongo.bson._
import reactivemongo.api.indexes.{ Index, IndexType }
import play.api.libs.concurrent.Execution.Implicits._
import io.useless.reactivemongo.MongoAccess
import io.useless.reactivemongo.bson.UuidBson._

import OAuthProvider.OAuthProvider
import mongo._
import models.external.ExternalAccessToken

object Account extends MongoAccess {

  private[account] lazy val collection = mongo.collection("accounts")

  def ensureIndexes() {
    collection.indexesManager.ensure(new Index(
      key = Seq(
        "access_tokens.oauth_provider" -> IndexType.Ascending,
        "access_tokens.code" -> IndexType.Ascending
      ),
      unique = true
    ))
  }

  def accountForGuid(guid: UUID) = findOne("_id" -> guid)

  def accountForAccessTokenCode(oauthProvider: OAuthProvider, code: String) =
    findOne("access_tokens.oauth_provider" -> oauthProvider.toString, "access_tokens.code" -> code)

  def create(
    email: Option[String] = None,
    handle: Option[String] = None,
    name: Option[String] = None
  ): Future[Either[String, Account]] = {
     val accountDocument = new AccountDocument(
      guid = UUID.randomUUID,
      email = email,
      handle = handle,
      name = name,
      password = None,
      accessTokens = Seq.empty,
      createdAt = DateTime.now,
      updatedAt = DateTime.now,
      deletedAt = None
    )

    collection.insert(accountDocument).map { lastError =>
      if (lastError.ok) {
        Right(new Account(accountDocument))
      } else {
        throw lastError
      }
    }
  }

  private def findOne(query: Producer[(String, BSONValue)]*): Future[Option[Account]] = {
    collection.find(BSONDocument(query:_*)).one[AccountDocument].map { optDocument =>
      optDocument.map { document => new Account(document) }
    }
  }

}

class Account(document: AccountDocument) {

  def guid = document.guid
  def email = document.email
  def handle = document.handle
  def name = document.name
  def password = document.password
  def accessTokens = document.accessTokens.map { new AccessToken(this, _) }

  def reload() = Account.accountForGuid(guid).map { optAccount =>
    optAccount.getOrElse {
      throw new RuntimeException(s"Mongo could not find _id [$guid]")
    }
  }

  def addAccessToken(externalAccessToken: ExternalAccessToken): Future[Either[String, AccessToken]] = {
    val accessTokenDocument = new AccessTokenDocument(
      guid = UUID.randomUUID,
      oauthProvider = externalAccessToken.oauthProvider,
      accountId = externalAccessToken.accountId,
      token = externalAccessToken.token,
      code = externalAccessToken.code,
      scopes = externalAccessToken.scopes,
      createdAt = DateTime.now,
      deletedAt = None
    )

    val query = BSONDocument("_id" -> guid)
    val update = BSONDocument(
      "$push" -> BSONDocument("access_tokens" -> accessTokenDocument)
    )

    Account.collection.update(query, update).map { lastError =>
      if (lastError.ok) {
        Right(new AccessToken(this, accessTokenDocument))
      } else {
        throw lastError
      }
    }
  }

}
