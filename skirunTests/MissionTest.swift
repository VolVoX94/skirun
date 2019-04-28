//
//  MissionTest.swift
//  skirunTests
//
//  Created by Jaufray on 28/04/2019.
//  Copyright © 2019 hevs. All rights reserved.
//

@testable import skirun
import XCTest

class MissionTest: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_timeKeeperMissionFillOnlyMissionDisciplineNil(){
        let mission = Mission(title: "TestMissionDistance", description: "I am a TimeKeeper for distance", startTime: 1531920435, endTime: 1531920434, nbPeople: 1, location: "Dooor", jobs: "TimeKeeper - distance")
        
        let storyboard = UIStoryboard(name: "TimeKeeper", bundle: nil)
        
        let mis = storyboard.instantiateViewController(withIdentifier: "keeperStoryBoard") as! TimeKeeperViewController
        
        mis.currentMission = mission.title
        
        XCTAssertTrue(mis.currentDiscipline == nil)
    }
    
    func test_timeKeeperMissionFillOnlyMissionCompetitionNil(){
        let mission = Mission(title: "TestMissionDistance", description: "I am a TimeKeeper for distance", startTime: 1531920435, endTime: 1531920434, nbPeople: 1, location: "Dooor", jobs: "TimeKeeper - distance")
        
        let storyboard = UIStoryboard(name: "TimeKeeper", bundle: nil)
        
        let mis = storyboard.instantiateViewController(withIdentifier: "keeperStoryBoard") as! TimeKeeperViewController
        
        mis.currentMission = mission.title
        
        XCTAssertTrue(mis.currentCompetition == nil)
    }
    
    func test_timeKeeperFillOnlyDisciplineMissionNil(){
        let discpline = "Cross-country skiing"
        
        let storyboard = UIStoryboard(name: "TimeKeeper", bundle: nil)
        
        let mis = storyboard.instantiateViewController(withIdentifier: "keeperStoryBoard") as! TimeKeeperViewController
        
        mis.currentDiscipline = discpline
        
        XCTAssertTrue(mis.currentMission == nil)
    }
    
    func test_timeKeeperFillOnlyCompetitionMissionNil(){
        let competition = Competition(name: "TestCompetition", startDateTime: 1531920435, endDateTime: 1531920434, refAPI: "WH8Hknx9023343")
        
        let storyboard = UIStoryboard(name: "TimeKeeper", bundle: nil)
        
        let mis = storyboard.instantiateViewController(withIdentifier: "keeperStoryBoard") as! TimeKeeperViewController
        
        mis.currentCompetition = competition.name
        
        XCTAssertTrue(mis.currentMission == nil)
    }
    
    func test_timeKeeperFillOnlyCompetitionDisciplineNil(){
        let competition = Competition(name: "TestCompetition", startDateTime: 1531920435, endDateTime: 1531920434, refAPI: "WH8Hknx9023343")
        
        let storyboard = UIStoryboard(name: "TimeKeeper", bundle: nil)
        
        let mis = storyboard.instantiateViewController(withIdentifier: "keeperStoryBoard") as! TimeKeeperViewController
        
        mis.currentCompetition = competition.name
        
        XCTAssertTrue(mis.currentDiscipline == nil)
    }
    
    
}
