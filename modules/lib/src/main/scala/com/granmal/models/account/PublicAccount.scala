package com.granmal.models.account

import java.util.UUID
import play.api.libs.json

import com.granmal.helpers.OAuthUrlHelper

case class PublicAccount(
  guid: UUID,
  handle: Option[String],
  name: Option[String],
  oauth: PublicAccount.OAuth
)

object PublicAccount {

  case class OAuth(
    useless: OAuthProvider
  )

  case class OAuthProvider(
    linked: Boolean,
    url: String
  )

  def build(account: Account): PublicAccount = {
    PublicAccount(
      guid = account.guid,
      handle = account.handle,
      name = account.name,
      oauth = OAuth(
      useless = OAuthProvider(
        url = OAuthUrlHelper.uselessUrl,
        linked = account.uselessAccessToken.isDefined
      )
    ))
  }

  object Json {
    implicit val oauthProviderFormat = json.Json.format[OAuthProvider]
    implicit val oauthFormat = json.Json.format[OAuth]
    implicit val publicAccountFormat = json.Json.format[PublicAccount]
  }

}
