package com.granmal.models.account.mongo

import reactivemongo.bson._
import java.util.UUID
import org.joda.time.DateTime
import io.useless.reactivemongo.bson.UuidBson._
import io.useless.reactivemongo.bson.DateTimeBson._

import com.granmal.models.account.OAuthProvider._
import OAuthProviderBson._

class AccessTokenDocument(
  val guid: UUID,
  val oauthProvider: OAuthProvider,
  val accountId: String,
  val token: String,
  val code: Option[String],
  val scopes: Seq[String],
  val createdAt: DateTime,
  val deletedAt: Option[DateTime]
)

object AccessTokenDocument {

  implicit object AccessTokenDocumentReader extends BSONDocumentReader[AccessTokenDocument] {
    def read(bsonDocument: BSONDocument): AccessTokenDocument = {
      new AccessTokenDocument(
        bsonDocument.getAsTry[UUID]("_id").get,
        bsonDocument.getAsTry[OAuthProvider]("oauth_provider").get,
        bsonDocument.getAsTry[String]("account_id").get,
        bsonDocument.getAsTry[String]("token").get,
        bsonDocument.getAs[String]("code"),
        bsonDocument.getAsTry[Seq[String]]("scopes").get,
        bsonDocument.getAsTry[DateTime]("created_at").get,
        bsonDocument.getAs[DateTime]("deleted_at")
      )
    }
  }

  implicit object AccessTokenDocumentWriter extends BSONDocumentWriter[AccessTokenDocument] {
    def write(accessTokenDocument: AccessTokenDocument): BSONDocument = {
      BSONDocument(
        "_id" -> accessTokenDocument.guid,
        "oauth_provider" -> accessTokenDocument.oauthProvider,
        "account_id" -> accessTokenDocument.accountId,
        "token" -> accessTokenDocument.token,
        "code" -> accessTokenDocument.code,
        "scopes" -> accessTokenDocument.scopes,
        "created_at" -> accessTokenDocument.createdAt,
        "deleted_at" -> accessTokenDocument.deletedAt
      )
    }
  }

}
