//
//  SecondViewController.swift
//  skirun
//
//  Created by AISLAB on 27.02.19.
//  Copyright © 2019 hevs. All rights reserved.

import Firebase
import UIKit

class SecondViewController: UIViewController , UIPickerViewDelegate, UIPickerViewDataSource,  UITableViewDataSource, UITableViewDelegate {
    
    // selected competition and discipline
    var selectedCompetition: String?
    var selectedDiscipline: String?
    var selectedMission: String?

    // TAG -> 0
    @IBOutlet weak var competitionPicker: UIPickerView!
    var listCompetitions:[String] = [String]()
    
    // TAG -> 1
    @IBOutlet weak var disciplinePicker: UIPickerView!
    var listDisciplines:[String] = []
    
    // list of missions
    var listMissions:[Mission] = []
   
    // get current user
    let currentUserUid = Auth.auth().currentUser?.uid
    
    // table view
    @IBOutlet weak var TableViewMission: UITableView!
    
    // semaphore : the value is the amount of threads we want
    let semaphore = DispatchSemaphore(value: 1)
    
    // dispatchQueue for semafore
    let dispatchQueue = DispatchQueue(label: "dispatchQueue")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Load the table view
        TableViewMission.dataSource = self
        TableViewMission.delegate = self
        
        // Call the compettions
        self.loadListCompetitions();
    
    }
    
    // ------------------------- table view and picker view  -------------------------
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if (pickerView.tag == 0){
            return "\(listCompetitions[row])"
        }else{
            return "\(listDisciplines[row])"
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listMissions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = TableViewMission.dequeueReusableCell(withIdentifier: "cellMissionSelected")!
        cell.textLabel?.textColor = UIColor.white
        let start: UnixTime = listMissions[indexPath.row].startTime
        let text = "\(listMissions[indexPath.row].title) \(" ") \(start.toDateTime)"//2.
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        cell.textLabel?.text = text //3.
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        selectedMission = listMissions[indexPath.item].title
        performSegue(withIdentifier: "toMission", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toMission" {
        let destinationController = segue.destination as! TimeKeeperViewController;
        destinationController.currentMission = self.selectedMission;
        destinationController.currentDiscipline = selectedDiscipline;
        destinationController.currentCompetition = selectedCompetition;
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1;
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if (pickerView.tag == 0){
            return listCompetitions.count
        }else{
            return listDisciplines.count
        }
    }
    
    //Check wich element has been choosen
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        // picker competitions
       if(pickerView.tag == 0){
            // if no competitions has been selected
            if (row==0){
                // remove all the lists to display nothing
                listDisciplines.removeAll()
                listMissions.removeAll()
                TableViewMission.reloadData()
                disciplinePicker.reloadAllComponents()
            }else{
               // get the selected competition
                self.selectedCompetition = self.listCompetitions[row]
                // Load the disciplines for the competition selected
                self.loadListDisciplines();
                // load the missions from the competition and the discipline selected
                self.loadListMissions();
            }
       
        }else{ // picker disciplines
        // get the selected discipline
        self.selectedDiscipline = self.listDisciplines[row]
        // load the missions
        self.loadListMissions();
        }
    }
    
    // load the list of all competitions
    func loadListCompetitions(){
       // call firebase
        FirebaseManager.getCompetitons(completion: { (data) in
            self.listCompetitions = Array(data)
            self.competitionPicker.delegate = self
            self.competitionPicker.dataSource = self
            // insert "please select" at first row
            self.listCompetitions.insert("Please select", at: 0)
        })
    }
    
    // load list of disciplines
    func loadListDisciplines(){
        DispatchQueue.global().async {
            self.semaphore.wait()
            self.listDisciplines = [String]()
            // call firebase
            FirebaseManager.getDisciplinesOfCompetition(name: self.selectedCompetition!) { (pickerData) in
                self.listDisciplines = Array(pickerData)
                self.disciplinePicker.delegate = self
                self.disciplinePicker.dataSource = self

                // check if the list of disciplines is more than 0
                if (self.listDisciplines.count>0){
                    self.selectedDiscipline = self.listDisciplines[0]
                    self.semaphore.signal()
                }
            }
        }
    }
    
    // load list of missions
    func loadListMissions(){
        //print("---- I'm in load list missions")
        DispatchQueue.global().async {
            self.semaphore.wait()
            // create the list for missions
            self.listMissions.removeAll()
            self.TableViewMission.dataSource = self
            // call firebase
            FirebaseManager.getMisOfDisciplines(competitionName: self.selectedCompetition!, disciplineName: self.selectedDiscipline!){ (missionData) in
                // display all the missions for the selected discipline
                for (_, elementMission) in missionData.enumerated(){
                    // loop in all the selected user in the mission
                    for (_, elementSelected) in elementMission.selected.enumerated(){
                        
                        // if the current user id is the same as the user selected for the mission
                        if (self.currentUserUid == elementSelected){
                           // add this mission to the list of missions for this current user
                            self.listMissions.append(elementMission)
                        }
                    }
                }
                // reload the data
                self.TableViewMission.reloadData()
                self.semaphore.signal()
            }
        }
    }

 
    //Picker formatting
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        if (pickerView.tag == 0){
            let view = UIView(frame: CGRect(x:0, y:0, width:400, height: 30))
            
            let topLabel = UILabel(frame: CGRect(x:0, y:0, width: 400, height: 14))
            topLabel.text = listCompetitions[row]
            topLabel.textColor = UIColor.white
            topLabel.textAlignment = .center
            topLabel.font = UIFont.systemFont(ofSize: 14)
            view.addSubview(topLabel)
            
            return view
            
        }else{
            let view = UIView(frame: CGRect(x:0, y:0, width:400, height: 30))
            
            let topLabel = UILabel(frame: CGRect(x:0, y:0, width: 400, height: 14))
            topLabel.text = listDisciplines[row]
            topLabel.textColor = UIColor.white
            topLabel.textAlignment = .center
            topLabel.font = UIFont.systemFont(ofSize: 14)
            view.addSubview(topLabel)
            
            return view
        }
    }
}
