import sbt._
import Keys._

import Docker.Keys._
import Aws.Keys._

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
        pushPublicDockerImage.value
        buildPrivateDockerfile.value
        Def.task {
          deployElasticBeanstalkApplicationVersion.value
        }
      }.value
    }

  )

}
