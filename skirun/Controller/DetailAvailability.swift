//
//  DetailAvailability.swift
//  skirun
//
//  Created by Admin on 25.03.19.
//  Copyright © 2019 hevs. All rights reserved.
//

import UIKit

class DetailAvailability: UIViewController, UITableViewDataSource, UITableViewDelegate{
        
    private var data:[Competition] = []
    var name:String?
    var date:String?
    var myCompetition:Competition?
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var myCompetitionName: UILabel!
    
    @IBOutlet weak var myStartDateLabel: UILabel!
        
        override func viewDidLoad() {
            super.viewDidLoad()
            tableView.dataSource = self
            
            loadCompetition(selectedCompetition: self.name!)
            self.myCompetitionName.text = self.name
            self.myStartDateLabel.text = self.name
        }
    
    func loadCompetition(selectedCompetition: String){
            FirebaseManager.getCompetiton(name: selectedCompetition , completion: { (data) in
                self.myCompetition = data
                self.myStartDateLabel.text = data.startDateTime.description
            })
    }
    
    @IBAction func submitButton(_ sender: Any) {
        
        //Define a general UIAlert
        let alertBox = UIAlertController(
            title: "No role choosen",
            message: "",
            preferredStyle: .actionSheet);
        
        alertBox.addAction(UIAlertAction(title: "Ok", style: .cancel, handler:nil))
        
        
        //Check if email is correct
        //Will call the regex pattern method!
        //if((isValidName(testStr: fnameField.text!) == false)){
            
            //Define that something is wrong
            alertBox.message = "You have to select a mission";
            
            //Display the alertBox
            self.present(alertBox, animated: true);
        }
    
    
    
    @IBAction func nextButton(_ sender: Any) {
            performSegue(withIdentifier: "MyNextSegue", sender: self)
        }
        @IBAction func backButton(_ sender: Any) {
            self.dismiss(animated: true, completion: nil)
        }
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return data.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cellCompetition")! //1.
            
            let text = data[indexPath.row].name //2.
            
            cell.textLabel?.text = text //3.
            cell.textLabel?.text = text //3.
            cell.textLabel?.font = UIFont(name: "Avenir Next", size: 18)
            cell.textLabel?.textColor = UIColor.white
            
            return cell //4.
        }
}
