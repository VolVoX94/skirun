//
//  TimeKeeperViewController.swift
//  skirun
//
//  Created by AISLAB on 01.04.19.
//  Copyright © 2019 hevs. All rights reserved.
//

import UIKit
import Firebase

class TimeKeeperViewController: UIViewController {

    
    
    @IBOutlet weak var textMission: UITextView!
    
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var numberField: UITextField!
    
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var resultField: UITextField!
    
    
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var dnfButton: UIButton!
    
    var unitResult: String = ""
    
    var currentCompetition: String!
    var currentDiscipline: String!
    var currentMission: String!
    var currentMissionObject: Mission!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        loadMission()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func submitAction(_ sender: Any) {
        
        let result = Result (number: numberField.text!, result: resultField.text!, unit:unitResult)
        addResult(result: result)
    }
    
    @IBAction func dnfAction(_ sender: Any) {
        let result = Result (number: numberField.text!,result: "Did not finish", unit:unitResult)
        addResult(result: result)
    }
    
    func loadTypeJob(typeJob: String){
        
        if(typeJob == "TimeKeeper - time"){
            self.resultLabel.text = "Distance"
            self.unitResult = "Min, sec"
        }
        
        if(typeJob == "TimeKeeper - distance"){
            self.resultLabel.text = "Distance"
            self.unitResult = "Meter"
        }
        
        if(typeJob == "TimeKeeper - vitesse"){
            self.resultLabel.text = "Vitesse"
            self.unitResult = "Km/h"
        }
        
        if(typeJob == "Logistics"){
            
            self.numberLabel.isHidden = true
            self.numberField.isHidden = true
            self.resultLabel.isHidden = true
            self.resultField.isHidden = true
            self.submitButton.isHidden = true
            self.dnfButton.isHidden = true
        }
    }
    
    func loadMission(){
        FirebaseManager.getMission(nameCompetition: currentCompetition, nameDiscipline: currentDiscipline, nameMission: currentMission) { (data) in
            self.currentMissionObject = data
            self.loadTypeJob(typeJob: self.currentMissionObject.jobs)
        }
    }
    
    func addResult(result: Result){
        
        let ref:DatabaseReference = Database.database().reference().child(FirebaseSession.competition.rawValue).child(currentCompetition).child(FirebaseSession.NODE_DISCIPLINES.rawValue).child(currentDiscipline).child(currentMission).child(FirebaseSession.MISSION_RESULT_BY_BIB.rawValue).child(result.number);
        
        ref.setValue(result.toAnyObject())
        
    }
    
    @IBAction func backAction(_ sender: Any) {
                dismiss(animated: true, completion: nil)
    }
    


}
