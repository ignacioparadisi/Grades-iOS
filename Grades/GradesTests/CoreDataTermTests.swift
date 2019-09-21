//
//  CoreDataTermTests.swift
//  GradesTests
//
//  Created by Ignacio Paradisi on 9/21/19.
//  Copyright © 2019 Ignacio Paradisi. All rights reserved.
//

import XCTest
import CoreData
// @testable import Term

class CoreDataTermTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
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
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testCreateTerm() {
        let term = try! Term.create(name: "Semestre 1", maxGrade: 20.0, minGrade: 10.0, startDate: Date(), endDate: Date() + 1)
        print(term)
        XCTAssertNotNil(term)
    }

}
