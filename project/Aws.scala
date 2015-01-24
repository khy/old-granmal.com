import sbt._
import Keys._

object Aws {

  case class S3Location(bucket: String, key: String)

  object Keys {

    val uploadDockerfileToS3 = taskKey[S3Location](
      "Uploads the Dockerfile for the current version to the 'granmal-versions' " +
      "bucket in S3. Returns the S3Location of the Dockerfile."
    )

    val createElasticBeanstalkApplicationVersion = taskKey[String](
      "Creates a new application version in Elastic Beanstalk for the current version. " +
      "Returns the label of the new application version."
    )

    val deployElasticBeanstalkApplicationVersion = taskKey[Unit](
      "Deploys the current application version to the Elastic Beanstalk environment."
    )

  }

  import Keys._

  val defaultSettings = Seq(

    uploadDockerfileToS3 := {
      val file = s"Dockerfile.${version.value}"
      val bucket = "granmal-versions"
      s"aws s3 cp target/docker/${file} s3://${bucket}/${file}".!
      S3Location(bucket, file)
    },

    createElasticBeanstalkApplicationVersion := {
      val s3Location = uploadDockerfileToS3.value
      val versionLabel = version.value
      Seq("aws", "elasticbeanstalk", "create-application-version",
        "--application-name", "Gran Mal",
        "--version-label", s"${versionLabel}",
        "--source-bundle", s"S3Bucket=${s3Location.bucket},S3Key=${s3Location.key}"
      ).!
      versionLabel
    },

    deployElasticBeanstalkApplicationVersion := {
      val versionLabel = createElasticBeanstalkApplicationVersion.value
      Seq("aws", "elasticbeanstalk", "update-environment",
        "--environment-name", "Beta",
        "--version-label", s"${versionLabel}"
      ).!
    }

  )

}
