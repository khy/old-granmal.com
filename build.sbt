name := "granmal"

scalaVersion in ThisBuild := "2.11.4"

lazy val lib = project.enablePlugins(SbtTwirl)

lazy val root = (project in file(".")).
  enablePlugins(PlayScala).
  dependsOn(lib, haikunst, bookclub).
  aggregate(lib, haikunst, bookclub)

lazy val haikunst = project.enablePlugins(PlayScala).dependsOn(lib)
lazy val bookclub = project.enablePlugins(PlayScala).dependsOn(lib)

libraryDependencies ++= Seq(
  "org.reactivemongo" %% "reactivemongo" % "0.10.5.0.akka23",
  "io.useless"        %% "useless"       % "0.16.0",
  "joda-time"         %  "joda-time"     % "2.2",
  "org.mindrot"       %  "jbcrypt"       % "0.3m"
) ++ Seq(
  "org.webjars"       % "jquery"         % "2.1.1",
  "org.webjars"       % "normalize.css"  % "3.0.1",
  "org.webjars"       % "underscorejs"   % "1.7.0",
  "org.webjars"       % "backbonejs"     % "1.1.2-2",
  "org.webjars"       % "handlebars"     % "2.0.0-alpha.2",
  "org.webjars"       % "momentjs"       % "2.8.3"
)

resolvers ++= Seq(
  "Local Ivy"               at "file://" + Path.userHome.absolutePath + "/.ivy2/local",
  "Sonatype OSS Snapshots"  at "https://oss.sonatype.org/content/repositories/snapshots",
  "Sonatype OSS Releases"   at "https://oss.sonatype.org/content/groups/public"
)

pipelineStages := Seq(rjs, digest, gzip)

scalacOptions ++= Seq("-feature", "-language:reflectiveCalls")

javaOptions in Test += "-Dconfig.file=conf/test.conf"

Docker.defaultSettings

Aws.defaultSettings

Deploy.defaultSettings
