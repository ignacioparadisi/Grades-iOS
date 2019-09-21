//
//  GradesTests.swift
//  GradesTests
//
//  Created by Ignacio Paradisi on 9/21/19.
//  Copyright © 2019 Ignacio Paradisi. All rights reserved.
//

import XCTest

class GradesTests: XCTestCase {
    
    var coreDataManager: CoreDataManager!

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        coreDataManager = CoreDataManager.shared
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testCoreStackInitialization() {
        XCTAssertNotNil(coreDataManager.persistentContainer)
    }

}
