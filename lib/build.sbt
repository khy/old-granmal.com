Defaults.Settings.base

libraryDependencies ++= Seq(
  "com.typesafe.play" %% "play"          % "2.3.7",
  "org.reactivemongo" %% "reactivemongo" % "0.10.5.0.akka23",
  "joda-time"         %  "joda-time"     % "2.2",
  "org.mindrot"       %  "jbcrypt"       % "0.3m",
  "org.scalatestplus" %% "play"          % "1.1.0"
) ++ Seq(
  "org.scalatestplus" %% "play"          % "1.1.0"      % "test"
)

TwirlKeys.templateImports ++= Seq(
  "play.api.mvc._",
  "play.api.i18n._",
  "views.html._",
  "com.granmal._"
)

parallelExecution in Test := false
