//
//  DetailAvailability.swift
//  skirun
//
//  Created by Admin on 25.03.19.
//  Copyright © 2019 hevs. All rights reserved.
//

/* @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
         1. Declared Variables
         2. PICKERVIEW
         3. BUTTONS
         4. TABLE VIEW - MISSIONS
         5. FIREBASE CONNECTION
 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ß
 */




import UIKit
import Firebase

class DetailAvailability: UIViewController, UITableViewDataSource, UITableViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource{
   
    //1------- DECLARED VARIABLES
    private var data:[Competition] = []
    var name:String?
    var date:String?
    var myDiscipline:String?
    var myCompetition:Competition?
    var myMission:Mission?
    var pickerData: [String] = [String]()
    var missionData:[Mission] = []
    var choosenMissions:[Int] = []
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var myCompetitionName: UILabel!
    
    @IBOutlet weak var myStartDateLabel: UILabel!
        
    @IBOutlet weak var myPicker: UIPickerView!
    
    override func viewDidLoad() {
            super.viewDidLoad()
            tableView.dataSource = self
            
            loadCompetitionData()
            self.myCompetitionName.text = self.name
            self.myStartDateLabel.text = self.name
        
            self.myPicker.delegate = self
            self.myPicker.dataSource = self
            loadDisciplineData()
        }
    
    //2 PICKER METHODS -------------------------
    //Picker for one element
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1;
    }
    
    //Max element of picker array
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    //Picker element
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    //Picker size
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 30
    }
    
    //Check wich element has been choosen
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.myDiscipline = pickerData[row]
        //load the data for missions
        if(pickerData[row] != "Please select"){
            loadMissionData(disciplineName: pickerData[row])
            self.tableView.reloadData()
        }
    }
    
    //Picker formatting
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let view = UIView(frame: CGRect(x:0, y:0, width:400, height: 30))
        
        let topLabel = UILabel(frame: CGRect(x:0, y:0, width: 400, height: 25))
        topLabel.text = pickerData[row]
        topLabel.textColor = UIColor.white
        topLabel.textAlignment = .center
        topLabel.font = UIFont.systemFont(ofSize: 25)
        view.addSubview(topLabel)
        
        return view
    }
    
    
    //3 BUTTONS -------------------------------------------------------
    //Enter subscribtion
    @IBAction func submitButton(_ sender: Any) {
        
        //Define a general UIAlert
        let alertBox = UIAlertController(
            title: "No role choosen",
            message: "",
            preferredStyle: .actionSheet);
        
            alertBox.addAction(UIAlertAction(title: "Ok", style: .cancel, handler:nil))
        
            //Define that something is wrong
            alertBox.message = "You have to select a mission";
            
            //Display the alertBox
        if(choosenMissions.count <= 0){
            self.present(alertBox, animated: true);
        }
        else{
            for item in choosenMissions {
                saveSubscriber(mission: self.missionData[item].title)
            }
            
            
            performSegue(withIdentifier: "goHome", sender: self)
        }
    }
    
    //Open previous page
    @IBAction func backButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    //4 TABLE VIEW ---------------------------------
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return missionData.count
    }
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("LLLLLLLLLL", missionData[indexPath.row])
        let cell = tableView.dequeueReusableCell(withIdentifier: "missionCell")! //1.
            
        //2.
        let tempMission = missionData[indexPath.row]
            
        let start: UnixTime = missionData[indexPath.row].startTime
        let end: UnixTime = missionData[indexPath.row].endTime
        let text = tempMission.typeJob + " " + start.toHour + " - " + end.toHour
            
        cell.textLabel?.text = text //3.
        cell.textLabel?.font = UIFont(name: "Avenir Next", size: 18)
        cell.textLabel?.textColor = UIColor.white
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        
        //SWITCH BUTTON ---------------------------------
        let switchObj = UISwitch(frame: CGRect(x: 1, y: 1, width: 20, height: 20))
        switchObj.isOn = false
        switchObj.addTarget(self, action: #selector(toggel(_:name:)), for: .valueChanged)
        switchObj.tag = indexPath.row
        cell.accessoryView = switchObj
        
        
        return cell //4.
    }
    
    @objc func toggel(_ sender:UISwitch, name:String){
        print("Switch", sender.tag)
        if(sender.isOn){
            //ADD element
            choosenMissions.append(sender.tag);
        }
        else{
            //DELETE element
            choosenMissions = choosenMissions.filter{$0 != sender.tag}
        }
        for item in choosenMissions {
            print(item)
        }
        //print(Auth.auth().currentUser?.uid)
    }
    
    
    
    
    //---------------- FIREBASE CONNECTION -----------------
    func loadMissionData(disciplineName: String){
        
        FirebaseManager.getMisOfDisciplines(competitionName: self.name!, disciplineName: disciplineName) { (missionData) in
            self.missionData = Array(missionData)
        }
    }
    
    func loadDisciplineData(){
        FirebaseManager.getDisciplinesOfCompetition(name: self.name!) { (pickerData) in
            self.pickerData = Array(pickerData)
            self.pickerData.insert("Please select", at: 0)
        }
    }
    
    func loadCompetitionData(){
        FirebaseManager.getCompetiton(name: self.name! , completion: { (data) in
            self.myCompetition = data
            self.myStartDateLabel.text = data.startDateTime.description
        })
    }
    
    func saveSubscriber(mission:String){
        FirebaseManager.saveSubscribersToMission(uidUser: (Auth.auth().currentUser?.uid)!,
                                                 nameMission: mission,
                                                 nameDiscipline: (self.myDiscipline)!,
                                                 nameCompetition: (self.myCompetition!.name))
    }
}
