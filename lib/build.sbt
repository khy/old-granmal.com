val playVersion = "2.3.4"

libraryDependencies ++= Seq(
  "com.typesafe.play" %% "play"          % playVersion,
  "io.useless"        %% "useless"       % "0.14.3",
  "org.reactivemongo" %% "reactivemongo" % "0.10.5.0.akka23",
  "joda-time"         %  "joda-time"     % "2.2",
  "org.mindrot"       %  "jbcrypt"       % "0.3m",
  "org.scalatestplus" %% "play"          % "1.1.0"
) ++ Seq(
  "org.scalatestplus" %% "play"          % "1.1.0"      % "test"
)

resolvers ++= Seq(
  "Local Ivy"               at "file://" + Path.userHome.absolutePath + "/.ivy2/local",
  "Sonatype OSS Snapshots"  at "https://oss.sonatype.org/content/repositories/snapshots",
  "Sonatype OSS Releases"   at "https://oss.sonatype.org/content/groups/public"
)

TwirlKeys.templateImports ++= Seq(
  "play.api.mvc._",
  "play.api.i18n._",
  "views.html._",
  "com.granmal._"
)
