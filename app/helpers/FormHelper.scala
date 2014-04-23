package helpers

import play.api.data.Form
import play.api.i18n.Messages

object FormHelper {

  def displayFirstError[T](form: Form[T]) = {
    val formError = form.errors.head

    formError.message match {
      case "error.required" => Messages("error.key-required", formError.key.capitalize)
      case _ => Messages(formError.message)
    }
  }

}
