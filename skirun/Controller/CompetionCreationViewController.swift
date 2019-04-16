//
//  CompetionCreationViewController.swift
//  skirun
//
//  Created by iOS Dev on 13.03.19.
//  Copyright © 2019 hevs. All rights reserved.
//

import UIKit
import Firebase

class CompetionCreationViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource , UITableViewDataSource, UITableViewDelegate {

    
    //Constraints
    //Between input fields
    @IBOutlet weak var EnterTitleToStart_Gap: NSLayoutConstraint!
    @IBOutlet weak var StartDateToEndDate_Gap: NSLayoutConstraint!
    @IBOutlet weak var EndDateToRefAPI_Gap: NSLayoutConstraint!
    
    @IBOutlet weak var MissionTop_Gap: NSLayoutConstraint!
    //Picker
    @IBOutlet weak var HeightPicker: NSLayoutConstraint!
    
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var titleCompetition: UITextField!
    @IBOutlet weak var endDate: UITextField!
    @IBOutlet weak var refApi: UITextField!
    @IBOutlet weak var save: UIBarButtonItem!
    @IBOutlet weak var startDate: UITextField!
    @IBOutlet weak var addButton: UIButton!
    
    @IBOutlet weak var misLabel: UILabel!
    @IBOutlet weak var missionTableview: UITableView!
    @IBOutlet weak var disciplinePicker: UIPickerView!
    var pickerData: [String] = [String]()
    var missionData:[Mission] = []
    private var fontCellSize:CGFloat?
    
    private var data:[String] = []
    var selectedMission = "none"


    
    var startDateInt = 0
    var endDateInt = 0
    

    @IBOutlet var rightSwip: UISwipeGestureRecognizer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.fontCellSize = 20
        checkDeviceSize()
        //Used for handling constraints while displaying keyboard
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        datePicker.isHidden = true
        datePicker.backgroundColor = UIColor.white
        self.addButton.isEnabled = false
        
        self.disciplinePicker.delegate = self
        self.disciplinePicker.dataSource = self
        
        self.missionTableview.delegate = self
        self.missionTableview.dataSource = self
        
        //If we have a competitions, we load it
        if(selectedCompetition != "none"){
            loadCompetition()
            self.missionTableview.delegate = self
            self.missionTableview.dataSource = self
            self.disciplinePicker.isHidden = false
            self.addButton.isEnabled = true
            rightSwip.addTarget(self, action: #selector(handleSwipe(sender:)))
            view.addGestureRecognizer(rightSwip)
        }
    }
    
    func checkDeviceSize(){
        let screenSize: CGRect = UIScreen.main.bounds
        let screenHeight = screenSize.height
        let factor = screenHeight/568
        if(factor < 1.2){
            self.fontCellSize = 15
            self.endDate.font = UIFont(name: "AvenirNext-DemiBold", size: 15)
            self.refApi.font = UIFont(name: "AvenirNext-DemiBold", size: 15)
            self.startDate.font = UIFont(name: "AvenirNext-DemiBold", size: 15)
            self.titleCompetition.font = UIFont(name: "AvenirNext-DemiBold", size: 15)
            self.misLabel.font = UIFont(name: "AvenirNext-MediumItalic", size: 15)
        }
    }
    
    @objc func keyBoardWillShow(notification:Notification){
        if let userInfo = notification.userInfo as? Dictionary<String, AnyObject>{
            let frame = userInfo[UIResponder.keyboardFrameEndUserInfoKey]
            let keyBoardRect = frame?.cgRectValue
            if let keyBoardHeight = keyBoardRect?.height{
                constraintWithKeyboard()
                UIView.animate(withDuration: 0.5, animations:{
                    self.view.layoutIfNeeded()
                })
            }
        }
    }
    
    @objc func keyBoardWillHide(notification:Notification){
        constraintWithoutKeyboard()
        UIView.animate(withDuration: 0.5, animations:{
            self.view.layoutIfNeeded()
        })
    }
    
    func constraintWithKeyboard(){
        //Calculating relation
        let screenSize: CGRect = UIScreen.main.bounds
        let screenHeight = screenSize.height
        let factor = screenHeight/568
        
        self.MissionTop_Gap.constant = -73
        self.EnterTitleToStart_Gap.constant = 5 * factor
        self.StartDateToEndDate_Gap.constant = 5 * factor
        self.EndDateToRefAPI_Gap.constant = 5 * factor
    }
    
