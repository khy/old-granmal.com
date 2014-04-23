package helpers

import play.api.data.Form

object FormHelper {

  def displayError[T](form: Form[T]) = form.errors.head.message

}
