package models.account

trait Account {

  def guid: UUID

  def email: Option[String]

  def handle: Option[String]

  def name: Option[String]

  def password: Option[String]

  def accessTokens: Seq[AccessToken]

}