    func constraintWithoutKeyboard(){
        self.MissionTop_Gap.constant = 13
        self.EnterTitleToStart_Gap.constant = 20
        self.StartDateToEndDate_Gap.constant = 20
        self.EndDateToRefAPI_Gap.constant = 20
        self.HeightPicker.constant = 101
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
        datePicker.isHidden = true
        constraintWithoutKeyboard()
    }
    
    @objc func handleSwipe(sender: UISwipeGestureRecognizer) {
        if sender.state == .ended {
            
            let title = "Delete the competition"
            let message = "This action will delete the competition and all missions associated ! To continue, enter the name of the competition."
            
            let inputController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            inputController.addTextField { (textField: UITextField!) in
                textField.placeholder = "Competition name"
            }
            
            let submitAction = UIAlertAction(title: "Delete", style: .destructive) { (paramAction:UIAlertAction) in
                if let textFields = inputController.textFields{
                    let theTextFields = textFields as [UITextField]
                    let name = theTextFields[0].text!
                    
                    if(name == self.competiton?.name){
                        self.deleteCompetition(name: name)
                    }else{
                        self.present(inputController, animated: true, completion: nil)
                    }
                }
            }
            let cancel = UIAlertAction(title: "Cancel", style: .cancel)
            inputController.addAction(cancel)
            inputController.addAction(submitAction)
            self.present(inputController, animated: true, completion: nil)
        }
    }
    
    @IBAction func startdateEditing(_ sender: UITextField) {
        startDate.inputView = UIView()
        datePicker.isHidden = false
        constraintWithKeyboard()
    }
    
    /*@IBAction func startdateEditingEnd(_ sender: UITextField) {
        datePicker.isHidden = true
    }*/
    
    @IBAction func enddateEditing(_ sender: UITextField) {
        endDate.inputView = UIView()
        datePicker.isHidden = false
        constraintWithKeyboard()
    }
    
    /*@IBAction func enddateEditingEnd(_ sender: UITextField) {
        datePicker.isHidden = true
    }*/
    
    
    
    @IBAction func valueChanged(_ sender: UIDatePicker) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/YYYY HH:mm"
        let result = dateFormatter.string(from: sender.date)
        
