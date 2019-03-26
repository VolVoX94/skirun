//
//  MissionCreationViewController.swift
//  skirun
//
//  Created by iOS Dev on 13.03.19.
//  Copyright © 2019 hevs. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase


class MissionCreationViewController: UIViewController , UIPickerViewDelegate, UIPickerViewDataSource {
    
    
    
    
    var myMission:Mission?

    @IBOutlet weak var typeOfJob: UITextField!
    @IBOutlet weak var startTime: UITextField!
    @IBOutlet weak var endTime: UITextField!
    @IBOutlet weak var nameMission: UITextField!
    @IBOutlet weak var nbPeople: UITextField!
    @IBOutlet weak var descriptionMission: UITextField!
   
    @IBOutlet weak var pickerView: UIPickerView!
    
    
    private var data: [String] = []
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pickerView.delegate = self
        pickerView.dataSource = self
        
        FirebaseManager.getDisciplines (completion: {(data) in
            self.data = Array (data)
            
            for item in data{
                print(item)
            }
        })
        
        
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {

        return data.count
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {

        return data[row]
    }
    
    
   /* func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return data.count
    }
    
   */
    
    
    // Function go back to the previous view
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
            alertBox.message = "The title of the Mission can contain text and/or numbers ";
            
            //Display the alertBox
            self.present(alertBox, animated: true);
        }
        
        if((isValidTime(test: startTime.text!) == false) && wrongInput != true){
            //Define that something is wrong
            wrongInput = true;
            alertBox.message = "The format for the start time is XX:XX";
            
            //Display the alertBox
            self.present(alertBox, animated: true);
        }
        
       if((isValidTime(test: endTime.text!) == false) && wrongInput != true){
            //Define that something is wrong
            wrongInput = true;
            alertBox.message = "The format for the end time is XX:XX";
            
            //Display the alertBox
            self.present(alertBox, animated: true);
        }
        
        if((isValidTexte(test: descriptionMission.text!) == false) && wrongInput != true){
            //Define that something is wrong
            wrongInput = true;
            alertBox.message = "Description of the mission, you can write some text and/or numbers";
            
            //Display the alertBox
            self.present(alertBox, animated: true);
        }
        
        if((isValidNbPeople(test: nbPeople.text!) == false) && wrongInput != true){
            //Define that something is wrong
            wrongInput = true;
            alertBox.message = "You have to enter a number of people you want for the mission";
            
            //Display the alertBox
            self.present(alertBox, animated: true);
        }
        
        if (wrongInput == false){
            
            //creation of the mission
            self.myMission = Mission(
                title: nameMission.text!,
                description: descriptionMission.text!,
                startTime: startTime.text!,
                endTime: endTime.text!,
                nbPeople: nbPeople.text!);
            
            print("----------------------xxxxxxxxxxxxxxxxxxxxxxxx----------------------------");
            print(myMission!.title + myMission!.description + myMission!.startTime + myMission!.endTime + myMission!.nbPeople);
            
            //-------Firebase---------
            
            createMission(title: nameMission.text!)
            
            
        }
        
    }
    
    func createMission(title:String){
        //3 ---- Create Mission
        
        //need load value from enum
        let missionSession:FirebaseSession = FirebaseSession.discipline;
        
        var ref: DatabaseReference!
        ref = Database.database().reference();
        ref.child(missionSession.rawValue).child(title).setValue(self.myMission!.toAnyObject());
        
        performSegue(withIdentifier: "saveMission", sender: self)
    }
    

    //Regex pattern see the title and description
    func isValidTexte(test:String)-> Bool {
        let textRegEx = "[A-Z-a-z-0-9]{4,20}"
        
        let textTest = NSPredicate(format: "SELF MATCHES %@", textRegEx)
        return textTest.evaluate(with:test)
    }
    
    //Regex pattern see the nbPeople
    func isValidNbPeople(test:String)-> Bool {
        
        let dateRegEx = "[0-9]{1,10}"
        
        let dateTest = NSPredicate(format: "SELF MATCHES %@", dateRegEx)
        return dateTest.evaluate(with:test)
        
    }
    
    //Regex pattern see the startTime and endTime
    func isValidTime(test:String)-> Bool{
        let timeRegEx = "[0-9][0-9]:[0-9][0-9]"
        
        let timeTest = NSPredicate(format: "SELF MATCHES %@", timeRegEx)
        return timeTest.evaluate(with:test)
        
    }
    
    
}
