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
    
  
   

    @IBOutlet weak var titleCompetition: UITextField!
    @IBOutlet weak var endDate: UITextField!
    @IBOutlet weak var refApi: UITextField!
    @IBOutlet weak var save: UIBarButtonItem!
    @IBOutlet weak var startDate: UITextField!
    
    var selectedCompetition: String = "";
    var competiton: Competition?;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
        if((isValidDate(dateString: startDate.text!) == false)){
            alertBox.message = "The format for the Start date is dd-MM-yyyy";
            
            //Display the alertBox
            self.present(alertBox, animated: true);
            return;
        }
        
        if((isValidDate(dateString: endDate.text!) == false)){
            alertBox.message = "The format for the End date is dd-MM-yyyy";
            
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
        
        
        insertCompetition()
        
    }
    
    func insertCompetition(){
        
        //create the object competition
        let newCompetition = Competition(name: titleCompetition.text ?? "Error", startDateTime: 12345, endDateTime: 1234, refAPI: refApi.text ?? "Error")
        
        //set the reference to the name of the new cometition
        let ref:DatabaseReference = Database.database().reference().child(FirebaseSession.competition.rawValue).child(newCompetition.name);
        
        //add the object
        ref.setValue(newCompetition.toAnyObject())
    }
    
    func isValidDate(dateString: String) -> Bool {
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "dd-MM-yyyy"
        if let _ = dateFormatterGet.date(from: dateString) {
            //date parsing succeeded, if you need to do additional logic, replace _ with some variable name i.e date
            return true
        } else {
            // Invalid date
            return false
        }
    }
    
    
    
    func isValidTexte(test:String)-> Bool {
        let textRegEx = "[A-Z-a-z-0-9]{4,20}"
        
        let textTest = NSPredicate(format: "SELF MATCHES %@", textRegEx)
        return textTest.evaluate(with:test)
    }
    

}
