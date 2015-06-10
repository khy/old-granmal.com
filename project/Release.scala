import sbt._
import Keys.publish

import sbtrelease.ReleasePlugin
import ReleasePlugin.autoImport._
import sbtrelease.ReleaseStateTransformations._
import com.typesafe.sbt.packager.docker.DockerPlugin
import com.typesafe.sbt.packager.docker.DockerPlugin.autoImport.Docker

/**
 * NOTICE: This was copied-and-pasted from useless.io.
 */

object Release extends AutoPlugin {

  override def requires = DockerPlugin && ReleasePlugin

  object autoImport {

    val ensureBoot2Docker = taskKey[Unit](
      "Ensure that boot2docker is running."
    )

  }

  import autoImport._

  override def projectSettings = Seq(

    ensureBoot2Docker := {
      "boot2docker up".!
    },

    releaseProcess := Seq(
      checkSnapshotDependencies,
      inquireVersions,
      runTest,
      setReleaseVersion,
      commitReleaseVersion,
      tagRelease,
      releaseStepTask(ensureBoot2Docker),
      releaseStepTask(publish in Docker),
      setNextVersion,
      commitNextVersion,
      pushChanges
    )

  )

}
