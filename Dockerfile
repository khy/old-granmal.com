# Notes:
# * you need to run `sbt stage` before building this image.
# * the resulting image will not include the environment variables required to
#   run the app; it should be used as the base for another image that does.

FROM granmal/base:0.0.1

ADD target/universal/stage /app
WORKDIR /app
RUN chmod +x bin/granmal

EXPOSE 9000
CMD ["bin/granmal", "-Dconfig.file=conf/prod.conf"]
