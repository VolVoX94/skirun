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
    
    @IBOutlet weak var firstPicker_Height: NSLayoutConstraint!
    @IBOutlet weak var secondPicker_Height: NSLayoutConstraint!
    
    @IBOutlet weak var label_NumberOfPeople: UILabel!
    @IBOutlet weak var datePickerMenu_Height: NSLayoutConstraint!
    @IBOutlet weak var buttonBottom_Gap: NSLayoutConstraint!
    @IBOutlet var swipeRight: UISwipeGestureRecognizer!
    
//--- Attributes for the MissionCreation View
    @IBOutlet weak var save: UIBarButtonItem!
    @IBOutlet weak var location: UITextField!
    @IBOutlet weak var nameMission: UITextField!
    @IBOutlet weak var nbPeople: UITextField!
    @IBOutlet weak var descriptionMission: UITextField!
    @IBOutlet weak var myAdminButton: UIButton!
    @IBOutlet weak var jobPrinted: UITextField!
    @IBOutlet weak var discipline: UITextField!
    
//--- Picker for the job
    @IBOutlet weak var pickerJob: UIPickerView!
    var job:[String] = [String]()
    
//--- Picker for the disciplines
    @IBOutlet weak var pickerView: UIPickerView!
    var data: [String] = [String]()
    
    
//--- Picker for the Start and End time
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var endTime: UITextField!
    @IBOutlet weak var startTime: UITextField!
    var startTimeInt = 0
    var endTimeInt = 0
    
    var mission: Mission?
    var disciplineChoose = "none"
    var missionChoose = "none"
    var competitionChoose = "none"
    var nbdiscipline = 0
    var disciplines: String?
    var jobs: String?
    
//--- Button that refers to the view Admin Subscriber
    @IBAction func myAdminButton(_ sender: Any) {
         performSegue(withIdentifier: "MyAdminSegue", sender: self)
    }
    //--- Function that hides the datePicker
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
        datePicker.isHidden = true
    }
//--- Function that allows you to retrieve fields in order to retrieve them in the next view
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        
        print("prepare link to manage")
        let destinationController = segue.destination as! AdminSubscriberViewController;
        destinationController.competitionName = self.competitionChoose;
        destinationController.disciplineName = self.disciplineChoose;
        destinationController.missionName = self.missionChoose
    }
    
//---------- Time function for edit and changed value ----------
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
//---------- End of all times function ----------
    
    
//----------  Function called to load the view ----------
    override func viewDidLoad() {
        super.viewDidLoad()
        checkDeviceSize()
        datePicker.isHidden = true
        discipline.isHidden = true
        jobPrinted.isHidden = true
        datePicker.backgroundColor = UIColor.white
        loadJobData()
        loadDisciplineData()
        print("missionChoose-----", self.missionChoose)
        if(missionChoose != "none"){
            loadMission()
            swipeRight.addTarget(self, action: #selector(handleSwipe(sender:)))
            view.addGestureRecognizer(swipeRight)
        }
        
    }
    
    func checkDeviceSize(){
        let screenSize: CGRect = UIScreen.main.bounds
        let screenHeight = screenSize.height
        let factor = screenHeight/568
        if(factor < 1.2){
            self.descriptionMission.font = UIFont(name: "Avenir Next Medium", size: 15)
            self.location.font = UIFont(name: "Avenir Next Medium", size: 15)
            self.nameMission.font = UIFont(name: "Avenir Next Medium", size: 15)
            self.startTime.font = UIFont(name: "Avenir Next Medium", size: 15)
            self.endTime.font = UIFont(name: "Avenir Next Medium", size: 15)
            self.firstPicker_Height.constant = 60
            self.secondPicker_Height.constant = 60
            
            self.buttonBottom_Gap.constant = 15
            
                self.datePickerMenu_Height.constant = 150
            self.label_NumberOfPeople.font = UIFont(name: "Avenir Next Medium", size: 15)
        }
    }

//---------- PickerView function ----------
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        if (pickerView.tag == 0){
            let view = UIView(frame: CGRect(x:0, y:0, width:400, height: 30))
            
            let topLabel = UILabel(frame: CGRect(x:0, y:0, width: 400, height: 30))
            topLabel.text = job[row]
            topLabel.textColor = UIColor.white
            topLabel.textAlignment = .center
            topLabel.font = UIFont(name: "Avenir Next Medium", size: 20)
            view.addSubview(topLabel)
            
            return view
            
        }else{
            let view = UIView(frame: CGRect(x:0, y:0, width:400, height: 30))
            
            let topLabel = UILabel(frame: CGRect(x:0, y:0, width: 400, height: 30))
            topLabel.text = data[row]
            topLabel.textColor = UIColor.white
            topLabel.textAlignment = .center
            topLabel.font = UIFont(name: "Avenir Next Medium", size: 20)
            view.addSubview(topLabel)
            
            return view
        }
    }
    
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        pickerView.subviews.forEach({
            $0.isHidden = $0.frame.height < 1.0
        })
        
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
    
