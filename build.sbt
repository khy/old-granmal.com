name := "granmal"

version := "0.1.0"

scalaVersion := "2.10.3"

libraryDependencies ++= Seq(
  "org.reactivemongo" %% "reactivemongo" % "0.10.0",
  "io.useless"        %% "useless"       % "0.13.0",
  "joda-time"         %  "joda-time"     % "2.2",
  "org.mindrot"       %  "jbcrypt"       % "0.3m"
)

resolvers ++= Seq(
  "Local Ivy"               at "file://" + Path.userHome.absolutePath + "/.ivy2/local",
  "Sonatype OSS Snapshots"  at "https://oss.sonatype.org/content/repositories/snapshots",
  "Sonatype OSS Releases"   at "https://oss.sonatype.org/content/groups/public"
)

javaOptions in Test += "-Dconfig.file=conf/test.conf"

play.Project.playScalaSettings

templatesImport += "helpers._"

requireJs ++= Seq("core/main", "haikunst/main")

requireJsShim += "config.js"

lessEntryPoints <<= baseDirectory(_ / "app" / "assets" / "stylesheets" ** "main.less")

publishArtifact in (Compile, packageDoc) := false

publishArtifact in (Compile, packageSrc) := false

mappings in Universal += buildStageDockerfile.value -> "Dockerfile"
