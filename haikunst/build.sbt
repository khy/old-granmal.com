libraryDependencies ++= Seq(ws) ++ Seq(
  "io.useless"  %% "useless"  % "0.14.3"
)

resolvers ++= Seq(
  "Local Ivy"               at "file://" + Path.userHome.absolutePath + "/.ivy2/local",
  "Sonatype OSS Snapshots"  at "https://oss.sonatype.org/content/repositories/snapshots",
  "Sonatype OSS Releases"   at "https://oss.sonatype.org/content/groups/public"
)

TwirlKeys.templateImports := Seq("play.api.data._")
