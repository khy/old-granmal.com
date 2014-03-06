package models.account.mongo

import reactivemongo.bson._
import java.util.UUID
import org.joda.time.DateTime
import io.useless.reactivemongo.bson.UuidBson._
import io.useless.reactivemongo.bson.DateTimeBson._

import models.account.AuthProvider._
import AuthProviderBson._

class AccessTokenDocument(
  val guid: UUID,
  val authProvider: AuthProvider,
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
        bsonDocument.getAsTry[AuthProvider]("auth_provider").get,
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
        "auth_provider" -> accessTokenDocument.authProvider,
        "token" -> accessTokenDocument.token,
        "code" -> accessTokenDocument.code,
        "scopes" -> accessTokenDocument.scopes,
        "created_at" -> accessTokenDocument.createdAt,
        "deleted_at" -> accessTokenDocument.deletedAt
      )
    }
  }

}
