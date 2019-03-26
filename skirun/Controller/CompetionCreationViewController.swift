//
//  CompetionCreationViewController.swift
//  skirun
//
//  Created by iOS Dev on 13.03.19.
//  Copyright © 2019 hevs. All rights reserved.
//

import UIKit

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
        
        if(selectedCompetition != "none"){
            loadCompetition()
        }
        
    }
    
    func loadCompetition(){
        FirebaseManager.getCompetiton(name: selectedCompetition , completion: { (data) in
            self.competiton = data
            self.titleCompetition.text = self.competiton?.name
            let start: UnixTime = (self.competiton?.startDateTime)!
            print(start.dateFull)
            //self.startDate.text = self.competiton?.startDateTime as String
            //self.endDate.text = self.competiton?.endDateTime as String
            self.refApi.text = self.competiton?.refAPI
        })
        
    }

    @IBAction func goBackManagement(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func saveButton(_ sender: Any) {
        var wrongInput = false;
        
        //UIAlert
        let alertBox = UIAlertController(
        title: "Input is wrong",
        message: "",
        preferredStyle: .actionSheet)
        
        alertBox.addAction(UIAlertAction(title:"Ok", style: .cancel, handler:nil))
        
        
        if((isValidTexte(test: titleCompetition.text!) == false)){
            
            //Define that something is wrong
            wrongInput = true;
            alertBox.message = "The title can contain text and/or numbers ";
            
            //Display the alertBox
            self.present(alertBox, animated: true);
        }
        
        if((isValidDate(dateString: startDate.text!) == false) && wrongInput != true){
            //Define that something is wrong
            wrongInput = true;
            alertBox.message = "The format for the Start date is dd-MM-yyyy";
            
            //Display the alertBox
            self.present(alertBox, animated: true);
        }
        
        if((isValidDate(dateString: endDate.text!) == false) && wrongInput != true){
            //Define that something is wrong
            wrongInput = true;
            alertBox.message = "The format for the End date is dd-MM-yyyy";
            
            //Display the alertBox
            self.present(alertBox, animated: true);
        }
        
        if((isValidTexte(test: refApi.text!) == false) && wrongInput != true){
            //Define that something is wrong
            wrongInput = true;
            alertBox.message = "refapi";
            
            //Display the alertBox
            self.present(alertBox, animated: true);
        }
        
        if(wrongInput == false){
            
           performSegue(withIdentifier: "nextSegue", sender: self)
        }
        
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
