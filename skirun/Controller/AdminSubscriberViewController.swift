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
    private var alreadySelected:String?
    private var competitionName:String?
    private var disciplineName:String?
    private var missionName:String?
    private var mySemaphore:DispatchSemaphore?
    
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
        
        
        self.competitionName = "Concours Crans-Montana - 2019"
        self.disciplineName = "Cross-country skiing"
        self.missionName = "mission10"
        
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
            
            
            FirebaseManager.saveFinalSubscriberToMission(uidUser: self.data[self.selectedUser!], allUidOfUsers: self.data, nameMission: self.missionName!, nameDiscipline: self.disciplineName!, nameCompetition: self.competitionName!)
            self.dismiss(animated: true, completion: nil)
        }))
        alertBox.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler:{(action: UIAlertAction!) in
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
        
        let button = KGRadioButton(frame: CGRect(x:20, y:170, width: 30, height: 30))
        button.addTarget(self, action: #selector(manualAction(sender:)), for: .touchUpInside)
        button.tag = indexPath.row
        button.innerCircleCircleColor = UIColor.white
        button.outerCircleColor = UIColor.white
        cell.accessoryView = button
        if(selectedUser == button.tag){
            button.isSelected = true
        }
        
        if(self.alreadySelected == data[indexPath.row]){
            let label = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 21))
            
            label.textAlignment = .right
            label.textColor = UIColor.white
            label.font = UIFont(name: "Avenir Next", size: 15)
            label.text = "Current"
            label.font = UIFont.boldSystemFont(ofSize: label.font.pointSize)
            cell.accessoryView = label
        }
        
        return cell //4.

    }
    
    @objc func manualAction (sender: KGRadioButton){
        selectedUser = sender.tag
        self.tableView.reloadData()
    }
    
    // --------- FIREBASE
    
    func loadUserUID(){
        //DispatchQueue.global().async {
        //  self.mySemaphore?.wait()

            FirebaseManager.getSubscriberOfMission(competitionName: "Concours Crans-Montana - 2019", disciplineName: "Cross-country skiing", nameMission: "mission10") { (data, ref) in
                //let test = ref
                self.data = Array(data)
                self.loadUserDataByUID()
               // self.mySemaphore?.signal()
           // }
        }
    }
    
    func loadUserDataByUID(){
      //  DispatchQueue.global().async {
       //     self.mySemaphore?.wait()
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
                    //    self.mySemaphore?.signal()
                 //   }
                }
            }
        }
    }
    
    func loadSelectedUser(){
      //  DispatchQueue.global().async {
        //    self.mySemaphore?.wait()
            for item in self.data{
                FirebaseManager.checkAlreadySelected(uidUser: item, nameMission: self.missionName!, nameDiscipline: self.disciplineName!, nameCompetition: self.competitionName!) { (selectedUID) in
                    if(selectedUID != nil){
                        self.alreadySelected = selectedUID
                    }
                    if (item == self.data.last){
                        self.tableView.reloadData()
                        
                        
                      //  self.mySemaphore?.signal()
                        
            //        }
                }
            }
        }
    }
}
