package models.account

import java.util.UUID

import OAuthProvider.OAuthProvider
import mongo.AccessTokenDocument

class AccessToken(val account: Account, document: AccessTokenDocument) {

  val guid = document.guid
  val oauthProvider = document.oauthProvider
  val accountId = document.accountId
  val code = document.code
  val token = document.token

}
