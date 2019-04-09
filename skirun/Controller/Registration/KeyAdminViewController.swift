//
//  KeyAdminViewController.swift
//  skirun
//
//  Created by Admin on 08.04.19.
//  Copyright © 2019 hevs. All rights reserved.
//

import UIKit

class KeyAdminViewController: UIViewController {
    private var currentMonthName:String?
    private var nextMonthName:String?
    private var currentMonthNumber:String?
    private var nextMonthNumber:String?
    
    @IBOutlet weak var myDateLabel: UILabel!
    
    @IBOutlet weak var myBackButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getMonth()
        
        self.myDateLabel.text = self.nextMonthName
    }
    
    func getMonth(){
        let monthsToAdd = 1
        let now = Date()
        let dateNameFormatter = DateFormatter()
        let dateNumberFormatter = DateFormatter()
        dateNameFormatter.dateFormat = "LLLL"
        dateNumberFormatter.dateFormat = "MM"
        var dateComponent = DateComponents()
        self.currentMonthName = dateNameFormatter.string(from: now)
        self.currentMonthNumber = dateNumberFormatter.string(from: now)
        
        dateComponent.month = monthsToAdd
        let futureDate = Calendar.current.date(byAdding: dateComponent, to: now)
        self.nextMonthName = dateNameFormatter.string(from: futureDate!)
        self.nextMonthNumber = dateNameFormatter.string(from: futureDate!)
    }
    
    @IBAction func generateKeyButtonFunc(_ sender: Any) {
        generateKey(inputDate: self.currentMonthNumber!)
    }
    
    public func generateKey(inputDate:String){
        var uuid = UUID().uuidString
        uuid = String(uuid.prefix(8)) // Hello
        uuid.append(inputDate)
        
        FirebaseManager.saveKey(key: uuid)
    }
    
    
    public func automaticKeyGeneration(){
        let now = Date()
        let dateNumberFormatter = DateFormatter()
        dateNumberFormatter.dateFormat = "MM"
        let monthNumber = dateNumberFormatter.string(from: now)
        print("key generation check", monthNumber)
        FirebaseManager.isNewKeyNeeded(inputDate: monthNumber) { (Bool) in
            if(Bool == true){
                self.generateKey(inputDate: monthNumber)
            }
        }
    }
    
    
    @IBAction func myBackButtonFunc(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
}
