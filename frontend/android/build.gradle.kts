// ======================================================
// REPOSITORIES
// ======================================================

allprojects {

    repositories {

        google()

        mavenCentral()

    }

}



// ======================================================
// BUILD DIRECTORY CONFIGURATION
// ======================================================

val newBuildDir: Directory =
    rootProject.layout.buildDirectory.dir("../../build").get()

rootProject.layout.buildDirectory.value(newBuildDir)



// ======================================================
// SUBPROJECT BUILD DIRECTORIES
// ======================================================

subprojects {

    val newSubprojectBuildDir: Directory =
        newBuildDir.dir(project.name)

    project.layout.buildDirectory.value(newSubprojectBuildDir)

}



// ======================================================
// EVALUATION DEPENDENCY
// ======================================================

subprojects {

    project.evaluationDependsOn(":app")

}



// ======================================================
// CLEAN TASK
// ======================================================

tasks.register<Delete>("clean") {

    delete(rootProject.layout.buildDirectory)

}



// ======================================================
// PLUGINS
// ======================================================

plugins {

    // Google Services Gradle Plugin
    id("com.google.gms.google-services") version "4.4.4" apply false

}
