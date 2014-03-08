package models.account

import java.util.UUID
import scala.concurrent.Future
import org.joda.time.DateTime
import reactivemongo.bson._
import reactivemongo.api.indexes.{ Index, IndexType }
import play.api.libs.concurrent.Execution.Implicits._
import io.useless.reactivemongo.MongoAccess
import io.useless.reactivemongo.bson.UuidBson._

import AuthProvider.AuthProvider
import mongo._

object Account extends MongoAccess {

  private[account] lazy val collection = mongo.collection("accounts")

  def ensureIndexes() {
    collection.indexesManager.ensure(new Index(
      key = Seq(
        "access_tokens.auth_provider" -> IndexType.Ascending,
        "access_tokens.code" -> IndexType.Ascending
      ),
      unique = true
    ))
  }

  def accountForGuid(guid: UUID) = findOne("_id" -> guid)

  def accountForAccessTokenCode(authProvider: AuthProvider, code: String) =
    findOne("access_tokens.code" -> code)

  private def findOne(query: Producer[(String, BSONValue)]*): Future[Option[Account]] = {
    collection.find(BSONDocument(query:_*)).one[AccountDocument].map { optDocument =>
      optDocument.map { document => new Account(document) }
    }
  }

}

class Account(document: AccountDocument) {

  def guid = document.guid
  def accessTokens = document.accessTokens.map { new AccessToken(this, _) }

  def reload() = Account.accountForGuid(guid).map { optAccount =>
    optAccount.getOrElse {
      throw new RuntimeException(s"Mongo could not find _id [$guid]")
    }
  }

  def addAccessToken(externalAccessToken: ExternalAccessToken): Future[Either[String, AccessToken]] = {
    val accessTokenDocument = new AccessTokenDocument(
      guid = UUID.randomUUID,
      authProvider = externalAccessToken.authProvider,
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
