package models.account

import java.util.UUID

import OAuthProvider.OAuthProvider
import mongo.AccessTokenDocument

class AccessToken(val account: Account, document: AccessTokenDocument) {

  val guid = document.guid
  val oauthProvider = document.oauthProvider
  val code = document.code
  val token = document.token

}

/**
 * An ExternalAccessToken represents an access token that is not yet known by
 * GranMal. So, unlike a normal, known AccessToken, it doesn't have guid,
 * createdAt, etc., 
 */
class ExternalAccessToken(
  val oauthProvider: OAuthProvider,
  val token: String,
  val code: Option[String],
  val scopes: Seq[String]
)
