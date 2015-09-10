package com.granmal.auth

import scala.concurrent.Future
import play.api.mvc._
import play.api.test._
import play.api.test.Helpers._
import play.api.libs.concurrent.Execution.Implicits.defaultContext
import org.scalatest._
import org.scalatestplus.play._
import io.useless.util.mongo.MongoUtil

import com.granmal.models.account.Account
import AuthAction._

import com.typesafe.config.ConfigFactory

class AuthActionSpec extends PlaySpec with OneAppPerSuite {

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

  implicit override lazy val app = new FakeApplication(
    additionalConfiguration = Map(
      "application.secret" -> "test",
      "mongo.uri" -> "mongodb://localhost/granmal_test"
    )
  )

  "An unauthenticated, synchronous action" should {
    "return the specified result" in {
      val result = TestController.action(FakeRequest())
      contentAsString(result) mustBe("action")
    }
  }

  "An unauthenticated, asynchronous action" should {
    "return the specified result" in {
      val result = TestController.asyncAction(FakeRequest())
      contentAsString(result) mustBe("asyncAction")
    }
  }

  "A potentially authenticated, synchronous action" should {
    "return the specified result, without a logged-in account" in {
      val result = TestController.authAction(FakeRequest())
      contentAsString(result) mustBe("authAction: None")
    }

    "return the specified result, with a logged-in account" in {
      MongoUtil.clearDb("mongo.uri")
      val account = await { Account.create(email = Some("john@granmal.com")) }.right.get
      val request = FakeRequest().withSession((AuthKeys.session, account.guid.toString))
      val result = TestController.authAction(request)
      contentAsString(result) mustBe("authAction: Some(john@granmal.com)")
    }
  }

  "A potentially authenticated, asynchronous action" should {
    "return the specified result, without a logged-in account" in {
      val result = TestController.asyncAuthAction(FakeRequest())
      contentAsString(result) mustBe("asyncAuthAction: None")
    }

    "return the specified result, with a logged-in account" in {
      MongoUtil.clearDb("mongo.uri")
      val account = await { Account.create(email = Some("john@granmal.com")) }.right.get
      val request = FakeRequest().withSession((AuthKeys.session, account.guid.toString))
      val result = TestController.asyncAuthAction(request)
      contentAsString(result) mustBe("asyncAuthAction: Some(john@granmal.com)")
    }
  }

}
