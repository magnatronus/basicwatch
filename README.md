# basicwatch

This is an companion update to my original project found here [Flutter WatchTips](https://github.com/magnatronus/flutter-watchtips). It is a basic iOS watchOS embedded Flutter app that demos a watch app that can send data to a Flutter app via iOS.

This is only a simple example and the result of a lot of trial, error and reading **many** articles on the subject. My thanks to these article authors for all the help and suggestions that have allowed me to get this going, some are listed below:

- https://medium.com/@pranilshah4024/flutter-with-watchos-b0b909b45c89
- https://betterprogramming.pub/sending-data-between-watchos-and-ios-apps-cf924e21b3c2
- https://medium.com/swlh/how-to-use-watchconnectivity-to-send-data-from-phone-to-watch-plus-most-common-errors-793d41976618


**You will need to set a DevelopmentTeam/Provisioning profile in the Xcode project for this to work**

## Disclaimer
Although just a demo app, I wanted to share it to show an example of a **watchOS** app embedded into a Flutter app and sending data to it. It is NOT a text book example on how to code this up in a production release, just more of a *'here you go, hope this is useful'* as a lot of the effort for me to get this working has come from the effort of others.


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


# Step Two
Now that is working we will add the message sending capabilities between the **watch** app and the **iOS** app. This step involves adding **WatchConnectivity** to both the iOS app and the watch app.

## Watch App 
A new swift file (*File->New->File*) is added to the watch app  that I called **WatchConnectivity** ,  adding it the the *watchdemo Watch App* target. Look at the code for details, but basically add a ref to **WatchConnectivity**, an observable class and an extension for the WatchConnectivity functionality.

The Watch app is then modified and 2 buttons are placed on the screen, see **ContentView.swift** these simply use the created observable class (not strictly required, but I may use it later for feedback) to send a message to the iOS app using the **start()** and **stop()** methods.

We then need to modify **AppDelegate** to be able to ingest the messages send from the watch app.

## AppDelegate

As before add a ref to **WatchConnectivity** and create an extension to process the **WatchConnectivity** functionality.

Modify the **AppDelegate** class and add a WCSession.

```swift
var session: WCSession? 
```

and session activation code just before the *application* method returns.

```swift
if WCSession.isSupported() {
    print("Watch Session Supported")
    session = WCSession.default;
    session?.delegate = self;
    session?.activate();
}
```

Again run the Flutter app and check that everythin is OK. If it is run the Watch app(it may take a while to reload) and this time there should be 2 buttons on the watch app.

Using Xcode, observe the logs and you should see 3 things, 

- a line when the app started that  says ```Watch Session Supported``` this comes from the activation code we added.
- a line each time you press a button on the watch ```message received by phone from watch``` this indicates the message is received by the iOS app.


# Step Three

This is the last step and involves adding a Channel so that the Flutter app can detect the messages being sent from the Watch app. First modify the **session** method in the iOS AppDelegate extension from a simple print to allow it to open a **MethodChannel** and communicate to the Flutter app - please note this is one way only to the app, it could also be from the app to the watch. (but beyond what I wanted at this point).

The replacement code

```swift
DispatchQueue.main.async {
    print("message received by phone from watch, dispatching")
    if let method = message["method"] as? String, let data = message["data"] as? String {
        if let controller = self.window?.rootViewController as? FlutterViewController {
            let channel = FlutterMethodChannel( name: "demo.spiralarm.watch", binaryMessenger: controller.binaryMessenger)
            channel.invokeMethod(method, arguments: data)
        }
        
    }
}
```

This basically uses MethodChannel to send the Flutter app a message when the watch sends one.

With that done, we also update the Flutter app to be able to react to the MethodChannel messages, for this we add a methodChannel:

```dart
String _phoneMessage = 'none';
final MethodChannel channel = const MethodChannel('demo.spiralarm.watch');
```

And then code to react to any messages that come in:

```dart
  Future<void> _channelInit() async {
    channel.setMethodCallHandler((call) async {
      final rxd = 'FROM PHONE: ${call.method} - ${call.arguments}';
      debugPrint(rxd);
      setState(() {
        _phoneMessage = rxd;
      });
    });
  }
```

Finally **_channelInit** needs to be added to the **initState** method of the Stateful widget.

```dart
  @override
  void initState() {
    super.initState();
    _channelInit();
  }
```

If all is well then when the app is run and the watch app buttons are pressed you should see the messags displayed on the Flutter app screen.




## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
