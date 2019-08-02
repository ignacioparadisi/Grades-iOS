//
//  CalculableGradable.swift
//  Grades
//
//  Created by Ignacio Paradisi on 8/1/19.
//  Copyright © 2019 Ignacio Paradisi. All rights reserved.
//

import Foundation

protocol CalculableGradable: Gradable {
    var greaterGrade: Float { get set }
    var lowerGrade: Float { get set }
}
