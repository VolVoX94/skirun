//
//  SecondViewController.swift
//  skirun
//
//  Created by AISLAB on 27.02.19.
//  Copyright © 2019 hevs. All rights reserved.



import Firebase
import UIKit

class SecondViewController: UIViewController , UIPickerViewDelegate, UIPickerViewDataSource,  UITableViewDataSource, UITableViewDelegate {
    
    
    var selectedCompetition: String?
    var selectedDiscipline: String?

    // TAG -> 0
    @IBOutlet weak var competitionPicker: UIPickerView!
    var listCompetitions:[String] = [String]()
    
    // TAG -> 1
    @IBOutlet weak var disciplinePicker: UIPickerView!
    var listDisciplines:[String] = [String]()
    
    var listMissions:[Mission] = []
   
    // get current user
    let currentUserUid = Auth.auth().currentUser?.uid
    
    // table view
    @IBOutlet weak var TableViewMission: UITableView!
    
    // selected competition
    var selectedMission: String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        TableViewMission.dataSource = self
        TableViewMission.delegate = self
        loadListCompetitions();
      
        
    }
    
    
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
        let text = listMissions[indexPath.row].title //2.
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
        
        let destinationController = segue.destination as! TimeKeeperViewController;
        destinationController.currentMission = selectedMission;
        destinationController.currentDiscipline = selectedDiscipline;
        destinationController.currentCompetition = selectedCompetition;
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
        
       if(pickerView.tag == 0){
            self.selectedCompetition = listCompetitions[row]
              loadListDisciplines();
            
        }else{
            self.selectedDiscipline = listDisciplines[row]
            loadListMissions();
        }
        
    }
    
    func loadListCompetitions(){
        FirebaseManager.getCompetitons(completion: { (data) in
            self.listCompetitions = Array(data)
            self.competitionPicker.delegate = self
            self.competitionPicker.dataSource = self
            // self.listCompetitions.insert("Please select", at: 0)
            // print(data)
        })
      
    }
    
    func loadListDisciplines(){
       print("loadDisciplines")
        FirebaseManager.getDisciplinesOfCompetition(name: self.selectedCompetition!) { (pickerData) in
            self.listDisciplines = Array(pickerData)
            self.disciplinePicker.delegate = self
            self.disciplinePicker.dataSource = self
            // when select a competition -> load discipline and set the first discipline in the list
            //self.disciplinePicker.selectedRow(inComponent: 0)
            
            if(self.listDisciplines.count>0){
                self.selectedDiscipline = self.listDisciplines[0]
               //self.loadListMissions();
            }
            
           /* if (self.listDisciplines.isEmpty) {
                self.disciplinePicker.isHidden = false
            }else{
                self.disciplinePicker.isHidden = true
            }
 */
        }
        
    }
    
    func loadListMissions(){
        //print("---- I'm in load list missions")
        
        // create the list for missions
        self.listMissions = [Mission]()
        self.TableViewMission.dataSource = self
        //print("size of list missions ", listMissions.count)
        
        FirebaseManager.getMisOfDisciplines(competitionName: self.selectedCompetition!, disciplineName: self.selectedDiscipline!){ (missionData) in
          
            
            print("list of missions for : ", self.selectedCompetition)
            
            // display for the discipline selected the names of the missions
            for (index, elementMission) in missionData.enumerated(){
                //print("------------ ", elementMission.title)
                
                //print("element selected", elementMission.selected)
                
                for (_, elementSelected) in elementMission.selected.enumerated(){
                    
                    // var listSelected = [String]()
                    
                    if (self.currentUserUid == elementSelected){
                        // print("current id", self.currentUserUid)
                        // print ("uid selected ", elementSelected)
                        print(elementMission.title)
                        self.listMissions.append(elementMission)
                        //print(self.listMissions)
                        
                    }
                    
                }
             }
            
            print("***** list ****", self.listMissions)
            self.TableViewMission.reloadData()
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

