import Flutter
import UIKit
import WatchConnectivity

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    
    var session: WCSession?
    
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    if WCSession.isSupported() {
      print("Watch Session Supported")
      session = WCSession.default;
      session?.delegate = self;
      session?.activate();
    }
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}


extension AppDelegate: WCSessionDelegate {
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        if let error {
            print("session activation failed with error: \(error.localizedDescription)")
        }
    }
        
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        print("message received by phone from watch")
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {
        session.activate()
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        session.activate()
    }
}
