package models.account

import java.util.UUID

import AuthProvider.AuthProvider
import mongo.AccessTokenDocument

class AccessToken(document: AccessTokenDocument) {

  val guid = document.guid

  val authProvider = document.authProvider

  val code = document.code

}

/**
 * An ExternalAccessToken represents an access token that is not yet known by
 * GranMal. So, unlike a normal, known AccessToken, it doesn't have guid,
 * createdAt, etc., 
 */
class ExternalAccessToken(
  val authProvider: AuthProvider,
  val token: String,
  val code: Option[String],
  val scopes: Seq[String]
)
