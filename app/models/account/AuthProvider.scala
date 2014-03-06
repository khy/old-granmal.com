package models.account

object AuthProvider extends Enumeration {
  type AuthProvider = Value

  val Useless = Value("useless")
}
