package models.account.mongo

import reactivemongo.bson._

import models.account.OAuthProvider
import OAuthProvider._

object OAuthProviderBson {

  implicit object OAuthProviderReader extends BSONReader[BSONString, OAuthProvider] {
    def read(bson: BSONString): OAuthProvider = OAuthProvider.withName(bson.value)
  }

  implicit object AuthProviderWriter extends BSONWriter[OAuthProvider, BSONString] {
    def write(oauthProvider: OAuthProvider): BSONString = new BSONString(oauthProvider.toString)
  }

}
