//
//  ServiceFactory.swift
//  Grades
//
//  Created by Ignacio Paradisi on 6/15/19.
//  Copyright © 2019 Ignacio Paradisi. All rights reserved.
//

import Foundation

enum ServiceType {
    case test
    case realm
}

class ServiceFactory {
    static func createService(_ type: ServiceType) -> Service {
        switch type {
        case .test:
            return TestDataService.shared
        case .realm:
            return RealmService.shared
        }
    }
}
