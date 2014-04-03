package models.core.external

/**
 * An ExternalAccount is a normalized representation of a 3rd-party account.
 */
class ExternalAccount(
  val email: Option[String],
  val handle: Option[String],
  val name: Option[String]
)
