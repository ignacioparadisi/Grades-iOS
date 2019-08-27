//
//  String+Extension.swift
//  Grades
//
//  Created by Ignacio Paradisi on 5/1/19.
//  Copyright © 2019 Ignacio Paradisi. All rights reserved.
//

import UIKit

extension String {
    
    /// Localized a string
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
    
}
