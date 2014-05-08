import sbt._
import Keys._

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
      var df = List.empty[String]

      df = df :+ "FROM granmal/base:0.0.1"
      df = df :+ "ADD . /app"
      df = df :+ "WORKDIR /app"
      df = df :+ "RUN chmod +x bin/granmal"
      dockerEnvironmentVariables.value.foreach { case (key, value) =>
        df = df :+ s"ENV ${key} ${value}"
      }
      df = df :+ "EXPOSE 9000"
      df = df :+ "CMD [\"bin/granmal\", \"-Dconfig.file=conf/prod.conf\"]"

      IO.write(location, df.mkString("\n") + "\n")
      location
    }

  ))

}
