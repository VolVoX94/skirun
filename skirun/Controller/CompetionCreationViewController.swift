//
//  CompetionCreationViewController.swift
//  skirun
//
//  Created by iOS Dev on 13.03.19.
//  Copyright © 2019 hevs. All rights reserved.
//

import UIKit
import Firebase

class CompetionCreationViewController: UIViewController {
    
  
   
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var titleCompetition: UITextField!
    @IBOutlet weak var endDate: UITextField!
    @IBOutlet weak var refApi: UITextField!
    @IBOutlet weak var save: UIBarButtonItem!
    @IBOutlet weak var startDate: UITextField!
    
    var startDateInt = 0
    var endDateInt = 0

    
    @IBAction func startdateEditing(_ sender: UITextField) {
        startDate.inputView = UIView()
        datePicker.isHidden = false
    }
    
    @IBAction func startdateEditingEnd(_ sender: UITextField) {
        datePicker.isHidden = true
    }
    
    @IBAction func enddateEditing(_ sender: UITextField) {
        endDate.inputView = UIView()
        datePicker.isHidden = false
    }
    
    @IBAction func enddateEditingEnd(_ sender: UITextField) {
        datePicker.isHidden = true
    }
    
    
    
    @IBAction func valueChanged(_ sender: UIDatePicker) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/YYYY HH:mm"
        let result = dateFormatter.string(from: sender.date)
        
        if startDate.isFirstResponder {
            startDate.text = result
            startDateInt = Int(sender.date.timeIntervalSince1970.rounded())
        }
        if endDate.isFirstResponder {
            endDate.text = result
            endDateInt = Int(sender.date.timeIntervalSince1970.rounded())
        }
    }
    
    
    var selectedCompetition: String = "";
    var competiton: Competition?;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        datePicker.isHidden=true
        datePicker.backgroundColor = UIColor.white

        //If we have a competitions, we load it
        if(selectedCompetition != "none"){
            loadCompetition()
        }
        
    }

    
    func loadCompetition(){
        //diable the field
        titleCompetition.isEnabled = false
        startDate.isEnabled = false
        endDate.isEnabled = false
        refApi.isEnabled = false
        save.isEnabled = false
        
        //load the competion object in the fields
        FirebaseManager.getCompetiton(name: selectedCompetition , completion: { (data) in
            self.competiton = data
            self.titleCompetition.text = self.competiton?.name
            let start: UnixTime = (self.competiton?.startDateTime)!
            self.startDate.text = start.toDateTime
            let end: UnixTime = (self.competiton?.endDateTime)!
            self.endDate.text = end.toDateTime
            self.refApi.text = self.competiton?.refAPI
        })
        
    }

    @IBAction func goBackManagement(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func saveButton(_ sender: Any) {
        
        //UIAlert
        let alertBox = UIAlertController(
        title: "Input is wrong",
        message: "",
        preferredStyle: .actionSheet)
        
        alertBox.addAction(UIAlertAction(title:"Ok", style: .cancel, handler:nil))
        
        
        if((isValidTexte(test: titleCompetition.text!) == false)){
            alertBox.message = "The title can contain text and/or numbers ";
            
            //Display the alertBox
            self.present(alertBox, animated: true);
            return;
        }
        

        if((isValidTexte(test: refApi.text!) == false)){
            alertBox.message = "refapi";
            
            //Display the alertBox
            self.present(alertBox, animated: true);
            return;
        }
        
        if(startDateInt>endDateInt){
            alertBox.message = "End date can't be before start date !";
            
            //Display the alertBox
            self.present(alertBox, animated: true);
            return;
        }
        
        
        insertCompetition()
        
    }
    
    func insertCompetition(){
        
        //create the object competition
        let newCompetition = Competition(name: titleCompetition.text ?? "Error", startDateTime: startDateInt, endDateTime: endDateInt, refAPI: refApi.text ?? "Error")
        
        //set the reference to the name of the new cometition
        let ref:DatabaseReference = Database.database().reference().child(FirebaseSession.competition.rawValue).child(newCompetition.name);
        
        //add the object
        ref.setValue(newCompetition.toAnyObject())
    }
    

    
    
    
    func isValidTexte(test:String)-> Bool {
        let textRegEx = "[A-Z-a-z-0-9]{4,20}"
        
        let textTest = NSPredicate(format: "SELF MATCHES %@", textRegEx)
        return textTest.evaluate(with:test)
    }
    
    @IBAction func back(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)

    }
    
}
