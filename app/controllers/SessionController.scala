package controllers

import scala.concurrent.Future
import play.api._
import play.api.mvc._
import play.api.libs.json._
import play.api.data._
import play.api.data.Forms._
import play.api.libs.concurrent.Execution.Implicits.defaultContext

import com.granmal.models.account.PublicAccount.Json._
import com.granmal.auth.AuthKeys
import com.granmal.models.account.Account

object SessionController extends Controller {

  case class SignInData(email: String, password: String)

  val signInForm = Form {
    mapping(
      "email" -> email,
      "password" -> nonEmptyText
    )(SignInData.apply)(SignInData.unapply)
  }

  def form = Action { implicit request =>
    Ok(views.html.session.form(signInForm))
  }

  def create = Action.async { implicit request =>
    signInForm.bindFromRequest.fold(
      formWithErrors => {
        Future.successful(UnprocessableEntity("Invalid data"))
      },
      signInData => {
        Account.auth(signInData.email, signInData.password).map { optAccount =>
          optAccount.map { account =>
            Ok(Json.toJson(account.toPublic)).
              withSession(request.session + (AuthKeys.session -> account.guid.toString))
          }.getOrElse {
            Unauthorized("Invalid email / password combination")
          }
        }
      }
    )
  }

  def delete = Action { implicit request =>
    NoContent.withSession(request.session - AuthKeys.session)
  }

}
