//
//  CompetionCreationViewController.swift
//  skirun
//
//  Created by iOS Dev on 13.03.19.
//  Copyright © 2019 hevs. All rights reserved.
//

import UIKit
import Firebase

class CompetionCreationViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource , UITableViewDataSource, UITableViewDelegate {

    

   
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var titleCompetition: UITextField!
    @IBOutlet weak var endDate: UITextField!
    @IBOutlet weak var refApi: UITextField!
    @IBOutlet weak var save: UIBarButtonItem!
    @IBOutlet weak var startDate: UITextField!
    
    @IBOutlet weak var missionTableview: UITableView!
    @IBOutlet weak var disciplinePicker: UIPickerView!
    var pickerData: [String] = [String]()
    var missionData:[Mission] = []
    
    private var data:[String] = []
    var selectedMission = "none"

    
 
    var startDateInt = 0
    var endDateInt = 0

    
    override func viewDidLoad() {
        super.viewDidLoad()
        datePicker.isHidden=true
        datePicker.backgroundColor = UIColor.white
        
        self.disciplinePicker.delegate = self
        self.disciplinePicker.dataSource = self
        
        
        //If we have a competitions, we load it
        if(selectedCompetition != "none"){
            loadCompetition()
            loadDisciplineData()
            self.missionTableview.delegate = self
            self.missionTableview.dataSource = self
            self.disciplinePicker.isHidden = false
        }
        
    }
    
    @IBAction func startdateEditing(_ sender: UITextField) {
        startDate.inputView = UIView()
        datePicker.isHidden = false
    }
    
    @IBAction func startdateEditingEnd(_ sender: UITextField) {
        datePicker.isHidden = true
    }
    
    @IBAction func enddateEditing(_ sender: UITextField) {
        endDate.inputView = UIView()
        datePicker.isHidden = false
    }
    
    @IBAction func enddateEditingEnd(_ sender: UITextField) {
        datePicker.isHidden = true
    }
    
    
    
    @IBAction func valueChanged(_ sender: UIDatePicker) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/YYYY HH:mm"
        let result = dateFormatter.string(from: sender.date)
        
        if startDate.isFirstResponder {
            startDate.text = result
            startDateInt = Int(sender.date.timeIntervalSince1970.rounded())
        }
        if endDate.isFirstResponder {
            endDate.text = result
            endDateInt = Int(sender.date.timeIntervalSince1970.rounded())
        }
    }
    
    
    var selectedCompetition: String?;
    var competiton: Competition?;
    var selectedDiscipline = "none"
    


    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return missionData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "missionsCell")! //1.
        
        let tempMission = missionData[indexPath.row]
        
        cell.textLabel?.text = tempMission.title //3.
        cell.textLabel?.font = UIFont(name: "Avenir Next", size: 14)
        cell.textLabel?.textColor = UIColor.white
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        
        return cell //4.
    }
    
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
    
    //Picker formatting
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let view = UIView(frame: CGRect(x:0, y:0, width:400, height: 30))
        
        let topLabel = UILabel(frame: CGRect(x:0, y:0, width: 400, height: 14))
        topLabel.text = pickerData[row]
        topLabel.textColor = UIColor.white
        topLabel.textAlignment = .center
        topLabel.font = UIFont.systemFont(ofSize: 14)
        view.addSubview(topLabel)
        
        return view
    }
    
    //Check wich element has been choosen
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedDiscipline = pickerData[row]
        //load the data for missions
        if(row>0){
            loadMissionData(disciplineName: pickerData[row])
        }
    }
    
    func loadMissionData(disciplineName: String){
        FirebaseManager.getMisOfDisciplines(competitionName: self.selectedCompetition!, disciplineName: disciplineName) { (missionData) in
            self.missionData = Array(missionData)
            self.missionTableview.reloadData()
        }
    }
    
    func loadDisciplineData(){
        FirebaseManager.getDisciplinesOfCompetition(name: self.selectedCompetition!) { (pickerData) in
            self.pickerData = Array(pickerData)
            self.pickerData.insert("Please select", at: 0)
        }
    }
    
    func loadCompetition(){
        //diable the field
        titleCompetition.isEnabled = false
        startDate.isEnabled = false
        endDate.isEnabled = false
        refApi.isEnabled = false
        save.isEnabled = false
        
        //load the competion object in the fields
        FirebaseManager.getCompetiton(name: selectedCompetition! , completion: { (data) in
            self.competiton = data
            self.titleCompetition.text = self.competiton?.name
            let start: UnixTime = (self.competiton?.startDateTime)!
            self.startDate.text = start.toDateTime
            let end: UnixTime = (self.competiton?.endDateTime)!
            self.endDate.text = end.toDateTime
            self.refApi.text = self.competiton?.refAPI
        })
        
    }

    @IBAction func goBackManagement(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    //New competitions functions ---------------------------------------
    
    @IBAction func saveButton(_ sender: Any) {
        
        //UIAlert
        let alertBox = UIAlertController(
        title: "Input is wrong",
        message: "",
        preferredStyle: .actionSheet)
        
        alertBox.addAction(UIAlertAction(title:"Ok", style: .cancel, handler:nil))
        
        
        if(titleCompetition.text!.count < 5) || (titleCompetition.text ?? "").isEmpty{
            alertBox.message = "The title can contain text and/or numbers ";
            
            //Display the alertBox
            self.present(alertBox, animated: true);
            return;
        }
        

        if((isValidTexte(test: refApi.text!) == false)){
            alertBox.message = "refapi";
            
            //Display the alertBox
            self.present(alertBox, animated: true);
            return;
        }
        
        if(startDateInt>endDateInt){
            alertBox.message = "End date can't be before start date !";
            
            //Display the alertBox
            self.present(alertBox, animated: true);
            return;
        }
        
        
        insertCompetition()
        
    }
    
    func insertCompetition(){
        
        //create the object competition
        let newCompetition = Competition(name: titleCompetition.text ?? "Error", startDateTime: startDateInt, endDateTime: endDateInt, refAPI: refApi.text ?? "Error")
        
        //set the reference to the name of the new cometition
        let ref:DatabaseReference = Database.database().reference().child(FirebaseSession.competition.rawValue).child(newCompetition.name);
        
        //add the object
        ref.setValue(newCompetition.toAnyObject())
        self.save.isEnabled = false
    }
    
    func isValidTexte(test:String)-> Bool {
        let textRegEx = "[A-Z-a-z-0-9]{4,20}"
        
        let textTest = NSPredicate(format: "SELF MATCHES %@", textRegEx)
        return textTest.evaluate(with:test)
    }
    
    @IBAction func back(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)

    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
         print("------to display mission", indexPath.item)
        selectedMission = missionData[indexPath.item].title
        performSegue(withIdentifier: "toDisplayMission", sender: self)
       
    }
    
    @IBAction func addAction(_ sender: Any) {
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "toDisplayMission"){
        let destinationController = segue.destination as! MissionCreationViewController;
        destinationController.competitionChoose = self.titleCompetition.text!
        destinationController.missionChoose = selectedMission
        destinationController.disciplineChoose = selectedDiscipline
        }
    }
    
    
 
  
    
}
