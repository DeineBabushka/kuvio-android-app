buildscript {
    repositories {
        google()
        mavenCentral()
    }
    dependencies {
        // Google Services Plugin für Firebase (z. B. Auth, Analytics)
        classpath("com.google.gms:google-services:4.4.2")

        // Crashlytics Gradle Plugin
        classpath("com.google.firebase:firebase-crashlytics-gradle:3.0.1")
    }
}

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory = rootProject.layout.buildDirectory.dir("../../build").get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}

subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
