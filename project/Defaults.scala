import sbt._
import Keys._
import com.typesafe.sbt.web.SbtWeb.autoImport.pipelineStages
import com.typesafe.sbt.rjs.Import.{rjs, RjsKeys}
import com.typesafe.sbt.digest.Import.digest
import com.typesafe.sbt.gzip.Import.gzip

object Defaults {

  object Dependencies {

    val useless = "io.useless"  %% "useless"  % "0.16.0"

    val webJars = Seq(
      "org.webjars"       % "requirejs"      % "2.1.15",
      "org.webjars"       % "jquery"         % "2.1.1",
      "org.webjars"       % "normalize.css"  % "3.0.1",
      "org.webjars"       % "underscorejs"   % "1.7.0",
      "org.webjars"       % "backbonejs"     % "1.1.2-2",
      "org.webjars"       % "handlebars"     % "2.0.0-alpha.2",
      "org.webjars"       % "momentjs"       % "2.8.3"
    )

  }

  val resolvers = Seq(
    "Local Ivy"               at "file://" + Path.userHome.absolutePath + "/.ivy2/local",
    "Sonatype OSS Snapshots"  at "https://oss.sonatype.org/content/repositories/snapshots",
    "Sonatype OSS Releases"   at "https://oss.sonatype.org/content/groups/public"
  )

  def appSettings(appKey: Option[String]) = Seq(

    libraryDependencies ++= Seq(Dependencies.useless) ++ Dependencies.webJars,

    Keys.resolvers ++= Defaults.resolvers,

    pipelineStages := Seq(rjs, digest, gzip),

    RjsKeys.mainModule := appKey map { appKey => s"main-${appKey}" } getOrElse("main")

  )

}
