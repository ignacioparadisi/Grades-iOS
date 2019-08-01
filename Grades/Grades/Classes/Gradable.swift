//
//  Gradable.swift
//  Grades
//
//  Created by Ignacio Paradisi on 6/15/19.
//  Copyright © 2019 Ignacio Paradisi. All rights reserved.
//

import Foundation

protocol Gradable {
    var name: String { get set }
    var grade: Float { get set }
    var maxGrade: Float { get set }
    var minGrade: Float { get set }
}
