import sbt._
import Keys._

object Aws {

  object Keys {

    val deployToAws = taskKey[Unit](
      "Deploys the current version to AWS. Assumes that publishDocker has been run."
    )

    val uploadDockerfileToS3 = taskKey[Unit](
      "Uploads the Dockerfile for the current version to the 'granmal-versions' " +
      "bucket in S3."
    )

    val createElasticBeanstalkApplicationVersion = taskKey[Unit](
      "Creates a new application version in Elastic Beanstalk for the current version."
    )

    val deployElasticBeanstalkApplicationVersion = taskKey[Unit](
      "Deploys the current application version to the Elastic Beanstalk environment."
    )

  }

  import Keys._

  val defaultSettings = Seq(

    deployToAws := {
      uploadDockerfileToS3.value
      createElasticBeanstalkApplicationVersion.value
      deployElasticBeanstalkApplicationVersion.value
    },

    uploadDockerfileToS3 := {
      val file = s"Dockerfile.${version.value}"
      s"aws s3 cp target/docker/${file} s3://granmal-versions/${file}".!
    },

    createElasticBeanstalkApplicationVersion := {
      Seq("aws", "elasticbeanstalk", "create-application-version",
        "--application-name", "Gran Mal",
        "--version-label", s"${version.value}",
        "--source-bundle", s"S3Bucket=granmal-versions,S3Key=Dockerfile.${version.value}"
      ).!
    },

    deployElasticBeanstalkApplicationVersion := {
      Seq("aws", "elasticbeanstalk", "update-environment",
        "--environment-name", "Beta",
        "--version-label", s"${version.value}"
      ).!
    }

  )

}
