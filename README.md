# basicwatch

An update to my original project found here [Flutter WatchTips](https://github.com/magnatronus/flutter-watchtips). This is a basic iOS watchOS embedded Flutter app that demos a watch app tha can send data to a Flutter app via iOS.

This is just a simple example and the result of a lot of trial, error and reading **many** article on the subject My thanks to these articles for all the help and suggestions that have allowed me to get this going, some are listed below:

- https://medium.com/@pranilshah4024/flutter-with-watchos-b0b909b45c89
- https://betterprogramming.pub/sending-data-between-watchos-and-ios-apps-cf924e21b3c2
- https://medium.com/swlh/how-to-use-watchconnectivity-to-send-data-from-phone-to-watch-plus-most-common-errors-793d41976618


# Step One

- Create a basic Flutter app and then open the Xcode project and add a simple watchOS app.
- Run app and check that watchOS app is available

## Add watchOS app
In the Xcode project select *File->New->Target* then the **watchOS** tab and **App**, give it a name (in this case I used **watchdemo**) and allow the new Scheme to activate.

When this is done switch the Scheme back to Runner, then select the **Runner** target and the **Build Phases** tab. Here you should see *Embed Watch Content* as the last phase. Drag this to be between *Embed Frameworks* and *Thin Binary*. This prevents a Cycle build error that will otherwise occur, see below for an example of the error.

```
Failed to build iOS app
Could not build the precompiled application for the device.
Error (Xcode): Cycle inside Runner; building could produce unreliable results.
Cycle details:
→ Target 'Runner' has copy command from '/User/abc/basicwatchos/build/ios/Debug-watchos/watchapp Watch App.app' to '/User/abc/basicwatchos/build/ios/Debug-iphoneos/Runner.app/Watch/watchapp Watch App.app'
```

## Run app
First thing to note is that I could **ONLY** get this working on a *real device* with an associated *watch*, I'm sure there are lots of folks out there that can do a better job of getting this working with a sim that me, to be honest I ran out of patience attempting to get a sim phone and sim watch working that would show the watch app for install.

If all is well when you run the app you should see something similar to this is the *debug console* (I use VSC).

```
Launching lib/main.dart on *************** in debug mode...
Automatically signing iOS for device deployment using specified development team in Xcode project: ABCDEFGHIJ
Watch companion app found.
Xcode build done. 
```
The **important** bit is  *Watch companion app found*. If this works  then on the phone switch to the **Watch** app and you should see (in my case) **watchdemo** in the list of *available apps*. Select this and install the app then check it is available on the watch.





## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
