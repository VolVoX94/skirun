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
    public var competitionName:String?
    public var disciplineName:String?
    public var missionName:String?
    public var mySemaphore:DispatchSemaphore?
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var saveButton: UIButton!
    
    @IBOutlet weak var competitionLabel: UILabel!
    
    @IBOutlet weak var missionLabel: UILabel!
    
    @IBOutlet weak var disciplineLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mySemaphore = DispatchSemaphore(value: 1)
        self.tableView.dataSource = self
        self.tableView.delegate = self
        loadUserUID()
        loadUserDataByUID()
        
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
        print("save pressed")
        let alertBox = UIAlertController(
            title: "Save Subscriber",
            message: "Do you want to save your choice?",
            preferredStyle: .actionSheet);
        
        alertBox.addAction(UIAlertAction(title: "Yes", style: .default, handler:{ (action: UIAlertAction!) in
            
            print("saved")
        }))
        alertBox.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler:{(action: UIAlertAction!) in
            print("canceled")
        }))
        self.present(alertBox, animated: true)
    }
    
    @IBAction func didPressButton(_ sender: KGRadioButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected{
            print("Selected")
        }
        else{
            print("not selected")
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        var cell:UITableViewCell = tableView.cellForRow(at: indexPath)!
        cell.contentView.backgroundColor = UIColor(red:0.00, green:0.15, blue:0.29, alpha:1.0)
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.accessoryType = .none
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "cellCompetition")! //1.
        //var text = ""
       // cell.textLabel?.text = text //3.
        
        /*DispatchQueue.global().async {
            self.mySemaphore?.wait()*/
            print("TABLE VIEW-----")
            print(data.count, dataUser.count)
            if(data.count == dataUser.count){
                var text = self.dataUser[indexPath.row].firstName//2.
                cell.textLabel?.text = text //3.
            }
        
        
            cell.textLabel?.font = UIFont(name: "Avenir Next", size: 18)
            cell.textLabel?.textColor = UIColor.white
            
           // self.mySemaphore?.signal()
        //}
        
        return cell //4.

    }
    
    // --------- FIREBASE
    
    func loadUserUID(){
        DispatchQueue.global().async {
            self.mySemaphore?.wait()
            print("LoadUserUID")

            FirebaseManager.getSubscriberOfMission(competitionName: "Concours Crans-Montana - 2019", disciplineName: "Cross-country skiing", nameMission: "mission10") { (data, ref) in
                //let test = ref
                self.data = Array(data)
                self.mySemaphore?.signal()
                print("LoadUserUID-FINISH")
            }
        }
    }
    
    func loadUserDataByUID(){
        DispatchQueue.global().async {
            self.mySemaphore?.wait()
            print("LoadUserDataByUID")
            print(self.data.count)
            for item in self.data{
                
                FirebaseManager.getUserByUID(uidUser: item) { (userData) in
                    self.dataUser.append(userData)
                    print(userData.firstName)
                    
                    if (item == self.data.last){
                        print("START RELOADING DATA")
                        self.tableView.reloadData()
                        self.mySemaphore?.signal()
                        print("LoadUserDataByUID - FINISH")
                    }
                }
            }
        }
    }
}
