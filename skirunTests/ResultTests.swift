//
//  ResultTests.swift
//  skirunTests
//
//  Created by AISLAB on 28.04.19.
//  Copyright © 2019 hevs. All rights reserved.
//

import XCTest
@testable import skirun

class ResultTests: XCTestCase {

    let resultViewController: TimeKeeperViewController! = nil
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    func test_loadTypeJob_time (){
        
        // create storyboard
        let storyboard = UIStoryboard(name: "TimeKeeper", bundle: nil)
        // instantiate view controller
        let result = storyboard.instantiateViewController(withIdentifier: "keeperStoryBoard") as! TimeKeeperViewController
        result.loadView()
        result.currentMissionObject = Mission (title: "NULL", description: "NULL", startTime: 0, endTime: 0, nbPeople: 0, location: "NULL", jobs: "NULL")
        
        result.loadTypeJob(typeJob: "TimeKeeper - time")
        
        XCTAssertEqual("Time", result.resultLabel.text)
        XCTAssertEqual("Min, sec", result.unitResult)
        
    }
    
    
    func test_loadTypeJob_distance (){
        
        // create storyboard
        let storyboard = UIStoryboard(name: "TimeKeeper", bundle: nil)
        // instantiate view controller
        let result = storyboard.instantiateViewController(withIdentifier: "keeperStoryBoard") as! TimeKeeperViewController
        result.loadView()
        result.currentMissionObject = Mission (title: "NULL", description: "NULL", startTime: 0, endTime: 0, nbPeople: 0, location: "NULL", jobs: "NULL")
        
        result.loadTypeJob(typeJob: "TimeKeeper - distance")
        
        XCTAssertEqual("Distance", result.resultLabel.text)
        XCTAssertEqual("Meter", result.unitResult)
        
    }
    
    
    func test_loadTypeJob_vitesse (){
        
        // create storyboard
        let storyboard = UIStoryboard(name: "TimeKeeper", bundle: nil)
        // instantiate view controller
        let result = storyboard.instantiateViewController(withIdentifier: "keeperStoryBoard") as! TimeKeeperViewController
        result.loadView()
        result.currentMissionObject = Mission (title: "NULL", description: "NULL", startTime: 0, endTime: 0, nbPeople: 0, location: "NULL", jobs: "NULL")
        
        result.loadTypeJob(typeJob: "TimeKeeper - vitesse")
        
        XCTAssertEqual("Vitesse", result.resultLabel.text)
        XCTAssertEqual("Km/h", result.unitResult)
        
    }
    
    func test_loadTypeJob_door (){
        
        // create storyboard
        let storyboard = UIStoryboard(name: "TimeKeeper", bundle: nil)
        // instantiate view controller
        let result = storyboard.instantiateViewController(withIdentifier: "keeperStoryBoard") as! TimeKeeperViewController
        result.loadView()
        result.currentMissionObject = Mission (title: "NULL", description: "NULL", startTime: 0, endTime: 0, nbPeople: 0, location: "NULL", jobs: "NULL")
        
        result.loadTypeJob(typeJob: "Door Controller")
        
        XCTAssertTrue(result.numberLabel.isHidden)
        XCTAssertTrue(result.numberField.isHidden)
        XCTAssertTrue(result.resultField.isHidden)
        XCTAssertTrue(result.resultLabel.isHidden)
        XCTAssertTrue(result.submitButton.isHidden)
        XCTAssertTrue(result.dnfButton.isHidden)
        
    }
    
    func test_loadTypeJob_logistics (){
        
        // create storyboard
        let storyboard = UIStoryboard(name: "TimeKeeper", bundle: nil)
        // instantiate view controller
        let result = storyboard.instantiateViewController(withIdentifier: "keeperStoryBoard") as! TimeKeeperViewController
        result.loadView()
        result.currentMissionObject = Mission (title: "NULL", description: "NULL", startTime: 0, endTime: 0, nbPeople: 0, location: "NULL", jobs: "NULL")
        
        result.loadTypeJob(typeJob: "Logistics")
        
        XCTAssertTrue(result.numberField.isHidden)
        XCTAssertTrue(result.resultField.isHidden)
        XCTAssertTrue(result.submitButton.isHidden)
        XCTAssertTrue(result.dnfButton.isHidden)
        XCTAssertFalse(result.numberLabel.isHidden)
        XCTAssertFalse(result.resultLabel.isHidden)
        
    }

}
