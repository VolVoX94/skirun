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


    // Time part
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var endTime: UITextField!
    @IBOutlet weak var startTime: UITextField!
    var startTimeInt = 0
    var endTimeInt = 0
    
    //----------------------------------------
    
    @IBOutlet weak var nameMission: UITextField!
    @IBOutlet weak var nbPeople: UITextField!
    @IBOutlet weak var descriptionMission: UITextField!
    
    // Picker for the job
    @IBOutlet weak var pickerJob: UIPickerView!
    var job:[String] = [String]()
    
    // Picker for the disciplines
    @IBOutlet weak var pickerView: UIPickerView!
    var data: [String] = [String]()
    
    
    //--------- Date Picker -------------------
    
    
    @IBAction func starTimeEdit(_ sender: UITextField) {
        startTime.inputView = UIView()
        datePicker.isHidden = false
    }
    
    
    @IBAction func starTimeEditEnd(_ sender: UITextField) {
        datePicker.isHidden = true
    }
    
   
    @IBAction func endTimeEdit(_ sender: UITextField) {
        endTime.inputView = UIView()
        datePicker.isHidden = false
    }
    
    
    @IBAction func editTimeEditEnd(_ sender: UITextField) {
        datePicker.isHidden = true
    }
    
    
    @IBAction func valueChanged(_ sender: UIDatePicker) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/YYYY HH:mm"
        let result = dateFormatter.string(from: sender.date)
        
        if startTime.isFirstResponder{
            startTime.text = result
            startTimeInt = Int(sender.date.timeIntervalSince1970.rounded())
        }
        if endTime.isFirstResponder{
            endTime.text = result
            endTimeInt = Int(sender.date.timeIntervalSince1970.rounded())
        }
        
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        datePicker.isHidden = true
        datePicker.backgroundColor = UIColor.white
        loadJobData()
        loadDisciplineData()
        
        
    }

    
    //--------- End part of the Date Picker-----------
    
    //--------- PickerView function -------------
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if (pickerView.tag == 0){
            return job.count
        }else{
            return data.count
        }

    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if (pickerView.tag == 0){
            return "\(job[row])"
        }else{
            return "\(data[row])"
        }

    }
    //-----------------End of the stuff print dscipline-------------------
    
    // call the function in FirebaseManager getJobs ==> return all the jobs existing
    func loadJobData(){
        FirebaseManager.getJobs(completion: { (data) in
            self.job = Array(data)
            self.pickerJob.delegate = self
            self.pickerJob.dataSource = self
        })
    }
    
    // call the function in FirebaseManager getDisciplines ==> return all the disciplines existing
    func loadDisciplineData(){
        FirebaseManager.getDisciplines(completion: { (Pdata) in
            self.data = Array(Pdata)
            self.pickerView.delegate = self
            self.pickerView.dataSource = self
        })
    }
    
    // Function go back to the previous view
    @IBAction func backCompetition(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
   /* @IBAction func saveMission(_ sender: Any) {
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
                nbPeople: nbPeople.text!);
            
            print("----------------------xxxxxxxxxxxxxxxxxxxxxxxx----------------------------");
            print(myMission!.title + myMission!.description + myMission!.startTime + myMission!.endTime + myMission!.nbPeople);
            
            //-------Firebase---------
            
            createMission(title: nameMission.text!)
            
            
        }
        
    }*/
    
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
    
    
    
    
    
    
}
