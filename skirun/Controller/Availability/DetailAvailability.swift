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
         6. mainSubscribe-Method
 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ß
 */




import UIKit
import Firebase

class DetailAvailability: UIViewController, UITableViewDataSource, UITableViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource{

    
   
    //1------- DECLARED VARIABLES
    private var data:[Competition] = []
    var name:String?
    var date:String?
    var alreadyReloaded:Bool = true
    var myDiscipline:String?
    var myCompetition:Competition?
    var myMission:Mission?
    var pickerData: [String] = [String]()
    var missionData:[Mission] = []
    var choosenMissions:[Int] = []
    var notChoosenMissions:[Int] = []
    var alreadySubscribedMissions: [String] = []
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var myCompetitionName: UILabel!
    
    @IBOutlet weak var myStartDateLabel: UILabel!
        
    @IBOutlet weak var myPicker: UIPickerView!
    
    override func viewDidLoad() {
            super.viewDidLoad()
            tableView.dataSource = self
            
            loadCompetitionData()
            self.myCompetitionName.text = self.name
            //self.myStartDateLabel.text = self.name
        
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
        self.notChoosenMissions.removeAll()
        self.choosenMissions.removeAll()
        self.myDiscipline = pickerData[row]
        //load the data for missions
        if(row>0){
            loadMissionData(disciplineName: pickerData[row])
            //checkAlreadySubscribed()
            self.alreadyReloaded = false
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
        
        //Display the alertBox
        if(choosenMissions.count <= 0 && notChoosenMissions.count <= 0){
            let alertBox = UIAlertController(
                title: "Oh ooooh",
                message: "",
                preferredStyle: .actionSheet);
            
            //Define that something is wrong
            alertBox.message = "You have to select a mission";
            alertBox.addAction(UIAlertAction(title: "Ok", style: .cancel, handler:nil))
            self.present(alertBox, animated: true);
        }
        else{
            subscribe()
        }
    }
    
    //Open previous page
    @IBAction func backButton(_ sender: Any) {
        if(choosenMissions.count > 0 || notChoosenMissions.count > 0){
            subscribe()
        }
        else{
             self.dismiss(animated: true, completion: nil)
        }
    }
    
    
    //4 TABLE VIEW ---------------------------------
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return missionData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "missionCell")! //1.
        //2.
        let tempMission = missionData[indexPath.row]
            
        let start: UnixTime = missionData[indexPath.row].startTime
        let end: UnixTime = missionData[indexPath.row].endTime
        let text = tempMission.jobs + " " + start.toHour + " - " + end.toHour
            
        cell.textLabel?.text = text //3.
        cell.textLabel?.font = UIFont(name: "Avenir Next", size: 18)
        cell.textLabel?.textColor = UIColor.white
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        
        
        //SWITCH BUTTON ---------------------------------
        let switchObj = UISwitch(frame: CGRect(x: 1, y: 1, width: 20, height: 20))
        print("compared Value", missionData[indexPath.row].jobs)
        if(alreadySubscribedMissions.contains(missionData[indexPath.row].jobs)){
            print("switched on")
            switchObj.isOn = true
            choosenMissions.append(indexPath.row)
        }
        else{
            switchObj.isOn = false;
        }
       
        switchObj.addTarget(self, action: #selector(toggel(_:name:)), for: .valueChanged)
        switchObj.tag = indexPath.row
        cell.accessoryView = switchObj
      
        return cell //4.
    }
    
    @objc func toggel(_ sender:UISwitch, name:String){

        if(sender.isOn){
            //ADD element
            choosenMissions.append(sender.tag);
            notChoosenMissions = notChoosenMissions.filter{$0 != sender.tag}
        }
        else{
            //DELETE element
            choosenMissions = choosenMissions.filter{$0 != sender.tag}
            notChoosenMissions.append(sender.tag)
        }
        print("choosenMission",choosenMissions.count)
        print("NotCHoosenMission",notChoosenMissions.count)
    }
  
    //---------------- FIREBASE CONNECTION -----------------
    func loadMissionData(disciplineName: String){
        FirebaseManager.getMisOfDisciplines(competitionName: self.name!, disciplineName: disciplineName) { (missionData) in
            self.missionData = Array(missionData)
            self.checkAlreadySubscribed(missionData: self.missionData, nameCompetition: self.name!, disciplineName: disciplineName)
            
            
        }
    }
    
    func checkAlreadySubscribed(missionData:[Mission], nameCompetition:String, disciplineName:String){
        FirebaseManager.checkIfAlreadySubscribed(uidUser: (Auth.auth().currentUser?.uid)!, missionData: missionData, nameDiscipline: disciplineName, nameCompetition: nameCompetition) { (data) in
            self.alreadySubscribedMissions = Array(data)
            
            self.tableView.reloadData()
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
        print("added")
        FirebaseManager.saveSubscribersToMission(uidUser: (Auth.auth().currentUser?.uid)!,
                                                 nameMission: mission,
                                                 nameDiscipline: (self.myDiscipline)!,
                                                 nameCompetition: (self.myCompetition!.name))
    }
    
    func deleteSubscriber(mission:String){
        print("deleted")
        FirebaseManager.deleteSubscriber(uidUser: (Auth.auth().currentUser?.uid)!,
                                                 nameMission: mission,
                                                 nameDiscipline: (self.myDiscipline)!,
                                                 nameCompetition: (self.myCompetition!.name))
    }
    
    //6 MAIN SUBSCRIBE METHOD ---------------
    func subscribe(){
        let alertBox = UIAlertController(
            title: "Confirmation",
            message: "",
            preferredStyle: .actionSheet);
        
        //Define that something is wrong
        alertBox.message = "Do you want to submit your choice?";
        alertBox.addAction(UIAlertAction(title: "Yes", style: .default, handler:{ (action: UIAlertAction!) in
            //SUBSCRIBE SELECTION
            for item in self.choosenMissions {
                self.saveSubscriber(mission: self.missionData[item].title)
            }
            //DELETE DESELECTION
            for item in self.notChoosenMissions {
                self.deleteSubscriber(mission: self.missionData[item].title)
            }
            self.dismiss(animated: true, completion: nil)
        }))
        alertBox.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler:{(action: UIAlertAction!) in
            self.dismiss(animated: true, completion: nil)
        }))
        self.present(alertBox, animated: true)
    }
}
