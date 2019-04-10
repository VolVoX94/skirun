//
//  RolesViewController.swift
//  skirun
//
//  Created by Jaufray on 08/04/2019.
//  Copyright © 2019 hevs. All rights reserved.
//

import Firebase
import UIKit

class RolesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    // table view
    @IBOutlet weak var tableViewRoles: UITableView!
    
    // list of all the job preferences
    private var listJobType:[String] = [String]()
   
    // get the current row selected from the user in the table view
    private var selectedRoleRow:Int?
    
    // get the current job preference
    private var currentJobPreference:String?
    
    // get current user
    let currentUserUid = Auth.auth().currentUser?.uid
    
    // Wait symbolizer
    @IBOutlet weak var RolesWaitSymbolizer: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableViewRoles.dataSource = self
        tableViewRoles.delegate = self
        RolesWaitSymbolizer.startAnimating()
        // load the job preferences from the current user
        self.loadJobPreferenceByUser()
        // load the list of job preferences
        self.loadListTypeOfJobs()
    }
    
    // button back
    @IBAction func backButton(_ sender: Any) {
        dismiss(animated: false, completion: nil)
    }
    
    // length of the table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.listJobType.count
    }
    
    // create radio button and cell for each radio button
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = self.tableViewRoles.dequeueReusableCell(withIdentifier: "cellRoles")! //1.
       
        // create the text for the current row
        let text = self.listJobType[indexPath.row]//2.
        cell.textLabel?.textColor = UIColor.white
        // set the label with the text
        cell.textLabel?.text = text //3.
        cell.textLabel?.font = UIFont(name: "Avenir Next", size: 18)
        
       
        // Create the radiobutton
         let button = KGRadioButton(frame: CGRect(x:20, y:170, width: 30, height: 30))
         button.addTarget(self, action: #selector(manualAction(sender:)), for: .touchUpInside)
         button.tag = indexPath.row
         button.innerCircleCircleColor = UIColor.white
         button.outerCircleColor = UIColor.white
         cell.accessoryView = button
        
        // if the selectedRole by the user is the same as the current row of th cell
        // set it to true
        if (self.selectedRoleRow == indexPath.row){
            // set the currentjobpreference with the text of the cell
            self.currentJobPreference = text
            // set the button to true
            button.isSelected = true
            // save the job in the user in firebase
            saveJobPreferenceChoosen()
        }
        else {
            // set all others button to false
            button.isSelected = false
        }
        
        // for the first load of the page
        // if current job of the user is the same as the text, and the selected row is null
        if(self.currentJobPreference == text && self.selectedRoleRow == nil){
            // set the button to true
            button.isSelected = true
        }
      
        // return cell
        return cell //4.
    }
    
    // when the user click on the table view
    @objc func manualAction (sender: KGRadioButton){
        print("click")
        // get the selected row
        self.selectedRoleRow = sender.tag
        // reload the data in the table
        self.tableViewRoles.reloadData()
    }
  
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableViewRoles.cellForRow(at: indexPath)?.accessoryType = .checkmark
        let cell:UITableViewCell = tableViewRoles.cellForRow(at: indexPath)!
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableViewRoles.cellForRow(at: indexPath)?.accessoryType = .none
    }
    
   // ------ FIREBASE
    
    // load all the lists of the jobs
    func loadListTypeOfJobs(){
        // remove all data
        self.listJobType.removeAll()
       
        // call firebase method getjobs
        FirebaseManager.getJobs(completion: { (data) in
            self.listJobType = Array(data)
            self.tableViewRoles.reloadData()
            // if the list is not empty, stop the wait symbolizer
            if (self.listJobType.count > 0){
                self.RolesWaitSymbolizer.stopAnimating()
            }
        })
    }
    
    // load the job preference for the current user
    func loadJobPreferenceByUser(){
        // call firebase method getjobsfromuser
        FirebaseManager.getJobsFromUser(uidUser: (Auth.auth().currentUser?.uid)!) { (data) in
            // if the current job doesn't exist set it to ""
            if (self.currentJobPreference == nil){
                self.currentJobPreference = ""
            }
            // set the current job with the data
            self.currentJobPreference = data
        }
        
    }
    
    // save the job choosen by the user in the firebase
    func saveJobPreferenceChoosen(){
        // call firebase method and save job preference in the current user
        FirebaseManager.saveJobPreferenceInUser(uidUser: (Auth.auth().currentUser?.uid)!, newJobPreference: self.currentJobPreference!)
    }
    
}
