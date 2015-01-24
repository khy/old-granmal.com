import sbt._
import Keys._

import Docker.Keys.publishDocker
import Aws.Keys.deployToAws

object Deploy {

  object Keys {

    val deploy = taskKey[Unit](
      "Builds and publishes the Docker image and deploys it to AWS."
    )

  }

  import Keys._

  val defaultSettings = Seq(

    deploy := {
      Def.taskDyn {
        publishDocker.value
        Def.task { deployToAws.value }
      }.value
    }

  )

}
