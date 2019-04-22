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
    
    
    //Email Regex
    func test_RegisterEmail_WrongEmailNo_Fail(){
        let testStr = "abcdefgh.ch"
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        XCTAssertFalse(emailTest.evaluate(with: testStr))
    }
    
    func test_RegisterEmail_CorrectEmail_True(){
        let testStr = "abcd@efgh.ch"
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        XCTAssertTrue(emailTest.evaluate(with: testStr))
    }
    
    //Name Regex
    func test_RegisterName_WrongNameInput_Fail(){
        let testStr = "VolVoX1994"
        let nameRegEx = "[A-Za-z]{4,20}"
        
        let nameTest = NSPredicate(format:"SELF MATCHES %@", nameRegEx)
         XCTAssertFalse(nameTest.evaluate(with: testStr))
    }
    
    func test_RegisterName_CorrectNameInput_True(){
        let testStr = "Hans"
        let nameRegEx = "[A-Za-z]{4,20}"
        
        let nameTest = NSPredicate(format:"SELF MATCHES %@", nameRegEx)
        XCTAssertTrue(nameTest.evaluate(with: testStr))
    }

    
    //Phone Regex
    func test_RegisterPhone_WrongPhoneInput_Fail(){
        let testStr = "+41882123A"
        let phoneRegEx = "([+]?)[0-9]{9,20}"
        
        let phoneTest = NSPredicate(format:"SELF MATCHES %@", phoneRegEx)
         XCTAssertFalse(phoneTest.evaluate(with: testStr))
    }
    
    func test_RegisterPhone_CorrectPhoneInput_True(){
        let testStr = "+41794567890"
        let phoneRegEx = "([+]?)[0-9]{9,20}"
        
        let phoneTest = NSPredicate(format:"SELF MATCHES %@", phoneRegEx)
        XCTAssertTrue(phoneTest.evaluate(with: testStr))
    }
    
}
