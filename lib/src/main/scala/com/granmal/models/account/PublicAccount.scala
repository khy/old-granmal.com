package com.granmal.models.account

import java.util.UUID
import play.api.libs.json


case class PublicAccount(
  guid: UUID,
  handle: Option[String],
  name: Option[String]
)

object PublicAccount {

  object Json {
    implicit val publicAccountFormat = json.Json.format[PublicAccount]
  }

}
