////
////  RealmSubjectServiceTest.swift
////  GradesTests
////
////  Created by Ignacio Paradisi on 8/26/19.
////  Copyright © 2019 Ignacio Paradisi. All rights reserved.
////
//
//import XCTest
//
//import XCTest
//import RealmSwift
//
//@testable import Grades
//
//class RealmSubjectServiceTest: XCTestCase {
//    
//    var subject: Subject?
//    var service: SubjectService!
//    var realm: Realm!
//    var term: Term!
//    
//    override func setUp() {
//        // Put setup code here. This method is called before the invocation of each test method in the class.
//        Realm.Configuration.defaultConfiguration.inMemoryIdentifier = self.name
//        
//        realm = try! Realm()
//        service = AbstractServiceFactory.getServiceFactory(for: .realm).subjectService
//    }
//    
//    private func addTerm() {
//        term = Term()
//        term.name = "Semestre 1"
//        term.maxGrade = 20.0
//        term.minGrade = 10.0
//        term.startDate = Date()
//        term.endDate = Date()
//        realm.add(term)
//    }
//    
//    private func addSubject() {
//        let subject = Subject()
//        subject.term = term
//        subject.name = "Materia 1"
//        subject.maxGrade = 20.0
//        subject.minGrade = 10.0
//        realm.add(subject)
//    }
//    
//    func testSaveSubject() {
//        addTerm()
//        XCTAssertNotNil(term)
//        XCTAssertNotEqual(term?.id, "")
//    }
//    
//    func testFetchTerms() {
//        let promise = expectation(description: "Terms were fetched")
//        var terms: [Term] = []
//        addTerm()
//        service.fetchTerms { result in
//            if let fetchedTerms = try? result.get() {
//                terms = fetchedTerms
//                promise.fulfill()
//            }
//        }
//        wait(for: [promise], timeout: 5)
//        XCTAssertNotEqual(terms.count, 0)
//    }
//    
//    func testDeleteTerm() {
//        let promise = expectation(description: "Terms were fetched")
//        addTerm()
//        
//        service.deleteTerm(term!) { _ in
//            promise.fulfill()
//        }
//        wait(for: [promise], timeout: 5)
//        let count = self.realm.objects(Term.self).count
//        XCTAssertEqual(count, 0)
//    }
//    
//}
