package lib

import play.api.libs.json._

case class ValidationErrors(
  resource: Seq[String],
  attributes: Map[String, String]
)

object ValidationErrorsJson {

  implicit val formats = Json.format[ValidationErrors]

}
