//
//  Float+Extension.swift
//  Grades
//
//  Created by Ignacio Paradisi on 9/23/19.
//  Copyright © 2019 Ignacio Paradisi. All rights reserved.
//

import Foundation

extension Float {
    func toString(with decimals: Int16) -> String {
        let format = "%.\(abs(decimals))f"
        return String(format: format, self)
    }
}

