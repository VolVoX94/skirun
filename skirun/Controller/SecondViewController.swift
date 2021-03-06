//
//  SecondViewController.swift
//  skirun
//
//  Created by AISLAB on 27.02.19.
//  Copyright © 2019 hevs. All rights reserved.

import Firebase
import UIKit

// Get all the missions where the current user has been selected by the admin
// according the selected competition and the selected discpline
class SecondViewController: UIViewController , UIPickerViewDelegate, UIPickerViewDataSource,  UITableViewDataSource, UITableViewDelegate {
    
    // selected competition and discipline
    var selectedCompetition: String?
    var selectedDiscipline: String?
    var selectedMission: String?
    var selectedMissionJob: String?
    var cellFontSize:CGFloat?

    private var myUser:User?
    //Constraints used for small devices
    @IBOutlet weak var Select_Title_Gap: NSLayoutConstraint!
    @IBOutlet weak var firstPickerHeight: NSLayoutConstraint!
    @IBOutlet weak var secondPickerHeight: NSLayoutConstraint!
    @IBOutlet weak var tableHeight: NSLayoutConstraint!
    
    @IBOutlet weak var myMissionTitle: UILabel!
    
    @IBOutlet weak var selMisLabel: UILabel!
    @IBOutlet weak var selChamLabel: UILabel!
    // View Indicator while waiting data
    @IBOutlet weak var myWaitSymbolizer: UIActivityIndicatorView!
    
    // In case if there are no data
    @IBOutlet weak var noDataLabel: UILabel!
    
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
    
    @IBOutlet weak var MyAdminButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.cellFontSize = 20
        checkDeviceSize()
        self.MyAdminButton.isHidden = true
        self.loadCurrentUser()
        // Load the table view
        TableViewMission.dataSource = self
        TableViewMission.delegate = self
        // set the label for no data input to ""
        self.noDataLabel.text = ""
        
        //Important for small device like iPhone SE
        
