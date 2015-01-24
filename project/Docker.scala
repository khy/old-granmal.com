import sbt._
import Keys._
import com.typesafe.sbt.packager.Keys.stage

object Docker {

  object Keys {

    val ensureDockerDaemon = taskKey[Unit](
      "Ensure that the local Docker daemon is running."
    )

    val buildPublicDockerImage = taskKey[String](
      "Package the application and build the public Docker image (everything " +
      "but environment variables). Returns the name of the new Docker image."
    )

    val pushPublicDockerImage = taskKey[Unit](
      "Package the application, build the public Docker image and push to the " +
      "Docker repository."
    )

    val dockerEnvironmentVariables = settingKey[Seq[(String, String)]](
      "Define environment variables to be included in the private Dockerfile."
    )

    val buildPrivateDockerfile = taskKey[Unit](
      "Build a private Dockerfile (public image + environment variables) for " +
      "the current version, add it to target/docker."
    )

  }

  import Keys._

  val defaultSettings = Seq(

    ensureDockerDaemon := {
      "boot2docker up".!
    },

    buildPublicDockerImage := {
      stage.value
      ensureDockerDaemon.value
      val imageName = "granmal/app:" + version.value
      s"docker build -t ${imageName} .".!
      imageName
    },

    pushPublicDockerImage := {
      val imageName = buildPublicDockerImage.value
      s"docker push ${imageName}".!
    },

    dockerEnvironmentVariables := Seq.empty,

    buildPrivateDockerfile := {
      val envInstructions = dockerEnvironmentVariables.value.map { case (key, value) =>
        s"ENV $key $value"
      }.mkString("\n")

      val content =
        s"""|FROM granmal/app:${version.value}
            |${envInstructions}
            |EXPOSE 9000
            |""".stripMargin

      val location = target.value / "docker" / s"Dockerfile.${version.value}"
      IO.write(location, content)
    }

  )

}
