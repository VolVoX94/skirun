//
//  KeyManagementTest.swift
//  skirunTests
//
//  Created by Admin on 09.04.19.
//  Copyright © 2019 hevs. All rights reserved.
//

import XCTest
import Firebase
@testable import skirun

class KeyManagementTest: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_AutomaticalKeyGeneration_NewMonthArrived_KeyChanged() {
        let ref:DatabaseReference = Database.database().reference().child(FirebaseSession.admin.rawValue)
        ref.observe(.value, with: {(snapshot) in
            let tempNumberOld = snapshot.childSnapshot(forPath: FirebaseSession.ADMIN_CHECKNUMBER.rawValue).value as? String ?? "NULL"
            
            var result:Bool = false
            
            //Create new date
            let now = Date()
            let monthsToAdd = 1
            var dateComponent = DateComponents()
            dateComponent.month = monthsToAdd
            let futureDate = Calendar.current.date(byAdding: dateComponent, to: now)
            let dateNumberFormatter = DateFormatter()
            dateNumberFormatter.dateFormat = "MM"
            let monthNumber = dateNumberFormatter.string(from: futureDate!)
            
            let keyManageController = KeyAdminViewController()
            //IT WILL GENERATE A NEW KEY
            keyManageController.automaticKeyGeneration(currentMonth: monthNumber)

            let ref:DatabaseReference = Database.database().reference().child(FirebaseSession.admin.rawValue)
            ref.observe(.value, with: {(snapshot) in
                let tempNumberNew = snapshot.childSnapshot(forPath: FirebaseSession.ADMIN_CHECKNUMBER.rawValue).value as? String ?? "NULL"
                
                if(tempNumberOld != tempNumberNew){
                    result = true
                }
                else{
                    result = false
                }
                
                let ref:DatabaseReference = Database.database().reference().child(FirebaseSession.admin.rawValue).child(FirebaseSession.ADMIN_CHECKNUMBER.rawValue)
                
                ref.setValue(tempNumberOld)
                
                XCTAssertTrue(result)
            })
        })
    }

}
