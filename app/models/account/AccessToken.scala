package models.account

trait AccessToken {

  def guid: UUID

  def provider: Provider

  def accessToken: String

  def code: Option[String]

  def scopes: Seq[String]

}
