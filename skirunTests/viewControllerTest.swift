//
//  viewControllerTest.swift
//  skirunTests
//
//  Created by Rey Elodie on 16.04.19.
//  Copyright © 2019 hevs. All rights reserved.
//

import UIKit

import XCTest
import Firebase
@testable import skirun

class viewControllerTest: XCTestCase {
    

    let viewControllerRole: RolesViewController! = nil
    
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        super.setUp()
        
        
       
    }
    
    // When loading the controller role, the table view should be nil
    func test_instantiateRoleController_TableView_Empty (){
        
        // create storyboard
      let storyboard = UIStoryboard(name: "Main", bundle: nil)
      
        // instantiate view controller
        let role = storyboard.instantiateViewController(withIdentifier: "roleStoryboard") as! RolesViewController
        
        // get the table view roles
       let tableview = role.tableViewRoles
        
        // Table view should be nil
        XCTAssertNil(tableview, "TableviewRole empty when loading view controller role")
        
    }
    
    
    
    // When loading the secondviewcontroller, the table view should be nil
    func test_instantiateSecondViewController_TableView_Empty (){
        
        // create storyboard
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        // instantiate view controller
        let mission = storyboard.instantiateViewController(withIdentifier: "missionStoryboard") as! SecondViewController
        
        // get the table view missions
        let tableview = mission.TableViewMission
        
        // Table view should be nil
        XCTAssertNil(tableview, "TableviewMission empty when loading view controller role")
        
    }
    
}
