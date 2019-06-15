//
//  RealmManager.swift
//  Grades
//
//  Created by Ignacio Paradisi on 5/30/19.
//  Copyright © 2019 Ignacio Paradisi. All rights reserved.
//

import Foundation
import RealmSwift

class RealmManager {
    
    /// Realm database instance
    private var database: Realm
    /// Realm manager instance for the Singleton
    static let shared: RealmManager = RealmManager()
    
    /// Creates an instance of Realm
    private init() {
        database = try! Realm()
        print("Realm File: \(database.configuration.fileURL)")
    }
    
    
    /// Creates an object to the Realm database
    ///
    /// - Parameter object: Object to be created
    func create(_ object: Object) {
        try! self.database.write {
            self.database.add(object)
        }
    }
    
    /// Gets the objects of the type passed as parameter stored in the Realm database
    ///
    /// - Parameter type: Class of the objects to get
    /// - Returns: A Result<Object> type
    func get(_ type: Object.Type) -> Results<Object> {
        let results: Results<Object> = database.objects(type)
        return results
    }
    
    /// Converts the Result<Object> into an array
    ///
    /// - Parameters:
    ///   - type: The class ot the objects to get
    ///   - filter: A filter to search if needed
    /// - Returns: An array of the objects searched
    func getArray(ofType type: Object.Type, filter: String? = nil) -> [Object] {
        var results = get(type)
        if let filt = filter {
            results = results.filter(filt)
        }
        return results.toArray(ofType: type) as [Object]
    }
    
}

extension Results {
    
    /// Retuns an array of objects
    ///
    /// - Parameter ofType: Type of the object
    /// - Returns: An array of the specified type
    func toArray<T>(ofType: T.Type) -> [T] {
        var array = [T]()
        for i in 0 ..< count {
            if let result = self[i] as? T {
                array.append(result)
            }
        }
        
        return array
    }
}
