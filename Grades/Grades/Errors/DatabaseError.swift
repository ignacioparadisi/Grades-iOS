//
//  RequestError.swift
//  Grades
//
//  Created by Ignacio Paradisi on 8/2/19.
//  Copyright © 2019 Ignacio Paradisi. All rights reserved.
//

import Foundation

enum  DatabaseError: Error {
    case onSave
    case onDelete
    case onUpdate
    case onFetch
}
