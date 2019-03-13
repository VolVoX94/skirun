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

class DetailsSignupViewController: UIViewController {
    //Attributes that get pushed data from previous controller
    var email: String?;
    var password: String?;
    var admin: Bool = false;
    var myUser:User?;
    
    @IBOutlet weak var fnameField: UITextField!
    @IBOutlet weak var lnameField: UITextField!
    @IBOutlet weak var phonefield: UITextField!
    @IBOutlet weak var registerButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func adminSwitch(_ sender: UISwitch) {
        if(sender.isOn == true){
            admin = true;

        }
        else{
            admin = false;
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
        
        if(wrongInput == false){
            //Create the user
            self.myUser = User(
                    firstName: fnameField.text!,
                    lastName: lnameField.text!,
                    phone: phonefield.text!,
                    admin: admin,
                    email: email!,
                    password: password!);
            
            print(myUser!.firstName + myUser!.lastName + myUser!.phone + myUser!.password + myUser!.email);
            
            //*********  FIREBASE  **********
            //1 ---- Create user in the authenticationtab
            Auth.auth().createUser(
                withEmail: self.email!,
                password: self.password!) { user, error in
                    if error == nil && user != nil {
                        print("user created")
                        
                    }
                    else {
                        alertBox.message = "\(error!.localizedDescription)";
                        
                        //Display the alertBox
                        self.present(alertBox, animated: true);
                    }
            }
            
            //2 ---- Get UID of actual user
            let firebaseUser = Auth.auth().currentUser;
            if let firebaseUser = firebaseUser {
                let uid = firebaseUser.uid;
                createUserInDB(uid: uid)
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
}
