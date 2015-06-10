name := "granmal"

scalaVersion in ThisBuild := "2.11.6"

scalacOptions ++= Seq("-feature", "-language:reflectiveCalls")

lazy val lib = project.enablePlugins(SbtWeb, SbtTwirl)
lazy val haikunst = project.enablePlugins(PlayScala).dependsOn(lib)
lazy val bookclub = project.enablePlugins(SbtWeb, PlayScala).dependsOn(lib)

lazy val root = (project in file(".")).
  enablePlugins(PlayScala, Mongo, Release).
  dependsOn(lib, haikunst, bookclub).
  aggregate(lib, haikunst, bookclub).
  settings(
    aggregate in stage := false,
    aggregate in publishLocal := false,
    aggregate in publish := false
  )

Defaults.Settings.root

libraryDependencies ++= Seq(
  "org.reactivemongo" %% "reactivemongo" % "0.10.5.0.akka23",
  "joda-time"         %  "joda-time"     % "2.2",
  "org.mindrot"       %  "jbcrypt"       % "0.3m"
)

JsEngineKeys.engineType := JsEngineKeys.EngineType.Node

javaOptions in Test += "-Dconfig.file=conf/test.conf"

dockerBaseImage := "java:8"
maintainer in Docker := "Kevin Hyland <khy@me.com>"
dockerRepository := Some("khyland")
dockerCmd := Seq("-Dconfig.file=conf/prod.conf")
