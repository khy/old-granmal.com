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

    val resolvers = Seq(
      "Local Ivy"               at "file://" + Path.userHome.absolutePath + "/.ivy2/local",
      "Sonatype OSS Snapshots"  at "https://oss.sonatype.org/content/repositories/snapshots",
      "Sonatype OSS Releases"   at "https://oss.sonatype.org/content/groups/public"
    )

  }

  object Settings {

    val base = Seq(

      libraryDependencies ++= Seq(Dependencies.useless) ++ Dependencies.webJars,

      Keys.resolvers ++= Dependencies.resolvers

    )

    val root = Settings.base ++ Seq(

      pipelineStages := Seq(rjs, digest, gzip),

      includeFilter in rjs := GlobFilter("*.js") | GlobFilter("*.css") | GlobFilter("*.map") | GlobFilter("*.hbs")

    )

    def app(appKey: String) = Settings.root ++ Seq(

      RjsKeys.mainModule := s"main-$appKey"

    )

  }

}
