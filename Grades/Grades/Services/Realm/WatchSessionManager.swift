//
//  WatchSessionManager.swift
//  Grades
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
        
        print("isSupported: \(WCSession.isSupported()), isPaired: \(session?.isPaired), isWatchAppInstalled: \(session?.isWatchAppInstalled), isReachable: \(session?.isReachable)")
    }

    func isSupported() -> Bool {
        return WCSession.isSupported()
    }
    
}

extension WatchSessionManager: WCSessionDelegate {
    func sessionDidBecomeInactive(_ session: WCSession) {
        print("Session did become inactive")
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        print("Session did deactivate")
        session.activate()
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        print("iOS device can connect to Apple Watch")
    }
    
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any], replyHandler: @escaping ([String : Any]) -> Void) {
        print(message)
        let service = ServiceFactory.createService(.realm)
        replyHandler(["terms": service.fetchTerms()])
    }
}