        if startDate.isFirstResponder {
            startDate.text = result
            startDateInt = Int(sender.date.timeIntervalSince1970.rounded())
        }
        if endDate.isFirstResponder {
            endDate.text = result
            endDateInt = Int(sender.date.timeIntervalSince1970.rounded())
        }
    }
    
    
    var selectedCompetition: String?;
    var competiton: Competition?;
    var selectedDiscipline = "none"
    


    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return missionData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "missionsCell")! //1.
        
        let tempMission = missionData[indexPath.row]
        
        cell.textLabel?.text = tempMission.title //3.
        cell.textLabel?.font = UIFont(name: "Avenir Next Medium", size: self.fontCellSize!)
        cell.textLabel?.textColor = UIColor.white
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        
        return cell //4.
    }
    
    //Picker for one element
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1;
    }
    
    //Max element of picker array
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        pickerView.subviews.forEach({
            $0.isHidden = $0.frame.height < 1.0
        })
        return pickerData.count
    }
    
    //Picker element
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    //Picker formatting
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let view = UIView(frame: CGRect(x:0, y:0, width:400, height: self.fontCellSize!+5))
        
        let topLabel = UILabel(frame: CGRect(x:0, y:0, width: 400, height: self.fontCellSize!+5))
        topLabel.text = pickerData[row]
        topLabel.textColor = UIColor.white
        topLabel.textAlignment = .center
        topLabel.backgroundColor = UIColor.clear
        topLabel.font = UIFont(name: "Avenir Next Medium", size: self.fontCellSize!)
        view.addSubview(topLabel)
        
        return view
    }
    
    //Check wich element has been choosen
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedDiscipline = pickerData[row]
        //load the data for missions
        loadMissionData(disciplineName: pickerData[row])
    }
    
    func loadMissionData(disciplineName: String){
        FirebaseManager.getMisOfDisciplines(competitionName: self.selectedCompetition!, disciplineName: disciplineName) { (missionData) in
            self.missionData = Array(missionData)
            self.missionTableview.reloadData()
        }
    }
    
    func loadDisciplineData(){
        FirebaseManager.getDisciplinesOfCompetition(name: self.titleCompetition.text!) { (pickerData) in
            self.pickerData = Array(pickerData)
            self.pickerData.insert("Please select", at: 0)
            self.disciplinePicker.reloadAllComponents()
        }
    }
    //
    func loadCompetition(){
        //disable the field
        titleCompetition.isEnabled = false
        startDate.isEnabled = false
        endDate.isEnabled = false
        refApi.isEnabled = false
        save.isEnabled = false
        save.title = ""
       
        //load the competion object in the fields
        FirebaseManager.getCompetiton(name: selectedCompetition! , completion: { (data) in
            self.competiton = data
            self.titleCompetition.text = self.competiton?.name
            let start: UnixTime = (self.competiton?.startDateTime)!
            self.startDate.text = start.toDateTime
            let end: UnixTime = (self.competiton?.endDateTime)!
            self.endDate.text = end.toDateTime
            self.refApi.text = self.competiton?.refAPI
            self.loadDisciplineData()
        })
        
    }

    @IBAction func goBackManagement(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    //New competitions functions ---------------------------------------
    
    @IBAction func saveButton(_ sender: Any) {
        
        
        //UIAlert
        let alertBox = UIAlertController(
        title: "Input is wrong",
        message: "",
        preferredStyle: .actionSheet)
        
        alertBox.addAction(UIAlertAction(title:"Ok", style: .cancel, handler:nil))
        
        
        if(titleCompetition.text!.count < 5) || (titleCompetition.text ?? "").isEmpty{
            alertBox.message = "The title can contain text and/or numbers ";
            
            //Display the alertBox
            self.present(alertBox, animated: true);
            return;
        }
        

        if((isValidTexte(test: refApi.text!) == false)){
            alertBox.message = "refapi";
            
            //Display the alertBox
            self.present(alertBox, animated: true);
            return;
        }
        
        if(startDateInt>endDateInt){
            alertBox.message = "End date can't be before start date !";
            
            //Display the alertBox
            self.present(alertBox, animated: true);
            return;
        }
        
        insertCompetition()
        
    }
    
    func insertCompetition(){
        
        //create the object competition
        let newCompetition = Competition(name: titleCompetition.text ?? "Error", startDateTime: startDateInt, endDateTime: endDateInt, refAPI: refApi.text ?? "Error")
        
        //set the reference to the name of the new cometition
        let ref:DatabaseReference = Database.database().reference().child(FirebaseSession.competition.rawValue).child(newCompetition.name);
        
        //add the object
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            
            if snapshot.hasChildren(){
                let alertBox = UIAlertController(title: "This competition already exist !", message: "", preferredStyle: .actionSheet)
        
                alertBox.addAction(UIAlertAction(title:"Ok", style: .cancel, handler:nil))
                
                self.present(alertBox, animated: true);
                
            }else{
                ref.setValue(newCompetition.toAnyObject())
                self.save.isEnabled = false
            }
        })
        
        //disable the field
        titleCompetition.isEnabled = false
        startDate.isEnabled = false
        endDate.isEnabled = false
        refApi.isEnabled = false
        save.isEnabled = false
        save.title = ""
        self.disciplinePicker.isHidden = false
        self.addButton.isEnabled = true
        datePicker.isHidden = true
        
    }
    
    func isValidTexte(test:String)-> Bool {
        let textRegEx = "[A-Z-a-z-0-9]{4,20}"
        
        let textTest = NSPredicate(format: "SELF MATCHES %@", textRegEx)
        return textTest.evaluate(with:test)
    }
    
    @IBAction func back(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)

    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        selectedMission = missionData[indexPath.item].title
        performSegue(withIdentifier: "toDisplayMission", sender: self)
       
    }
    
    @IBAction func addAction(_ sender: Any) {
        selectedMission = "none"
        performSegue(withIdentifier: "toDisplayMission", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "toDisplayMission"){
        let destinationController = segue.destination as! MissionCreationViewController;
        destinationController.competitionChoose = self.titleCompetition.text!
        destinationController.missionChoose = selectedMission
        destinationController.disciplineChoose = selectedDiscipline
        }
    }
    
    func deleteCompetition(name: String){
        let ref:DatabaseReference = Database.database().reference().child(FirebaseSession.competition.rawValue).child(self.competiton!.name)
        
        ref.removeValue()
        self.dismiss(animated: false, completion: nil)
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        selectedCompetition = self.titleCompetition.text
        self.loadCompetition()
    }
  
    
}
