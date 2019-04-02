//
//  SecondViewController.swift
//  skirun
//
//  Created by AISLAB on 27.02.19.
//  Copyright © 2019 hevs. All rights reserved.




import UIKit

class SecondViewController: UIViewController , UIPickerViewDelegate, UIPickerViewDataSource {
    
    var selectedCompetition: String?
    var selectedDiscipline: String?

    // TAG -> 0
    @IBOutlet weak var competitionPicker: UIPickerView!
    var listCompetitions:[String] = [String]()
    
    // TAG -> 1
    @IBOutlet weak var disciplinePicker: UIPickerView!
    var listDisciplines:[String] = [String]()
    
    var listMissions:[Mission] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadListCompetitions();
      
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if (pickerView.tag == 0){
            return "\(listCompetitions[row])"
        }else{
            return "\(listDisciplines[row])"
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
            self.listCompetitions.insert("Please select", at: 0)
            // print(data)
        })
      
    }
    
    func loadListDisciplines(){
       
        FirebaseManager.getDisciplinesOfCompetition(name: self.selectedCompetition!) { (pickerData) in
            self.listDisciplines = Array(pickerData)
            self.disciplinePicker.delegate = self
            self.disciplinePicker.dataSource = self
            // when select a competition -> load discipline and set the first discipline in the list
            self.disciplinePicker.selectedRow(inComponent: 0)
            
        }
        
    }
    
    func loadListMissions(){
        print("---- I'm in load list missions")
        
        // remove all missions in the list
        self.listMissions.removeAll()
        
        print("size of list missions ", listMissions.count)
        
        FirebaseManager.getMisOfDisciplines(competitionName: self.selectedCompetition!, disciplineName: self.selectedDiscipline!){ (missionData) in
            self.listMissions = Array(missionData)
            
            print("list of missions for this comp and dis ")
            
            // display for the discipline selected the names of the missions
            for (index, element) in self.listMissions.enumerated(){
                print(index, ": ", element.title)
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

