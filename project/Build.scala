import sbt._
import Keys._
import com.typesafe.sbt.packager.Keys.stage

object GranMalBuild extends Build {

  val dockerEnvironmentVariables = settingKey[Seq[(String, String)]](
    "Define environment variables to be included in the private Dockerfile."
  )

  val buildPublicDockerImage = taskKey[Unit](
    "Build a public Docker image (everything but environment variables) for " +
    "the current staged application."
  )

  val buildPrivateDockerfile = taskKey[Unit](
    "Build a private Dockerfile (public image + environment variables) for " +
    "the current version, add it to target/docker."
  )

  val release = taskKey[Unit](
    "[Incomplete] Push the current version of the app to AWS."
  )

  lazy val root = Project(id = "granmal", base = file("."), settings = Project.defaultSettings ++ Seq(

    dockerEnvironmentVariables := Seq.empty,

    buildPublicDockerImage := {
      s"docker build -t granmal/app:${version.value} .".!
    },

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
    },

    // assignment is to avoid warnings.
    release := {
      val step1 = stage.value
      val step2 = buildPublicDockerImage.value
      val step3 = buildPrivateDockerfile.value
    }

  ))

}
