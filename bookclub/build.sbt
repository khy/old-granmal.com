libraryDependencies ++= Seq(ws) ++ Seq(
  "io.useless"  %% "useless"  % "0.16.0"
) ++ Defaults.webJarDependencies

pipelineStages := Seq(rjs, digest, gzip)

resolvers ++= Seq(
  "Local Ivy"               at "file://" + Path.userHome.absolutePath + "/.ivy2/local",
  "Sonatype OSS Snapshots"  at "https://oss.sonatype.org/content/repositories/snapshots",
  "Sonatype OSS Releases"   at "https://oss.sonatype.org/content/groups/public"
)

TwirlKeys.templateImports := Seq(
  "play.api.libs.json",
  "io.useless.play.client.Page"
)

RjsKeys.mainModule := "main-bookclub"
