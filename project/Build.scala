import sbt._
import Keys._
import com.typesafe.sbt.packager.Keys.stage

object GranMalBuild extends Build {

  val dockerEnvironmentVariables = settingKey[Seq[(String, String)]](
    "Defines environment variables to be included in the Dockerfile."
  )

  val dockerfileEnvInstructions = settingKey[String](
    "The ENV instructions corresponding to the environment variables defined by dockerEnvironmentVariables."
  )

  val buildStageDockerfile = taskKey[File](
    "Builds a Dockerfile suitable for the stage distribution, adds it to target/docker."
  )

  val buildPrivateVersionDockerfile = taskKey[File](
    "Build a Dockerfile based upon a public granmal/app image version, adds it to target/docker."
  )

  val prepareImages = taskKey[Unit](
    "Builds the public image, and builds the private image Dockerfile."
  )

  lazy val root = Project(id = "granmal", base = file("."), settings = Project.defaultSettings ++ Seq(

    dockerEnvironmentVariables := Seq.empty,

    dockerfileEnvInstructions := dockerEnvironmentVariables.value.map { case (key, value) =>
      s"ENV $key $value"
    }.mkString("\n"),

    buildStageDockerfile := {
      val content =
      s"""|FROM granmal/base:0.0.1
          |ADD . /app
          |WORKDIR /app
          |${dockerfileEnvInstructions.value}
          |RUN chmod +x bin/granmal
          |EXPOSE 9000
          |CMD ["bin/granmal", "-Dconfig.file=conf/prod.conf"]
          |""".stripMargin

      val location = target.value / "docker" / "Dockerfile.stage"
      IO.write(location, content)
      location
    },

    buildPrivateVersionDockerfile := {
      val content =
      s"""|FROM granmal/app:${version.value}
          |${dockerfileEnvInstructions.value}
          |EXPOSE 9000
          |""".stripMargin

      val location = target.value / "docker" / s"Dockerfile.${version.value}"
      IO.write(location, content)
      location
    },

    // 'a' and 'b' vals are to avoid warnings.
    prepareImages := {
      val a = stage.value
      val imageName = s"granmal/app:${version.value}"
      s"docker build -t $imageName .".!
      val b = buildPrivateVersionDockerfile.value
    }

  ))

}
