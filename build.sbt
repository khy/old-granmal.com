name := "granmal"

scalaVersion in ThisBuild := "2.11.4"

lazy val lib = project.enablePlugins(SbtWeb, SbtTwirl)
lazy val haikunst = project.enablePlugins(PlayScala).dependsOn(lib)
lazy val bookclub = project.enablePlugins(SbtWeb, PlayScala).dependsOn(lib)

lazy val root = (project in file(".")).
  enablePlugins(PlayScala).
  dependsOn(lib, haikunst, bookclub).
  aggregate(lib, haikunst, bookclub)

libraryDependencies ++= Seq(
  "org.reactivemongo" %% "reactivemongo" % "0.10.5.0.akka23",
  "io.useless"        %% "useless"       % "0.16.0",
  "joda-time"         %  "joda-time"     % "2.2",
  "org.mindrot"       %  "jbcrypt"       % "0.3m"
) ++ Defaults.webJarDependencies

resolvers ++= Seq(
  "Local Ivy"               at "file://" + Path.userHome.absolutePath + "/.ivy2/local",
  "Sonatype OSS Snapshots"  at "https://oss.sonatype.org/content/repositories/snapshots",
  "Sonatype OSS Releases"   at "https://oss.sonatype.org/content/groups/public"
)

pipelineStages := Seq(rjs, digest, gzip)

JsEngineKeys.engineType := JsEngineKeys.EngineType.Node

scalacOptions ++= Seq("-feature", "-language:reflectiveCalls")

javaOptions in Test += "-Dconfig.file=conf/test.conf"

Docker.defaultSettings

Aws.defaultSettings

Deploy.defaultSettings
