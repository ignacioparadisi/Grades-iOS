//
//  Qualificationable.swift
//  Grades
//
//  Created by Ignacio Paradisi on 6/15/19.
//  Copyright © 2019 Ignacio Paradisi. All rights reserved.
//

import Foundation

protocol Qualificationable {
    var qualification: Float { get set }
    var maxQualification: Float { get set }
    var minQualification: Float { get set }
}
