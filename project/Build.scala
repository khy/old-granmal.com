import sbt._

object GranMalBuild extends Build {

  lazy val root = Project(
    id = "granmal",
    base = file("."),
    settings = {
      Project.defaultSettings ++
      Docker.defaultSettings
    }
  )

}
