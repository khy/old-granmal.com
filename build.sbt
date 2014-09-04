name := "granmal"

scalaVersion in ThisBuild := "2.11.2"

lazy val root = (project in file(".")).
  enablePlugins(PlayScala)

libraryDependencies ++= Seq(
  "org.reactivemongo" %% "reactivemongo" % "0.10.5.akka23-SNAPSHOT",
  "io.useless"        %% "useless"       % "0.14.0",
  "joda-time"         %  "joda-time"     % "2.2",
  "org.mindrot"       %  "jbcrypt"       % "0.3m"
)

resolvers ++= Seq(
  "Local Ivy"               at "file://" + Path.userHome.absolutePath + "/.ivy2/local",
  "Sonatype OSS Snapshots"  at "https://oss.sonatype.org/content/repositories/snapshots",
  "Sonatype OSS Releases"   at "https://oss.sonatype.org/content/groups/public"
)

javaOptions in Test += "-Dconfig.file=conf/test.conf"

TwirlKeys.templateImports += "helpers._"

Docker.defaultSettings
