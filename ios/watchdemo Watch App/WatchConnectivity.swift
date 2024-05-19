//
//  WatchConnectivity.swift
//  watchdemo Watch App
//
//  Created by Stephen Rogers on 19/05/2024.
//

import Foundation
import WatchConnectivity

class WatchConnectivityModel:NSObject, ObservableObject {
    
    var session: WCSession
    
    init(session: WCSession = .default) {
        self.session = session
        super.init()
        self.session.delegate = self
        session.activate()
    }
    
    
    func start() {
        sendMessage(for: "WATCH", data: "START")
    }
    
    
    func stop() {
        sendMessage(for: "WATCH", data: "STOP")
    }
    
}


extension WatchConnectivityModel: WCSessionDelegate {
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        if let error {
            print("session activation failed with error: \(error.localizedDescription)")
        }
    }
        
    func sendMessage(for method: String, data:String) {
        guard session.isReachable else {
            return
        }
        let message:  [String: String] = ["method": method, "data": data]
        session.sendMessage(message, replyHandler: nil, errorHandler: nil)
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        print(message)
    }
    

}
