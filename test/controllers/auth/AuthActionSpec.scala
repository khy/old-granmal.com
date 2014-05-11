package controllers.auth

import scala.concurrent.Future
import org.specs2.mutable.{ Specification, Before }
import play.api.mvc._
import play.api.test._
import io.useless.util.mongo.MongoUtil

import models.core.account.Account
import AuthAction._

class AuthActionSpec extends PlaySpecification {

  object TestController extends Controller {

    def action = Action {
      Ok("action")
    }

    def asyncAction = Action.async {
      Future.successful { Ok("asyncAction") }
    }

    def authAction = Action.auth { request =>
      Ok("authAction: %s".format(request.account.flatMap(_.email)))
    }

    def asyncAuthAction = Action.auth.async { request =>
      Future.successful {
        Ok("asyncAuthAction: %s".format(request.account.flatMap(_.email)))
      }
    }

  }

  val testApplication = new FakeApplication(
    additionalConfiguration = Map("application.secret" -> "test")
  )

  "An unauthenticated, synchronous action" should {
    "return the specified result" in {
      val result = TestController.action(FakeRequest())
      contentAsString(result) must beEqualTo("action")
    }
  }

  "An unauthenticated, asynchronous action" should {
    "return the specified result" in {
      val result = TestController.asyncAction(FakeRequest())
      contentAsString(result) must beEqualTo("asyncAction")
    }
  }

  "A potentially authenticated, synchronous action" should {
    "return the specified result, without a logged-in account" in {
      val result = TestController.authAction(FakeRequest())
      contentAsString(result) must beEqualTo("authAction: None")
    }

    "return the specified result, with a logged-in account" in new WithApplication(testApplication) {
      MongoUtil.clearDb()
      val account = await { Account.create(email = Some("john@granmal.com")) }.right.get
      val request = FakeRequest().withSession((AuthKeys.session, account.guid.toString))
      val result = TestController.authAction(request)
      contentAsString(result) must beEqualTo("authAction: Some(john@granmal.com)")
    }
  }

  "A potentially authenticated, asynchronous action" should {
    "return the specified result, without a logged-in account" in {
      val result = TestController.asyncAuthAction(FakeRequest())
      contentAsString(result) must beEqualTo("asyncAuthAction: None")
    }

    "return the specified result, with a logged-in account" in new WithApplication(testApplication) {
      MongoUtil.clearDb()
      val account = await { Account.create(email = Some("john@granmal.com")) }.right.get
      val request = FakeRequest().withSession((AuthKeys.session, account.guid.toString))
      val result = TestController.asyncAuthAction(request)
      contentAsString(result) must beEqualTo("asyncAuthAction: Some(john@granmal.com)")
    }
  }

}
