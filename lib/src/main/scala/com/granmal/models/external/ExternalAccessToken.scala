package com.granmal.models.external

import com.granmal.models.account.OAuthProvider.OAuthProvider

/**
 * An ExternalAccessToken represents an access token that is not yet known by
 * GranMal. So, unlike a normal, known AccessToken, it doesn't have guid,
 * createdAt, etc.,
 */
class ExternalAccessToken(
  val oauthProvider: OAuthProvider,
  val accountId: String,
  val token: String,
  val code: Option[String],
  val scopes: Seq[String]
)
