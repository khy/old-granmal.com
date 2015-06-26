package com.granmal.models.account.mongo

import reactivemongo.bson._
import java.util.UUID
import org.joda.time.DateTime
import io.useless.reactivemongo.bson.UuidBson._
import io.useless.reactivemongo.bson.DateTimeBson._

import com.granmal.models.account.AccessToken
import AccessTokenDocument._

class AccountDocument(
  val guid: UUID,
  val email: Option[String],
  val handle: Option[String],
  val name: Option[String],
  val password: Option[String],
  val accessTokens: Seq[AccessTokenDocument],
  val createdAt: DateTime,
  val updatedAt: DateTime,
  val deletedAt: Option[DateTime]
)

object AccountDocument {

  implicit object AccountDocumentReader extends BSONDocumentReader[AccountDocument] {
    def read(bsonDocument: BSONDocument): AccountDocument = {
      new AccountDocument(
        bsonDocument.getAsTry[UUID]("_id").get,
        bsonDocument.getAs[String]("email"),
        bsonDocument.getAs[String]("handle"),
        bsonDocument.getAs[String]("name"),
        bsonDocument.getAs[String]("password"),
        bsonDocument.getAsTry[Seq[AccessTokenDocument]]("access_tokens").get,
        bsonDocument.getAsTry[DateTime]("created_at").get,
        bsonDocument.getAsTry[DateTime]("updated_at").get,
        bsonDocument.getAs[DateTime]("deleted_at")
      )
    }
  }

  implicit object AccountDocumentWriter extends BSONDocumentWriter[AccountDocument] {
    def write(accountDocument: AccountDocument): BSONDocument = {
      BSONDocument(
        "_id" -> accountDocument.guid,
        "email" -> accountDocument.email,
        "handle" -> accountDocument.handle,
        "name" -> accountDocument.name,
        "password" -> accountDocument.password,
        "access_tokens" -> accountDocument.accessTokens,
        "created_at" -> accountDocument.createdAt,
        "updated_at" -> accountDocument.updatedAt,
        "deleted_at" -> accountDocument.deletedAt
      )
    }
  }

}
