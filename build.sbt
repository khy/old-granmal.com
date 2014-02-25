name := "granmal"

version := "0.0.1"

play.Project.playScalaSettings

requireJs += "main.js"

requireJsShim += "main.js"

lessEntryPoints <<= baseDirectory(_ / "app" / "assets" / "stylesheets" ** "main.less")
