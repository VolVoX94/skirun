//
//  KeyAdminViewController.swift
//  skirun
//
//  Created by Admin on 08.04.19.
//  Copyright © 2019 hevs. All rights reserved.
//

import UIKit

class KeyAdminViewController: UIViewController {
    
    //Constraints
    @IBOutlet weak var TitleToDescription_Gap: NSLayoutConstraint!
    @IBOutlet weak var DescriptionToDateOne_Gap: NSLayoutConstraint!
    @IBOutlet weak var DateOneToTwo_Gap: NSLayoutConstraint!
    @IBOutlet weak var BottomToButton_Gap: NSLayoutConstraint!
    
    @IBOutlet weak var DateOneToLastKeyText_Gap: NSLayoutConstraint!
    private var currentMonthName:String?
    private var nextMonthName:String?
    private var currentMonthNumber:String?
    private var nextMonthNumber:String?
    private var lastUpdated:String?
    
    @IBOutlet weak var myDateLabel: UILabel!
    
    @IBOutlet weak var myBackButton: UIButton!
    
    @IBOutlet weak var myLastUpdateLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkDeviceSize()
        self.getMonth()
        self.getDate()
        self.myDateLabel.text = self.nextMonthName
    }
    
    func checkDeviceSize(){
        let screenSize: CGRect = UIScreen.main.bounds
        let screenHeight = screenSize.height
        let factor = screenHeight/568
        if(factor < 1.2){
            self.TitleToDescription_Gap.constant = 30
            self.DescriptionToDateOne_Gap.constant = 30
            self.DateOneToTwo_Gap.constant = 80
            self.DateOneToLastKeyText_Gap.constant = 80
            self.BottomToButton_Gap.constant = 30
            
        }
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
        
        //Get actual date with as DD_MM
        let now = Date()
        let dateNumberFormatter = DateFormatter()
        dateNumberFormatter.dateFormat = "dd.MM"
        let lastUpdate = dateNumberFormatter.string(from: now)
        
        FirebaseManager.saveKey(key: uuid, date:lastUpdate)
    }
    
    private func getDate(){
        FirebaseManager.getLastCheckNumberDate { (String) in
            
            self.myLastUpdateLabel.text = String
        }
    }
    
    
    public func automaticKeyGeneration(currentMonth:String){
        FirebaseManager.isNewKeyNeeded(inputDate: currentMonth) { (Bool) in
            if(Bool == true){
                self.generateKey(inputDate: currentMonth)
            }
        }
    }
    
    
    @IBAction func myBackButtonFunc(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
}