//--- Check wich picker and which element have been choosen
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if(pickerView.tag == 1){
            self.disciplines = data[row]
                
        }else{
            self.jobs = job[row]
            
        }

    }
//---------- End of the pickerView function ----------
    
    
//---------- Function that loads and displays an existing mission ----------
    func loadMission(){
//--- Disable all the fields and Hide the pickers
        nameMission.isEnabled = false
        location.isEnabled = false
        descriptionMission.isEnabled = false
        nbPeople.isEnabled = false
        startTime.isEnabled = false
        endTime.isEnabled = false
        pickerView.isHidden = true
        pickerJob.isHidden = true
        discipline.isHidden = false;
        discipline.isEnabled = false;
        jobPrinted.isHidden = false;
        jobPrinted.isEnabled = false;
        save.isEnabled = false;
        save.title = ""
        
//--- Get a mission in Firebase and display it in a form
        FirebaseManager.getMission(nameCompetition: competitionChoose, nameDiscipline: disciplineChoose, nameMission: missionChoose) { (data) in
            self.mission = data
            self.nameMission.text = self.mission?.title
            self.location.text = self.mission?.location
            self.descriptionMission.text = self.mission?.description
            let start: UnixTime =
            (self.mission?.startTime)!
            self.startTime.text = start.toDateTime
            let end: UnixTime =
            (self.mission?.endTime)!
            self.endTime.text = end.toDateTime
            self.nbPeople.text =  self.mission?.nbPeople.description
            
            self.discipline.text = self.disciplineChoose
            self.jobPrinted.text = self.mission?.jobs
            
            }
    }
    
//---------- End of the function that loads and displays an existing mission ----------
    
    
//---------- Function that calls getJobs (Firebase Manager) and returns all existing jobs ----------
    func loadJobData(){
        FirebaseManager.getJobs(completion: { (data) in
            self.job = Array(data)
            self.pickerJob.delegate = self
            self.pickerJob.dataSource = self
        })
    }
    
//---------- Function that calls getDisciplines (Firebase Manager) and returns all disciplines existing ----------
    func loadDisciplineData(){
        FirebaseManager.getDisciplines(completion: { (Pdata) in
            self.data = Array(Pdata)
            self.pickerView.delegate = self
            self.pickerView.dataSource = self
        })
    }
    
