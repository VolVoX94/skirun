//
//  LoginTests.swift
//  skirunTests
//
//  Created by AISLAB on 12.03.19.
//  Copyright © 2019 hevs. All rights reserved.
//

import XCTest
import Firebase
@testable import skirun

class LoginTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        XCTAssertTrue(true)
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func test_RegisterAsAdmin_CorrectAdminNumber_True() {
        let ref:DatabaseReference = Database.database().reference().child(FirebaseSession.admin.rawValue).child(FirebaseSession.ADMIN_CHECKNUMBER.rawValue)
        
        ref.observe(.value, with: {(snapshot) in
            var tempNumber = snapshot.childSnapshot(forPath: FirebaseSession.ADMIN_CHECKNUMBER.rawValue).value as! String

            FirebaseManager.checkAdminNumber(inputNumber: tempNumber, result: { (Bool) in
                XCTAssertTrue(Bool)
            })
        })
    }
}