        // Call the compettions
        do {
            let printComp = try self.loadListCompetitions();
            print(printComp)
        } catch {
            print(error)
        }
    }
    
    func checkDeviceSize(){
        let screenSize: CGRect = UIScreen.main.bounds
        let screenHeight = screenSize.height
        let factor = screenHeight/568
        if(factor < 1.2){
            self.cellFontSize = 15
            self.Select_Title_Gap.constant = 15
            self.firstPickerHeight.constant = 60
            self.secondPickerHeight.constant = 60
            self.tableHeight.constant = 150
            self.myMissionTitle.font = UIFont(name: "AvenirNext-Bold", size: 20)
            self.selMisLabel.font = UIFont(name: "AvenirNext-MediumItalic", size: 15)
            self.selChamLabel.font = UIFont(name: "AvenirNext-MediumItalic", size: 15)
        }
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
        do{
           
            cell.textLabel?.textColor = UIColor.white
            let start: UnixTime = listMissions[indexPath.row].startTime
            let text = "\(listMissions[indexPath.row].title) \(" ") \(start.toDateTime)"//2.
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
            cell.textLabel?.text = text //3.
            cell.textLabel?.font = UIFont(name: "Avenir Next Medium", size: self.cellFontSize!)
            cell.textLabel?.textColor = UIColor.white
      
        } catch let error as NSError{
            print(error.localizedDescription)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        selectedMission = listMissions[indexPath.item].title
        selectedMissionJob = listMissions[indexPath.item].jobs
        if selectedMissionJob!.contains("keeper"){
            performSegue(withIdentifier: "toMission", sender: self)
        } else if selectedMissionJob!.contains("ontroller") {
            performSegue(withIdentifier: "toMissionController", sender: self)
        } else {
            performSegue(withIdentifier: "toMission", sender: self)
           // performSegue(withIdentifier: "toMissionLogistics", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toMission"{
            let destinationController = segue.destination as! TimeKeeperViewController;
            destinationController.currentMission = self.selectedMission
            destinationController.currentDiscipline = self.selectedDiscipline
            destinationController.currentCompetition = self.selectedCompetition
        } else if segue.identifier == "toMissionController" {
            let destinationController = segue.destination as! VideoViewController
            destinationController.currentMission = self.selectedMission ?? "NULL"
            destinationController.currentDiscipline = selectedDiscipline ?? "NULL"
            destinationController.currentCompetition = selectedCompetition ?? "NULL"
        }/* else if segue.identifier == "toMissionLogistics" {
            let destinationController = segue.destination as! VideoViewController;
            destinationController.currentMission = self.selectedMission;
            destinationController.currentDiscipline = selectedDiscipline;
            destinationController.currentCompetition = selectedCompetition
        }*/

    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1;
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        pickerView.subviews.forEach({
            $0.isHidden = $0.frame.height < 1.0
        })
        if (pickerView.tag == 0){
            return listCompetitions.count
        }else{
            return listDisciplines.count
        }
    }
     // ------------------------- END  -------------------------
    
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
                //launch animating loading sign
                self.myWaitSymbolizer.startAnimating()
               // get the selected competition
                self.selectedCompetition = self.listCompetitions[row]
                //refresh
                self.listMissions.removeAll()
                self.TableViewMission.reloadData()
                // load the missions from the competition and the discipline selected
                do {
                    let printDisc = try self.loadListDisciplines();
                    print(printDisc)
                } catch {
                    print(error)
                }
               
            }
        }
       // picker disciplines
       else{
        // get the selected discipline
        self.selectedDiscipline = self.listDisciplines[row]
        // load the missions
        do {
            let printDisc = try self.loadListMissions();
            print(printDisc)
        } catch {
            print(error)
        }
        
        }
    }
    
    // load the list of all competitions
    func loadListCompetitions() throws{
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
    func loadListDisciplines() throws {
       
        self.listDisciplines = [String]()
        // call firebase
        FirebaseManager.getDisciplinesOfCompetition(name: self.selectedCompetition!) { (pickerData) in
            // remove the conent of the list of missions
            self.listMissions.removeAll()
            
            self.listDisciplines = Array(pickerData)
            self.disciplinePicker.delegate = self
            self.disciplinePicker.dataSource = self

            // check if the list of disciplines is more than 0
            if (self.listDisciplines.count>0){
                self.selectedDiscipline = self.listDisciplines[0]
                // Load the missions
                do {
                    let printDisc = try self.loadListMissions();
                    print(printDisc)
                } catch {
                    print(error)
                }
                // set label of no data to ""
                self.noDataLabel.text = ""
            }
            else{
                // if no disciplines set label data
                self.noDataLabel.text = "There is no disciplines"
                self.myWaitSymbolizer.stopAnimating()
            }
        }
    }
    
    // load list of missions
    func loadListMissions() throws{
        
        //refresh
        self.listMissions.removeAll()
        self.TableViewMission.reloadData()
        // create the list for missions
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
            // if there is no missions for the current user, set the label no data
            if(self.listMissions.count == 0){
                self.noDataLabel.text = "You don't have any missions"
            }
            // if there is some mission, set label noData to ""
            else{
                self.noDataLabel.text = ""
            }
            self.myWaitSymbolizer.stopAnimating()
            // reload the data
            self.TableViewMission.reloadData()
        }
    }
    
    func loadCurrentUser(){
        let uid = Auth.auth().currentUser?.uid
        FirebaseManager.getUserByUID(uidUser: uid!) { (User) in
            self.myUser = User
            print(self.myUser?.admin)
            if(self.myUser!.admin == true){
                self.MyAdminButton.isHidden = false
            }
        }
    }

    //Picker formatting
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        if (pickerView.tag == 0){
            let view = UIView(frame: CGRect(x:0, y:0, width:400, height: self.cellFontSize!+5))
            
            let topLabel = UILabel(frame: CGRect(x:0, y:0, width: 400, height: self.cellFontSize!+5))
            topLabel.text = listCompetitions[row]
            topLabel.textColor = UIColor.white
            topLabel.textAlignment = .center
            topLabel.font = UIFont(name: "Avenir Next Medium", size: self.cellFontSize!)
            view.addSubview(topLabel)
            
            return view
            
        }else{
            let view = UIView(frame: CGRect(x:0, y:0, width:400, height: self.cellFontSize!+5))
            
            let topLabel = UILabel(frame: CGRect(x:0, y:0, width: 400, height: self.cellFontSize!+5))
            topLabel.text = listDisciplines[row]
            topLabel.textColor = UIColor.white
            topLabel.textAlignment = .center
            topLabel.font = UIFont(name: "Avenir Next Medium", size: self.cellFontSize!)
            view.addSubview(topLabel)
            
            return view
        }
    }
}
