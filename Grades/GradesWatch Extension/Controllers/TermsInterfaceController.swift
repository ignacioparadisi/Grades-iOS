//
//  TermsInterfaceController.swift
//  GradesWatch Extension
//
//  Created by Ignacio Paradisi on 7/26/19.
//  Copyright © 2019 Ignacio Paradisi. All rights reserved.
//

import WatchKit
import Foundation


class TermsInterfaceController: WKInterfaceController {

    @IBOutlet weak var table: WKInterfaceTable!
    var terms: [Term] = []
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }
    @IBAction func fetchTerms() {
        WatchSessionManager.shared.requestToiOS(with: 1) { reply in
            print(reply)
        }
    }
    
}

