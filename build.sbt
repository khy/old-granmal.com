name := "granmal"

scalaVersion in ThisBuild := "2.11.2"

lazy val lib = project.enablePlugins(SbtTwirl)

lazy val root = (project in file(".")).
  enablePlugins(PlayScala).
  dependsOn(lib, haikunst).
  aggregate(lib, haikunst)

lazy val haikunst = project.enablePlugins(PlayScala).dependsOn(lib)

libraryDependencies ++= Seq(
  "org.reactivemongo" %% "reactivemongo" % "0.10.5.akka23-SNAPSHOT",
  "io.useless"        %% "useless"       % "0.14.0",
  "joda-time"         %  "joda-time"     % "2.2",
  "org.mindrot"       %  "jbcrypt"       % "0.3m"
) ++ Seq(
  "org.webjars"       % "jquery"         % "2.1.1",
  "org.webjars"       % "normalize.css"  % "3.0.1"
)

resolvers ++= Seq(
  "Local Ivy"               at "file://" + Path.userHome.absolutePath + "/.ivy2/local",
  "Sonatype OSS Snapshots"  at "https://oss.sonatype.org/content/repositories/snapshots",
  "Sonatype OSS Releases"   at "https://oss.sonatype.org/content/groups/public"
)

javaOptions in Test += "-Dconfig.file=conf/test.conf"

TwirlKeys.templateImports += "helpers._"

Docker.defaultSettings
