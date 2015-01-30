import sbt._
import Keys._

object Defaults {

  val webJarDependencies = Seq(
    "org.webjars"       % "jquery"         % "2.1.1",
    "org.webjars"       % "normalize.css"  % "3.0.1",
    "org.webjars"       % "underscorejs"   % "1.7.0",
    "org.webjars"       % "backbonejs"     % "1.1.2-2",
    "org.webjars"       % "handlebars"     % "2.0.0-alpha.2",
    "org.webjars"       % "momentjs"       % "2.8.3"
  )

}
