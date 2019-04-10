//
//  AdminSubscriberViewController.swift
//  skirun
//
//  Created by Admin on 02.04.19.
//  Copyright © 2019 hevs. All rights reserved.
//

import UIKit

class AdminSubscriberViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    private var data:[String] = []
    private var dataUser:[User] = []
    private var tempUser:User?
    private var selectedUser:Int?
    private var alreadySelected:[String] = []
    public var competitionName:String?
    public var disciplineName:String?
    public var missionName:String?
    private var mySemaphore:DispatchSemaphore?
    private var choosenSubscriber:[Int] = []
    private var notChoosenMissions:[Int] = []
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var saveButton: UIButton!
    
    @IBOutlet weak var competitionLabel: UILabel!
    
    @IBOutlet weak var missionLabel: UILabel!
    
    @IBOutlet weak var noDataLabel: UILabel!
    
    @IBOutlet weak var disciplineLabel: UILabel!
    
    @IBOutlet weak var myWaitSymbolizer: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mySemaphore = DispatchSemaphore(value: 1)
        self.tableView.dataSource = self
        self.tableView.delegate = self
        myWaitSymbolizer.startAnimating()
        
        loadUserUID()
        
        //Label will be written
        self.competitionLabel.text = competitionName
        self.missionLabel.text = missionName
        self.disciplineLabel.text = disciplineName
    }
    
    @IBAction func myBackButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func saveButtonFunc(_ sender: Any) {
        let alertBox = UIAlertController(
            title: "Save Subscriber",
            message: "Do you want to save your choice?",
            preferredStyle: .actionSheet);
        
        alertBox.addAction(UIAlertAction(title: "Yes", style: .default, handler:{ (action: UIAlertAction!) in
            var tempUID = [String]()
            for item in self.choosenSubscriber{
                tempUID.append(self.data[item])
            }
            
            FirebaseManager.saveFinalSubscribersToMission(uidUsers: tempUID, nameMission: self.missionName!, nameDiscipline: self.disciplineName!, nameCompetition: self.competitionName!)
            self.dismiss(animated: true, completion: nil)
        }))
        alertBox.addAction(UIAlertAction(title: "No", style: .cancel, handler:{(action: UIAlertAction!) in
        }))
        self.present(alertBox, animated: true)
    }
    
    @IBAction func didPressButton(_ sender: KGRadioButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected{
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        let cell:UITableViewCell = tableView.cellForRow(at: indexPath)!
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
        tableView.cellForRow(at: indexPath)?.accessoryType = .none
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "cellCompetition")! //1.
            if(data.count == dataUser.count){
                let text = self.dataUser[indexPath.row].firstName//2.
                cell.textLabel?.text = text //3.
            }
        
        
        
            cell.textLabel?.font = UIFont(name: "Avenir Next", size: 18)
            cell.textLabel?.textColor = UIColor.white
        
        if(cell.textLabel?.text != "NULL"){
            
            let switchObj = UISwitch(frame: CGRect(x: 1, y: 1, width: 20, height: 20))
            //EXCEPTION - CATCH NULLPOINTER
            do{
                
                let tempData = self.alreadySelected//2.
                let currentData = try assignData(data: self.data, index: indexPath.row)
                if(tempData.contains(currentData)){
                    switchObj.isOn = true
                    choosenSubscriber.append(indexPath.row)
                }
                else{
                    switchObj.isOn = false;
                }
            } catch let error as NSError{
                switchObj.isOn = false;
                print(error.localizedDescription)
            }
            
            switchObj.addTarget(self, action: #selector(toggel(_:name:)), for: .valueChanged)
            switchObj.tag = indexPath.row
            cell.accessoryView = switchObj
        }
        else{
            let switchObj = UISwitch(frame: CGRect(x: 1, y: 1, width: 20, height: 20))
            switchObj.isHidden = true
            cell.accessoryView = switchObj
        }
        return cell //4.

    }
    
    @objc func toggel(_ sender:UISwitch, name:String){
        
        if(sender.isOn){
            //ADD element
            choosenSubscriber.append(sender.tag);
            notChoosenMissions = notChoosenMissions.filter{$0 != sender.tag}
        }
        else{
            //DELETE element
            choosenSubscriber = choosenSubscriber.filter{$0 != sender.tag}
            notChoosenMissions.append(sender.tag)
        }
    }
    
    /*@objc func manualAction (sender: KGRadioButton){
        selectedUser = sender.tag
        self.tableView.reloadData()
    }*/
    
    // --------- EXCEPTION HANDLING
    //ERROR - HANDLING
    func assignData(data:[String], index:Int) throws -> String{
        return data[index]
    }
    
    // --------- FIREBASE
    
    func loadUserUID(){
        //DispatchQueue.global().async {
        //  self.mySemaphore?.wait()

        
        FirebaseManager.getSubscriberOfMission(competitionName: self.competitionName!, disciplineName: self.disciplineName!, nameMission: self.missionName!) { (data, ref) in
                //let test = ref
                self.data = Array(data)
                self.loadUserDataByUID()
               // self.mySemaphore?.signal()
           // }
        }
    }
    
    func loadUserDataByUID(){


        
            if(self.data.count == 0){
                self.myWaitSymbolizer.stopAnimating()
                self.noDataLabel.text = "No subscriber"
            }
            else{
               self.noDataLabel.text = ""
            }
            for item in self.data{
                
                FirebaseManager.getUserByUID(uidUser: item) { (userData) in
                    self.dataUser.append(userData)
                    
                    if (item == self.data.last){
                        self.loadSelectedUser()
                        self.myWaitSymbolizer.stopAnimating()
                    }
                }
        }
    }
    
    func loadSelectedUser(){
        FirebaseManager.checkAlreadySelectedUsers(nameMission: self.missionName!, nameDiscipline: self.disciplineName!, nameCompetition: self.competitionName!) { (selectedUID) in
            if(selectedUID != nil){
                self.alreadySelected = Array(selectedUID)
            }
            self.tableView.reloadData()
        }
    }
}
