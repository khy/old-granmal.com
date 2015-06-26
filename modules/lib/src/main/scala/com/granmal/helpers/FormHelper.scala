package com.granmal.helpers

import play.api.data.Field
import com.granmal.views.html.form

object FormHelper {

  def textField(placeholder: String, field: Field) = {
    form.inputField("text", placeholder, field)
  }

  def emailField(placeholder: String, field: Field) = {
    form.inputField("email", placeholder, field)
  }

  def passwordField(placeholder: String, field: Field) = {
    form.passwordField(placeholder, field)
  }

}
