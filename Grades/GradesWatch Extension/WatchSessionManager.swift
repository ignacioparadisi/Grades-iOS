//
//  WatchSessionManager.swift
//  GradesWatch Extension
//
//  Created by Ignacio Paradisi on 7/26/19.
//  Copyright © 2019 Ignacio Paradisi. All rights reserved.
//

import Foundation
import WatchConnectivity

class WatchSessionManager: NSObject {
    
    static let shared: WatchSessionManager = WatchSessionManager()
    private let session: WCSession? = WCSession.isSupported() ? WCSession.default : nil
    
    private override init() {
        super.init()
    }
    
    func start() {
        session?.delegate = self
        session?.activate()
    }
    
    func requestToiOS(with code: Int, completion: @escaping ([String: Any]) -> Void) {
        print("Requesting")
        if let session = session, session.isReachable {
            session.sendMessage(["code": code], replyHandler: { reply in
                completion(reply)
            }) { error in
                print("Error: \(error)")
            }
        }
    }
    
}

extension WatchSessionManager: WCSessionDelegate {
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        print("Apple Watch can comunicate with iOS device")
        NotificationCenter.default.post(name: Notification.Name(rawValue: "prueba"), object: nil)
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        print(message)
    }
}
