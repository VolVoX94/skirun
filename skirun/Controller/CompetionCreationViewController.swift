//
//  CompetionCreationViewController.swift
//  skirun
//
//  Created by iOS Dev on 13.03.19.
//  Copyright © 2019 hevs. All rights reserved.
//

import UIKit

class CompetionCreationViewController: UIViewController {
    
    @IBOutlet weak var tileCompetion: UITextField!
    @IBOutlet weak var endDate: UITextField!
    @IBOutlet weak var discipline: UITextField!
    @IBOutlet weak var refApi: UITextField!
    @IBOutlet weak var save: UIBarButtonItem!
    @IBOutlet weak var startDate: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.        
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
        
        
        if((isValidTexte(test: tileCompetion.text!) == false)){
            
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
        
        if((isValidTexte(test: discipline.text!) == false) && wrongInput != true){
            //Define that something is wrong
            wrongInput = true;
            alertBox.message = "Write your discipline with characters and/or numbers";
            
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
