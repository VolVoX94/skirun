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
    
    
    var disciplines: String?
    var jobs: String?

    @IBOutlet weak var location: UITextField!
    @IBOutlet weak var nameMission: UITextField!
    @IBOutlet weak var nbPeople: UITextField!
    @IBOutlet weak var descriptionMission: UITextField!
    @IBOutlet weak var myAdminButton: UIButton!
    

    @IBOutlet weak var jobPrinted: UITextField!
    @IBOutlet weak var discipline: UITextField!
    
    // Picker for the job
    @IBOutlet weak var pickerJob: UIPickerView!
    var job:[String] = [String]()
    
    // Picker for the disciplines
    @IBOutlet weak var pickerView: UIPickerView!
    var data: [String] = [String]()
    
    
    // Picker for the start and end time
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
    
    //------Button
    
    @IBAction func myAdminFunc(_ sender: Any) {
        performSegue(withIdentifier: "MyAdminSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        
        print("prepare link to manage")
        let destinationController = segue.destination as! AdminSubscriberViewController;
        destinationController.competitionName = self.competitionChoose;
        destinationController.disciplineName = self.disciplineChoose;
        destinationController.missionName = self.missionChoose
    }
    
    //--------- Time function for edit and changed value -------------------
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
    //--------- End of the time function -------------------
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        datePicker.isHidden = true
        discipline.isHidden = true
        jobPrinted.isHidden = true
        datePicker.backgroundColor = UIColor.white
        loadJobData()
        loadDisciplineData()
        print("missionChoose-----", self.missionChoose)
        if(missionChoose != "none"){
            loadMission()
        }
        
    }

    
    //--------- PickerView function -------------
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        if (pickerView.tag == 0){
            let view = UIView(frame: CGRect(x:0, y:0, width:400, height: 30))
            
            let topLabel = UILabel(frame: CGRect(x:0, y:0, width: 400, height: 14))
            topLabel.text = job[row]
            topLabel.textColor = UIColor.white
            topLabel.textAlignment = .center
            topLabel.font = UIFont.systemFont(ofSize: 14)
            view.addSubview(topLabel)
            
            return view
            
        }else{
            let view = UIView(frame: CGRect(x:0, y:0, width:400, height: 30))
            
            let topLabel = UILabel(frame: CGRect(x:0, y:0, width: 400, height: 14))
            topLabel.text = data[row]
            topLabel.textColor = UIColor.white
            topLabel.textAlignment = .center
            topLabel.font = UIFont.systemFont(ofSize: 14)
            view.addSubview(topLabel)
            
            return view
        }
    }
    
    
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
    
    
    //Check wich element has been choosen
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if(pickerView.tag == 1){
            self.disciplines = data[row]
                
        }else{
            self.jobs = job[row]
            
        }

    }
    
    //------------ End of the stuff print discipline or jobs -------------
    
    func loadMission(){
        //disable the field
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
        self.dismiss(animated: true, completion: nil)
    }
    
    // Function Save a Mission
   @IBAction func saveMission(_ sender: Any) {
        var wrongInput = false;
        
        //UIAlert
        let alertBox = UIAlertController(
            title: "Input wrong",
            message: "",
            preferredStyle: .actionSheet)
        
        alertBox.addAction(UIAlertAction(title:"OK",
                                         style: .cancel, handler:nil))
        
        if(nameMission.text!.count < 4) || (nameMission.text ?? "").isEmpty{
            
            //Define that something is wrong
            wrongInput = true;
            alertBox.message = "The title of the Mission can contain text and/or numbers ";
            
            //Display the alertBox
            self.present(alertBox, animated: true);
        }
        
        if(descriptionMission.text!.count < 4) || (descriptionMission.text ?? "").isEmpty{
            //Define that something is wrong
            wrongInput = true;
            alertBox.message = "Description of the mission, you can write some text and/or numbers";
            
            //Display the alertBox
            self.present(alertBox, animated: true);
        }
    
        if(location.text!.count < 4) || (location.text ?? "").isEmpty{
            //Define that something is wrong
            wrongInput = true;
            alertBox.message = "The Location of the mission, you can write some text and/or numbers";
        
            //Display the alertBox
            self.present(alertBox, animated: true);
        }
    
    if(startTimeInt > endTimeInt){
        alertBox.message = "End date can't be before start date !";
        
        //Display the alertBox
        self.present(alertBox, animated: true);
    }
        
    if(0>=(Int(nbPeople.text!)!) && wrongInput != true){
            //Define that something is wrong
            wrongInput = true;
            alertBox.message = "Input wrong please enter a number";
            
            //Display the alertBox
            self.present(alertBox, animated: true);
        
        }
        
        createMission()
        
    }
    
    func createMission(){
        //3 ---- Create Mission
        
        let newMission = Mission(title: nameMission.text ?? "Error", description: descriptionMission.text ?? "Error", startTime: startTimeInt, endTime: endTimeInt, nbPeople: Int(nbPeople.text!)! ,location: location.text ?? "Error", jobs: jobs ?? job[0])
        
        
        let ref:DatabaseReference = Database.database().reference().child(FirebaseSession.competition.rawValue).child(self.competitionChoose).child(FirebaseSession.NODE_DISCIPLINES.rawValue).child(disciplines ?? data[0]).child(newMission.title);
        
        
        //add the object
        ref.setValue(newMission.toAnyObject())
        
       
    }
    
    
    
    
    @IBAction func back(_ sender: Any) {
        self.disciplineChoose = "none"
         self.missionChoose = "none"
         self.competitionChoose = "none"
         self.dismiss(animated: false, completion: nil)
    }
    
    
}
    

