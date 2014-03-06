package models.account.mongo

import reactivemongo.bson._

import models.account.AuthProvider
import AuthProvider._

object AuthProviderBson {

  implicit object AuthProviderReader extends BSONReader[BSONString, AuthProvider] {
    def read(bson: BSONString): AuthProvider = AuthProvider.withName(bson.value)
  }

  implicit object AuthProviderWriter extends BSONWriter[AuthProvider, BSONString] {
    def write(authProvider: AuthProvider): BSONString = new BSONString(authProvider.toString)
  }

}
