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

class DetailAvailability: UIViewController, UITableViewDataSource, UITableViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource{
   
    //1------- DECLARED VARIABLES
    private var data:[Competition] = []
    var selectedDiscipline:String?
    var name:String?
    var date:String?
    var myCompetition:Competition?
    var myMission:Mission?
    var pickerData: [String] = [String]()
    var missionData: [String] = [String]()
    
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
        self.selectedDiscipline = pickerData[row]
        
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
            self.present(alertBox, animated: true);
        }
    
    //Next page will be opened
    @IBAction func nextButton(_ sender: Any) {
            performSegue(withIdentifier: "MyNextSegue", sender: self)
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
            
            let text = missionData[indexPath.row] //2.
            
            cell.textLabel?.text = text //3.
            cell.textLabel?.font = UIFont(name: "Avenir Next", size: 18)
            cell.textLabel?.textColor = UIColor.white
            
            return cell //4.
        }
    
    
    
    
    //---------------- FIREBASE CONNECTION -----------------
    func loadMissionData(disciplineName: String){
        FirebaseManager.getMissionsOfDisciplines(competitionName: self.name!, disciplineName: disciplineName) { (missionData) in
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
}
