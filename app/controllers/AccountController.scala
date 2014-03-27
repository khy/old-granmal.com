package controllers

import scala.concurrent.Future
import play.api._
import play.api.mvc._
import play.api.data._
import play.api.data.Forms._
import play.api.libs.concurrent.Execution.Implicits.defaultContext

import models.account.Account

object AccountController extends Controller {

  case class SignUpData(
    email: String,
    name: String,
    handle: String,
    password: String
  )

  val signUpForm = Form {
    mapping(
      "email" -> email,
      "name" -> text,
      "handle" -> text,
      "password" -> nonEmptyText
    )(SignUpData.apply)(SignUpData.unapply)
  }

  def form = Action {
    Ok(views.html.account.form(signUpForm))
  }

  def create = Action {
    Ok("HI!")
  }

}
