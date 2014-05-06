import sbt._
import Keys._

import com.typesafe.sbt.SbtNativePackager.Universal

object GranMalBuild extends Build {

  val dockerEnvironmentVariables = settingKey[Seq[(String, String)]](
    "Defines environment variables to be included in the Dockerfile."
  )

  val buildDockerfile = taskKey[File](
    "Builds the Dockerfile, adds it to target/docker."
  )

  lazy val root = Project(id = "granmal", base = file("."), settings = Project.defaultSettings ++ Seq(

    dockerEnvironmentVariables := Seq.empty,

    buildDockerfile := {
      val location = target.value / "docker" / "Dockerfile"
      var lines = List.empty[String]

      lines = lines :+ "FROM granmal/base:0.0.1"
      lines = lines :+ "ADD . /app/"
      dockerEnvironmentVariables.value.foreach { case (key, value) =>
        lines = lines :+ s"ENV ${key} '${value}'"
      }
      lines = lines :+ "CMD /app/bin/granmal"
      IO.write(location, lines.mkString("\n") + "\n")

      location
    },

    mappings in Universal += buildDockerfile.value -> "Dockerfile"

  ))

}
