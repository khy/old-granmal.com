import sbt._
import Keys._
import com.typesafe.sbt.packager.Keys.stage

object GranMalBuild extends Build {

  val dockerEnvironmentVariables = settingKey[Seq[(String, String)]](
    "Define environment variables to be included in the private Dockerfile."
  )

  val buildPublicDockerImage = taskKey[Unit](
    "Package the application and build the public Docker image (everything " +
    "but environment variables)."
  )

  val pushPublicDockerImage = taskKey[Unit](
    "Package the application, build the public Docker image and push to the " +
    "Docker repository."
  )

  val buildPrivateDockerfile = taskKey[Unit](
    "Build a private Dockerfile (public image + environment variables) for " +
    "the current version, add it to target/docker."
  )

  val publishDocker = taskKey[Unit](
    "Push the public Docker image and build the private Dockerfile."
  )

  def dockerImageName(version: String) = "granmal/app:" + version

  lazy val root = Project(id = "granmal", base = file("."), settings = Project.defaultSettings ++ Seq(

    dockerEnvironmentVariables := Seq.empty,

    buildPublicDockerImage := {
      stage.value
      s"docker build -t ${dockerImageName(version.value)} .".!
    },

    pushPublicDockerImage := {
      buildPublicDockerImage.value
      s"docker push ${dockerImageName(version.value)}".!
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

    publishDocker <<= Seq(
      pushPublicDockerImage,
      buildPrivateDockerfile
    ).dependOn

  ))

}