//---------- Function Save a Mission ----------
   @IBAction func saveMission(_ sender: Any) {
        
//--- UIAlert Box that displays an error when an Input is wrong
        let alertBox = UIAlertController(
            title: "Input wrong",
            message: "",
            preferredStyle: .actionSheet)
        
        alertBox.addAction(UIAlertAction(title:"OK",
                                         style: .cancel, handler:nil))
    
//--- Test the name Mission, it must contain more than 4 characters or not be Empty
        if(nameMission.text!.count < 4) || (nameMission.text ?? "").isEmpty{
            
//--- Create of a personal message
            alertBox.message = "The title of the Mission must be longer !";
            
//--- Display the alertBox with the personal message
            self.present(alertBox, animated: true);
            
            return;
        }

//--- Test the description of the Mission , it must contain more than 4 characters or not be Empty
        if(descriptionMission.text!.count < 4) || (descriptionMission.text ?? "").isEmpty{

//--- Create of a personal message
            alertBox.message = " The description of the mission must be longer !";
            
//--- Display the alertBox with the personal message
            self.present(alertBox, animated: true);
            
            return;
        }
    
 //--- Test the location of the Mission , it must contain more than 4 characters
        if(location.text!.count < 4) {
            
//--- Create of a personal message
            alertBox.message = "The Location of the mission must be longer !";
        
//--- Display the alertBox with the personal message
            self.present(alertBox, animated: true);
            
            return;
        }
    
//--- Test the Start Time of the Mission , it must be before that the endTime
    if(startTimeInt > endTimeInt){
        
//--- Create of a personal message
        alertBox.message = "End date can't be before start date !";
        
//--- Display the alertBox with the personal message
        self.present(alertBox, animated: true);
        
        return;
    }
    
 //--- Test the nbre of people of the Mission , it can't be 0
    if(0>=(Int(nbPeople.text ?? "0") ?? 0)){
        
//--- Create of a personal message
        alertBox.message = "Minimum one person !";
            
//--- Display the alertBox with the personal message
        self.present(alertBox, animated: true);
        
        return;
        }
    
//--- Call the function to add the mission in Firebase
        createMission()
        
    }
    
//---------- Function create a Mission on save it in Firebase
    func createMission(){
        
//--- Create an empty Mission, and add all the fields that come from the form
        let newMission = Mission(title: nameMission.text ?? "Error", description: descriptionMission.text ?? "Error", startTime: startTimeInt, endTime: endTimeInt, nbPeople: Int(nbPeople.text!)! ,location: location.text ?? "Error", jobs: jobs ?? job[0])
        
//--- Create the reference of Firebase
        let ref:DatabaseReference = Database.database().reference().child(FirebaseSession.competition.rawValue).child(self.competitionChoose).child(FirebaseSession.NODE_DISCIPLINES.rawValue).child(disciplines ?? data[0]).child(newMission.title);
        
        
//--- Test to see if the mission already exist in Firebase
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            
//--- The mission exist
            if snapshot.hasChildren(){
                
//--- Create the alert box with a wrong message
                let alertBox = UIAlertController(title: "This mission already exist !", message: "", preferredStyle: .actionSheet)
                
//--- Add to the box an Alert with a button
                alertBox.addAction(UIAlertAction(title:"Ok", style: .cancel, handler:nil))
                
//--- Display the alert box
                self.present(alertBox, animated: true);
                
                

            }
//--- The mission didn't exist
            else
            {
                
//--- Add the mission to Firebase
                ref.setValue(newMission.toAnyObject())
                self.dismiss(animated: false, completion: nil)
            }
        })
 
    }
    
    
    
//--- Button that refers to the view competition
    @IBAction func back(_ sender: Any) {
        self.disciplineChoose = "none"
         self.missionChoose = "none"
         self.competitionChoose = "none"
         self.dismiss(animated: false, completion: nil)
    }
    
    @objc func handleSwipe(sender: UISwipeGestureRecognizer) {
        if sender.state == .ended {
            
            let title = "Delete the mission"
            let message = "This action will delete the mission and all result associated ! To continue, enter the name of the mission."
            
            let inputController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            inputController.addTextField { (textField: UITextField!) in
                textField.placeholder = "Mission name"
            }
            
            let submitAction = UIAlertAction(title: "Delete", style: .destructive) { (paramAction:UIAlertAction) in
                if let textFields = inputController.textFields{
                    let theTextFields = textFields as [UITextField]
                    let name = theTextFields[0].text!
                    
                    if(name == self.missionChoose){
                        self.deleteMission(name: name)
                    }else{
                        self.present(inputController, animated: true, completion: nil)
                    }
                }
            }
            let cancel = UIAlertAction(title: "Cancel", style: .cancel)
            inputController.addAction(cancel)
            inputController.addAction(submitAction)
            self.present(inputController, animated: true, completion: nil)
        }
    }
    
    func deleteMission(name: String){
        let ref:DatabaseReference = Database.database().reference().child(FirebaseSession.competition.rawValue).child(self.competitionChoose).child(FirebaseSession.NODE_DISCIPLINES.rawValue).child(self.disciplineChoose).child(name);
        ref.removeValue()
        self.dismiss(animated: false, completion: nil)
    }
    
    
}
    

