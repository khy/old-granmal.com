package models.account

import java.util.UUID
import scala.concurrent.Future
import reactivemongo.bson._
import play.api.libs.concurrent.Execution.Implicits._
import io.useless.reactivemongo.MongoAccess
import io.useless.reactivemongo.bson.UuidBson._

import mongo.AccountDocument

object Account extends MongoAccess {

  private[account] lazy val collection = mongo.collection("accounts")

  def accountForGuid(guid: UUID) = findOne("_id" -> guid)

  def accountForAccessTokenCode(code: String) = findOne("access_tokens.code" -> code)

  private def findOne(query: Producer[(String, BSONValue)]*): Future[Option[Account]] = {
    collection.find(BSONDocument(query:_*)).one[AccountDocument].map { optDocument =>
      optDocument.map { document => new Account(document) }
    }
  }

}

class Account(document: AccountDocument) {

  def guid = document.guid

  def accessTokens = document.accessTokens

}
