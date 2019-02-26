//
//  skirunTests.swift
//  skirunTests
//
//  Created by Admin on 25.02.19.
//  Copyright © 2019 GROUP2. All rights reserved.
//

//NECESSARY FOR TESTS IN SWIFT
import XCTest

//ALWAYS NEED TO IMPORT THE PROJECT ITSELF
@testable import skirun

class skirunTests: XCTestCase {

    //CALLED BEFORE EVERY TEST
    override func setUp() {
        
    }

    //CALLED AFTER RUN TEST
    override func tearDown() {
        
    }

    func testIsNumberOk(){
        //INSTANCE TO THE CLASS
        let viewController = ViewController()
        let number = 7
        
        XCTAssertFalse(viewController.isNumberOk(num: number))
    }

    //FOR COMPLEX ALGO-DURATION EVALUATING
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
