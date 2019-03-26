//
//  DetailAvailability.swift
//  skirun
//
//  Created by Admin on 25.03.19.
//  Copyright © 2019 hevs. All rights reserved.
//

import UIKit

class DetailAvailability: UIViewController, UITableViewDataSource, UITableViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource{
        
    private var data:[Competition] = []
    var name:String?
    var date:String?
    var myCompetition:Competition?
    var pickerData: [String] = [String]()
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var myCompetitionName: UILabel!
    
    @IBOutlet weak var myStartDateLabel: UILabel!
        
    @IBOutlet weak var myPicker: UIPickerView!
    
    override func viewDidLoad() {
            super.viewDidLoad()
            tableView.dataSource = self
            
            loadCompetition(selectedCompetition: self.name!)
            self.myCompetitionName.text = self.name
            self.myStartDateLabel.text = self.name
        
            self.myPicker.delegate = self
            self.myPicker.dataSource = self
            pickerData = ["test", "banane", "affji"]
        }
    
    //Picker methods
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1;
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 30
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let view = UIView(frame: CGRect(x:0, y:0, width:100, height: 30))
        
        let topLabel = UILabel(frame: CGRect(x:0, y:0, width: 100, height: 25))
        topLabel.text = pickerData[row]
        topLabel.textColor = UIColor.white
        topLabel.textAlignment = .center
        topLabel.font = UIFont.systemFont(ofSize: 25)
        view.addSubview(topLabel)
        
        return view
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
