//
//  DetailAvailability.swift
//  skirun
//
//  Created by Admin on 25.03.19.
//  Copyright © 2019 hevs. All rights reserved.
//

/* @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
         1. Attributes
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

    
   
    //1------- Attributes
    private var data:[Competition] = []
    public var name:String?
    public var date:String?
    private var alreadyReloaded:Bool = true
    private var myDiscipline:String?
    private var myCompetition:Competition?
    private var myMission:Mission?
    private var pickerData: [String] = [String]()
    private var missionData:[Mission] = []
    private var choosenMissions:[Int] = []
    private var notChoosenMissions:[Int] = []
    private var alreadySubscribedMissions: [String] = []
    private var fontSizeCell:CGFloat?
    
    //Frontend elements
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var myWaitAnimation: UIActivityIndicatorView!
    @IBOutlet weak var myCompetitionName: UILabel!
    @IBOutlet weak var myStartDateLabel: UILabel!
    @IBOutlet weak var myPicker: UIPickerView!
    @IBOutlet weak var chooseMisLabel: UILabel!
    @IBOutlet weak var chooseDiscLabel: UILabel!
    
    //Constructor
    override func viewDidLoad() {
            super.viewDidLoad()
            self.fontSizeCell = 20
            tableView.dataSource = self
            checkDeviceSize()
            loadCompetitionData()
            self.myCompetitionName.text = self.name
            //self.myStartDateLabel.text = self.name
        
            self.myPicker.delegate = self
            self.myPicker.dataSource = self
            loadDisciplineData()
        }
    
    //Method to rearange elements when u are using small devices like iphoneSE
    func checkDeviceSize(){
        let screenSize: CGRect = UIScreen.main.bounds
        let screenHeight = screenSize.height
        let factor = screenHeight/568
        if(factor < 1.2){
            self.fontSizeCell = 15
            self.chooseMisLabel.font = UIFont(name: "AvenirNext-MediumItalic", size: 15)
            self.chooseDiscLabel.font = UIFont(name: "AvenirNext-MediumItalic", size: 15)
        }
    }

    
    //2 PICKER METHODS -------------------------
    //Picker for one element
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1;
    }
    
    //Max element of picker array
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        pickerView.subviews.forEach({
            $0.isHidden = $0.frame.height < 1.0
        })
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
        self.alreadySubscribedMissions.removeAll()
        
        //Important that when have no data nothing empty table is displayed
        self.missionData.removeAll()
        self.tableView.reloadData()
        //load the data for missions
        if(row>0){
            self.myWaitAnimation.startAnimating()
            loadMissionData(disciplineName: pickerData[row])
        
            //checkAlreadySubscribed()
            self.alreadyReloaded = false
        }
    }
    
    //Picker formatting
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let view = UIView(frame: CGRect(x:0, y:0, width:400, height: self.fontSizeCell!+10))
        
        let topLabel = UILabel(frame: CGRect(x:0, y:0, width: 400, height: self.fontSizeCell!+10))
        topLabel.text = pickerData[row]
        topLabel.textColor = UIColor.white
        topLabel.textAlignment = .center
        topLabel.font = UIFont(name: "Avenir Next Medium", size: self.fontSizeCell!)
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
            modifySubscriber()
        }
    }
    
    //Open previous page
    @IBAction func backButton(_ sender: Any) {
        print("BACK BUTTON")
        print("ChoosenMission", choosenMissions.count)
        print("NotChoosenMission", choosenMissions.count)
        
        if(choosenMissions.count > 0 || notChoosenMissions.count > 0){
            print("BACK BUTTON_FOUND STH")
            subscribe()
        }
        else{
             self.dismiss(animated: false, completion: nil)
        }
    }
    
    
    //4 TABLE VIEW ---------------------------------
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return missionData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "missionCell")! //1.
        
        var text = ""
        //EXCEPTION - CATCH NULLPOINTER
        do{
            let tempMission = try assignData(data: missionData, index: indexPath.row)//2.
            let start: UnixTime = tempMission.startTime
            let end: UnixTime = tempMission.endTime
            text = tempMission.jobs + " " + start.toHour + " - " + end.toHour
        } catch let error as NSError{
            print(error.localizedDescription)
            text = "NULL"
        }
            
        cell.textLabel?.text = text //3.
        cell.textLabel?.font = UIFont(name: "Avenir Next Medium", size: self.fontSizeCell!)
        cell.textLabel?.textColor = UIColor.white
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        
        
        //SWITCH BUTTON ---------------------------------
        let switchObj = UISwitch(frame: CGRect(x: 1, y: 1, width: 20, height: 20))
        let txt = missionData[indexPath.row].jobs + missionData[indexPath.row].title
        print(txt)
        if(alreadySubscribedMissions.contains(txt)){
            switchObj.isOn = true
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
    }
  
    //---------------- FIREBASE CONNECTION -----------------
    func loadMissionData(disciplineName: String){
        FirebaseManager.getMisOfDisciplines(competitionName: self.name!, disciplineName: disciplineName) { (missionData) in
            self.missionData = Array(missionData)
            self.checkAlreadySubscribed(missionData: self.missionData, nameCompetition: self.name!, disciplineName: disciplineName)
            self.tableView.reloadData()
            self.myWaitAnimation.stopAnimating()
        }
    }
    
    func checkAlreadySubscribed(missionData:[Mission], nameCompetition:String, disciplineName:String){
        FirebaseManager.checkIfAlreadySubscribed(uidUser: (Auth.auth().currentUser?.uid)!, missionData: missionData, nameDiscipline: disciplineName, nameCompetition: nameCompetition) { (data) in
            self.alreadySubscribedMissions = Array(data)
            
            self.tableView.reloadData()
        }
    }
    
    //Load data of discipline to display the list with its information
    func loadDisciplineData(){
        FirebaseManager.getDisciplinesOfCompetition(name: self.name!) { (pickerData) in
            self.pickerData = Array(pickerData)
            self.pickerData.insert("Please select", at: 0)
        }
    }
    
    //Load competition
    func loadCompetitionData(){
        FirebaseManager.getCompetiton(name: self.name! , completion: { (data) in
            self.myCompetition = data
            //self.myStartDateLabel.text = data.startDateTime.description
        })
    }
    
    //Save subscriber when selected
    func saveSubscriber(mission:String){
        FirebaseManager.saveSubscribersToMission(uidUser: (Auth.auth().currentUser?.uid)!,
                                                 nameMission: mission,
                                                 nameDiscipline: (self.myDiscipline)!,
                                                 nameCompetition: (self.myCompetition!.name))
    }
    
    //Delete a subscriber when deselected
    func deleteSubscriber(mission:String){
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
            self.modifySubscriber()
        }))
        alertBox.addAction(UIAlertAction(title: "No", style: .cancel, handler:{(action: UIAlertAction!) in
            self.dismiss(animated: true, completion: nil)
        }))
        self.present(alertBox, animated: true)
    }
    
    //ERROR - HANDLING
    func assignData(data:[Mission], index:Int) throws -> Mission{
        return data[index]
    }
    
    func modifySubscriber(){
        for item in self.choosenMissions {
            self.saveSubscriber(mission: self.missionData[item].title)
        }
        //DELETE DESELECTION
        for item in self.notChoosenMissions {
            self.deleteSubscriber(mission: self.missionData[item].title)
        }
        self.dismiss(animated: true, completion: nil)
    }
}
