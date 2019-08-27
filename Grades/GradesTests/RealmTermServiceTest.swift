//
//  RealmTermServiceTest.swift
//  GradesTests
//
//  Created by Ignacio Paradisi on 8/25/19.
//  Copyright © 2019 Ignacio Paradisi. All rights reserved.
//

import XCTest
import RealmSwift

@testable import Grades

class RealmTermServiceTest: XCTestCase {
    
    var term: Term!
    var service: TermService!
    var realm: Realm!

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        Realm.Configuration.defaultConfiguration.inMemoryIdentifier = self.name
        realm = try! Realm()
        service = AbstractServiceFactory.getServiceFactory(for: .realm).termService
        addTerm()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    private func addTerm() {
        term = Term()
        term.name = "Semestre 1"
        term.maxGrade = 20.0
        term.minGrade = 10.0
        term.startDate = Date()
        term.endDate = Date()
        try! realm.write {
            realm.add(term)
        }
    }

    func testSaveTerm() {
        var term = Term()
        term.name = "Semestre 1"
        term.maxGrade = 20.0
        term.minGrade = 10.0
        term.startDate = Date()
        term.endDate = Date()
        service.createTerm(term) { result in
            if let savedTerm = try? result.get() {
                term = savedTerm
            }
        }
        XCTAssertNotNil(term)
        XCTAssertNotEqual(term.id, "")
    }

    func testFetchTerms() {
        let promise = expectation(description: "Terms were fetched")
        var terms: [Term] = []
        service.fetchTerms { result in
            if let fetchedTerms = try? result.get() {
                terms = fetchedTerms
                promise.fulfill()
            }
        }
        wait(for: [promise], timeout: 5)
        XCTAssertNotEqual(terms.count, 0)
    }
    
    func testDeleteTerm() {
        let promise = expectation(description: "Term was deleted")
        service.deleteTerm(term) { _ in
            promise.fulfill()
        }
        wait(for: [promise], timeout: 5)
        let terms = realm.objects(Term.self)
        XCTAssertEqual(terms.count, 0)
    }

}
