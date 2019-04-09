//
//  FirebaseTests.swift
//  skirunTests
//
//  Created by Admin on 09.04.19.
//  Copyright © 2019 hevs. All rights reserved.
//

import XCTest
import Firebase
@testable import skirun

class FirebaseTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_GetAllCompetition_NoCircumstances_DataRetrieved() {
        FirebaseManager.getCompetitons { (sampleData) in
            XCTAssertNotNil(sampleData)
        }
    }
    
    func test_GetAllJobs_NoCircumstances_DataRetrieved() {
        FirebaseManager.getJobs { (sampleData) in
            XCTAssertNotNil(sampleData)
        }
    }
    
    func test_GetAllDisciplines_NoCircumstances_DataRetrieved() {
        FirebaseManager.getDisciplines { (sampleData) in
            XCTAssertNotNil(sampleData)
        }
    }
    
    func test_IsNewKeyNeeded_00Month_True() {
        FirebaseManager.isNewKeyNeeded(inputDate: "00") { (Bool) in
            XCTAssertTrue(Bool)
        }
    }
    
    func test_GetLastAdminKeyDateValue_NoCircumstances_True() {
        FirebaseManager.getLastCheckNumberDate{ (Data) in
            XCTAssertNotNil(Data)
        }
    }

}
