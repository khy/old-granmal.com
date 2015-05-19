name := "granmal"

scalaVersion in ThisBuild := "2.11.6"

lazy val lib = project.enablePlugins(SbtWeb, SbtTwirl)
lazy val haikunst = project.enablePlugins(PlayScala).dependsOn(lib)
lazy val bookclub = project.enablePlugins(SbtWeb, PlayScala).dependsOn(lib)

lazy val root = (project in file(".")).
  enablePlugins(PlayScala, Mongo).
  dependsOn(lib, haikunst, bookclub).
  aggregate(lib, haikunst, bookclub)

Defaults.Settings.root

libraryDependencies ++= Seq(
  "org.reactivemongo" %% "reactivemongo" % "0.10.5.0.akka23",
  "joda-time"         %  "joda-time"     % "2.2",
  "org.mindrot"       %  "jbcrypt"       % "0.3m"
)

JsEngineKeys.engineType := JsEngineKeys.EngineType.Node

scalacOptions ++= Seq("-feature", "-language:reflectiveCalls")

javaOptions in Test += "-Dconfig.file=conf/test.conf"

Docker.defaultSettings

Aws.defaultSettings

Deploy.defaultSettings
