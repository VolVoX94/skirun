//
//  DetailsSignupViewController.swift
//  skirun
//
//  Created by AISLAB on 11.03.19.
//  Copyright © 2019 hevs. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class DetailsSignupViewController: UIViewController, UITextFieldDelegate {
    //Attributes that get pushed data from previous controller
    var email: String?;
    var password: String?;
    var admin: Bool = false;
    var myUser:User?;
    
    @IBOutlet weak var myUpperGapSpace: NSLayoutConstraint!
    @IBOutlet weak var myMiddleGapSpace: NSLayoutConstraint!
    @IBOutlet weak var myGapSpace: NSLayoutConstraint!
    @IBOutlet weak var myKeyboardSafeSpace: NSLayoutConstraint!
    @IBOutlet weak var fnameField: UITextField!
    @IBOutlet weak var lnameField: UITextField!
    @IBOutlet weak var phonefield: UITextField!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var adminCheckNumber: UITextField!
    
    @IBOutlet weak var myTitleTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var adminTest: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        adminCheckNumber.isHidden = true

        //UI field designing
        designTextField()
        
        //set height when keyboard is activated
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
 
        //KEYBOARD - RETURN = Button "next"
        self.fnameField.delegate = self
        self.lnameField.delegate = self
        self.phonefield.delegate = self
    }
    
    @objc func keyBoardWillShow(notification:Notification){
        print("Up")
        if let userInfo = notification.userInfo as? Dictionary<String, AnyObject>{
            let frame = userInfo[UIResponder.keyboardFrameEndUserInfoKey]
            let keyBoardRect = frame?.cgRectValue
            if let keyBoardHeight = keyBoardRect?.height{
                self.myKeyboardSafeSpace.constant = keyBoardHeight
                
                self.myTitleTopConstraint.constant = 9
                
                    self.myGapSpace.constant = 10
                    self.myMiddleGapSpace.constant = 10
                self.myUpperGapSpace.constant = 20
                
                UIView.animate(withDuration: 0.5, animations:{
                    self.view.layoutIfNeeded()
                })
            }
        }
    }
    
    @objc func keyBoardWillHide(notification:Notification){
        print("Up")
        self.myGapSpace.constant = 40
        self.myKeyboardSafeSpace.constant = 10.0
        self.myTitleTopConstraint.constant = 100
        
        self.myMiddleGapSpace.constant = 40
        self.myUpperGapSpace.constant = 80
        UIView.animate(withDuration: 0.5, animations:{
            self.view.layoutIfNeeded()
        })
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    //when tap return-keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        registerButton(self)
        textField.resignFirstResponder()
        return true
    }
    
    
    @IBAction func adminTestFunc(_ sender: Any) {
        if(adminCheckNumber.text != ""){
            FirebaseManager.checkAdminNumber(inputNumber: adminCheckNumber.text!) { (Bool) in
                print(Bool)
                self.admin = Bool
            }
        }
        else{
            print("please insert a checknumber")
        }
    }
    @IBAction func adminSwitch(_ sender: UISwitch) {
        if(sender.isOn == true){
            admin = true;
            self.adminCheckNumber.isHidden = false

        }
        else{
            admin = false;
            self.adminCheckNumber.isHidden = true
        }
    }
    
    @IBAction func backButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func registerButton(_ sender: Any) {
        var wrongInput = false;
        
        //Define a general UIAlert
        let alertBox = UIAlertController(
            title: "Input is wrong",
            message: "",
            preferredStyle: .actionSheet);
        
        alertBox.addAction(UIAlertAction(title: "Ok", style: .cancel, handler:nil))
        
        
        //Check if email is correct
        //Will call the regex pattern method!
        if((isValidName(testStr: fnameField.text!) == false)){
            
            //Define that something is wrong
            wrongInput = true;
            alertBox.message = "Firstname should contain only alphanumeric letters A-Z, a-z";
            
            //Display the alertBox
            self.present(alertBox, animated: true);
        }
        
        //check if pw is big enough and equal to repeated pw and is not already set an alert
        if((isValidName(testStr: lnameField.text!) == false) && wrongInput != true){
            //Define that something is wrong
            wrongInput = true;
            alertBox.message = "Lastname should contain only alphanumeric letters A-Z, a-z";
            
            //Display the alertBox
            self.present(alertBox, animated: true);
        }
        
        //check if pw is big enough and equal to repeated pw and is not already set an alert
        if((isValidPhone(testStr: phonefield.text!) == false) && wrongInput != true){
            //Define that something is wrong
            wrongInput = true;
            alertBox.message = "Phone numbers should contain numbers and have between 9 to 12 characters, country code +XY is optional";
            
            //Display the alertBox
            self.present(alertBox, animated: true);
        }
        print("admin before", self.admin)
        //Check admin input
        if(self.admin == true && wrongInput != true){
            if(adminCheckNumber.text != ""){
                FirebaseManager.checkAdminNumber(inputNumber: adminCheckNumber.text!) { (Bool) in
                    print(Bool)
                    if(Bool == false){
                        wrongInput = true;
                        alertBox.message = "Admin checknumber is wrong, please enter correct key";
                        self.present(alertBox, animated: true);
                    }
                    else{
                        self.createAndAutheticateUser(wrongInput: wrongInput, alertBox: alertBox)
                    }
                }
            }
            else{
                wrongInput = true;
                alertBox.message = "Admin checknumber is empty, please enter the key";
                self.present(alertBox, animated: true);
            }
        }
        else{
            self.createAndAutheticateUser(wrongInput: wrongInput, alertBox: alertBox)
        }
    }
    
    func createAndAutheticateUser(wrongInput:Bool, alertBox:UIAlertController){
        if(wrongInput == false){
            //Create the user
            self.myUser = User(
                firstName: fnameField.text!,
                lastName: lnameField.text!,
                phone: phonefield.text!,
                admin: admin,
                email: email!,
                password: password!,
                jobPreference: ""
            );
            
            print(myUser!.firstName + myUser!.lastName + myUser!.phone + myUser!.password + myUser!.email);
            
            //*********  FIREBASE  **********
            //1 ---- Create user in the authenticationtab
            Auth.auth().createUser(
                withEmail: self.email!,
                password: self.password!) { user, error in
                    if error == nil && user != nil {
                        print("user created")
                        
                        //2 ---- Get UID of actual user
                        let firebaseUser = Auth.auth().currentUser;
                        if let firebaseUser = firebaseUser {
                            let uid = firebaseUser.uid;
                            self.createUserInDB(uid: uid)
                        }
                    }
                    else {
                        alertBox.message = "\(error!.localizedDescription)";
                        
                        //Display the alertBox
                        self.present(alertBox, animated: true);
                    }
            }
        }
    }
    
    func createUserInDB(uid:String){
        //3 ---- Create user in the storage
        
        //need load value from enum
        let userSession:FirebaseSession = FirebaseSession.user;
        
        var ref: DatabaseReference!
        ref = Database.database().reference();
        ref.child(userSession.rawValue).child(uid).setValue(self.myUser!.toAnyObject());
        
        performSegue(withIdentifier: "AccountCreated", sender: self)
    }
    

    
    
    //Regex pattern for checking the names
    func isValidName(testStr:String) -> Bool {
        let nameRegEx = "[A-Za-z]{4,20}"
        
        let nameTest = NSPredicate(format:"SELF MATCHES %@", nameRegEx)
        return nameTest.evaluate(with: testStr)
    }
    
    //Regex pattern for checking the names
    func isValidPhone(testStr:String) -> Bool {
        let phoneRegEx = "([+]?)[0-9]{9,20}"
        
        let phoneTest = NSPredicate(format:"SELF MATCHES %@", phoneRegEx)
        return phoneTest.evaluate(with: testStr)
    }
    
    
    //UI Design purpose
    func designTextField(){
        
        fnameField.borderStyle = UITextField.BorderStyle.roundedRect
        fnameField.backgroundColor = UIColor.white
        fnameField.frame.size.height = 50;
        
        lnameField.borderStyle = UITextField.BorderStyle.roundedRect
        lnameField.backgroundColor = UIColor.white
        lnameField.frame.size.height = 50;
        
        phonefield.borderStyle = UITextField.BorderStyle.roundedRect
        phonefield.backgroundColor = UIColor.white
        phonefield.frame.size.height = 50;
        
        adminCheckNumber.borderStyle = UITextField.BorderStyle.roundedRect
        adminCheckNumber.backgroundColor = UIColor.white
        adminCheckNumber.frame.size.height = 50;
    }
}
