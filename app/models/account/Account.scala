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

  def accountForGuid(guid: UUID): Future[Option[Account]] = {
    collection.find(BSONDocument("_id" -> guid)).one[AccountDocument].map { optDocument =>
      optDocument.map { document => new Account(document) }
    }
  }

}

class Account(document: AccountDocument) {

  def guid = document.guid

}
