# OBS MANAGER

A new Flutter project to manage OBS (Open Broadcast Software).

The main idea is to permit any new streamer to get a simple kind of steamdeck on mobile/tablet. <br>

## Requirements

1. You need to get and install a plugin to OBS : https://github.com/obsproject/obs-websocket/releases <br>
It gives you:
- **Ip** server
- **Port** server
- **Password** server

2. You need a **USB - C** connector to connect your device.
NB: Some bugs happen if the connection is not complete or if your computer don't read your device.

## Getting Started

- Press "Settings" button from the app.
- Fill the form datas from OBS>Tools>WebSocket params.
- Press "Connect to OBS".

## About Android

To avoid errors from gradle, kotlin or java version, take a look to this two files below.

- to check the correct kotlin version: https://kotlinlang.org/docs/releases.html#release-details

```
# /android/settings.gradle
plugins {
    id "org.jetbrains.kotlin.android" version "[VERSION_HERE]" apply false
}
```

- to check the correct gradle version: https://maven.google.com/web/index.html?q=com.android.application.gradle.plugin#com.android.application:com.android.application.gradle.plugin

```
# /android/settings.gradle
plugins {
    id "com.android.application" version "[VERSION_HERE]" apply false
}
```
```
# /android/gradle/wrapper/gradle-wrapper.properties
distributionUrl=https\://services.gradle.org/distributions/gradle-[VERSION_HERE].zip
```

- to correct the Java version :

```
    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_[VERSION_HERE]
        targetCompatibility = JavaVersion.VERSION_[VERSION_HERE]
    }
```
Example:
```
# For Java 1.8: JavaVersion.VERSION_1_8
# For Java 17: JavaVersion.VERSION_17
```