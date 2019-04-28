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
    
    func test_GetNoneExistingMission() {
        FirebaseManager.getMission(nameCompetition: "NoneExisting", nameDiscipline: "NoneExisting", nameMission: "NoneExisting") { (data) in
            let mission = data
            XCTAssertEqual(mission.description, "NULL")
            XCTAssertEqual(mission.endTime, 0)
            XCTAssertEqual(mission.startTime, 0)
            XCTAssertEqual(mission.nbPeople, 0)
            XCTAssertEqual(mission.jobs, "NULL")
            XCTAssertEqual(mission.location, "NULL")
        }
    }
    
    // check if the list of discipline of an non existing competition is set to 0
    func test_DisciplinesOfCompetition() {
        FirebaseManager.getDisciplinesOfCompetition(name: "not existing competition") { (sampleData) in
            XCTAssertEqual(sampleData.count, 0)
        }
    }
    
    // check if the list of mission of an non existing competition and non existing discipline
    func test_MissionOfDisciplines() {
        FirebaseManager.getMisOfDisciplines(competitionName: "not existing competition", disciplineName: "not existing discplines"){ (sampleData) in
            
            XCTAssertEqual(sampleData.count, 0)
        }
    }
}
