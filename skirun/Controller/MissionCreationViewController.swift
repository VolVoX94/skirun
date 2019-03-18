//
//  MissionCreationViewController.swift
//  skirun
//
//  Created by iOS Dev on 13.03.19.
//  Copyright © 2019 hevs. All rights reserved.
//

import UIKit


class MissionCreationViewController: UIViewController {
    
    
    @IBOutlet weak var startTime: UITextField!
    @IBOutlet weak var endTime: UITextField!
    @IBOutlet weak var nameMission: UITextField!
    @IBOutlet weak var nbPeople: UITextField!
    @IBOutlet weak var descriptionMission: UITextField!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func backCompetition(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveMission(_ sender: Any) {
        var wrongInput = false;
        
        //UIAlert
        let alertBox = UIAlertController(
            title: "Input wrong",
            message: "",
            preferredStyle: .actionSheet)
        
        alertBox.addAction(UIAlertAction(title:"OK",
                                         style: .cancel, handler:nil))
        
        if((isValidTexte(test: nameMission.text!) == false)){
            
            //Define that something is wrong
            wrongInput = true;
            alertBox.message = "The title can contain text and/or numbers ";
            
            //Display the alertBox
            self.present(alertBox, animated: true);
        }
        
        if((isValidTime(test: startTime.text!) == false) && wrongInput != true){
            //Define that something is wrong
            wrongInput = true;
            alertBox.message = "The format for the Start date is dd-MM-yyyy";
            
            //Display the alertBox
            self.present(alertBox, animated: true);
        }
        
        if((isValidTime(test: endTime.text!) == false) && wrongInput != true){
            //Define that something is wrong
            wrongInput = true;
            alertBox.message = "The format for the Start date is dd-MM-yyyy";
            
            //Display the alertBox
            self.present(alertBox, animated: true);
        }
        
        if((isValidTexte(test: descriptionMission.text!) == false) && wrongInput != true){
            //Define that something is wrong
            wrongInput = true;
            alertBox.message = "The format for the Start date is dd-MM-yyyy";
            
            //Display the alertBox
            self.present(alertBox, animated: true);
        }
        
        if((isValidNbPeople(test: nbPeople.text!) == false) && wrongInput != true){
            //Define that something is wrong
            wrongInput = true;
            alertBox.message = "The format for the Start date is dd-MM-yyyy";
            
            //Display the alertBox
            self.present(alertBox, animated: true);
        }
        
    }
    

    func isValidTexte(test:String)-> Bool {
        let textRegEx = "[A-Z-a-z-0-9]{4,20}"
        
        let textTest = NSPredicate(format: "SELF MATCHES %@", textRegEx)
        return textTest.evaluate(with:test)
    }
    
    func isValidNbPeople(test:String)-> Bool {
        
        let dateRegEx = "[0-9]{1,10}"
        
        let dateTest = NSPredicate(format: "SELF MATCHES %@", dateRegEx)
        return dateTest.evaluate(with:test)
        
    }
    
    func isValidTime(test:String)-> Bool{
        let timeRegEx = "[0-9][0-9]:[0-9][0-9]"
        
        let timeTest = NSPredicate(format: "SELF MATCHES %@", timeRegEx)
        return timeTest.evaluate(with:test)
        
    }
    
    
}
