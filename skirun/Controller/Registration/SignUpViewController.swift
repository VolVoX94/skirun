//
//  SignUpViewController.swift
//  skirun
//
//  Created by AISLAB on 11.03.19.
//  Copyright © 2019 hevs. All rights reserved.
//

import UIKit
import Firebase

class SignUpViewController: UIViewController {

    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var repeatPwField: UITextField!
    @IBOutlet weak var nextButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func backButton(_ sender: Any) {
            self.dismiss(animated: true, completion: nil)
    }
    
    //when click on next
    @IBAction func nextButtonFunc(_ sender: Any) {
        
        var wrongInput = false;
        
        //Define a general UIAlert
        let alertBox = UIAlertController(
            title: "Input is wrong",
            message: "",
            preferredStyle: .actionSheet);
        
        alertBox.addAction(UIAlertAction(title: "Ok", style: .cancel, handler:nil))
        
        
        //Check if email is correct
        //Will call the regex pattern method!
        if((isValidEmail(testStr: emailField.text!) == false)){
            
            //Define that something is wrong
            wrongInput = true;
            alertBox.message = "Email should be like xyz@xy.xy";
            
            //Display the alertBox
            self.present(alertBox, animated: true);
        }
        
        //check if pw is big enough and equal to repeated pw and is not already set an alert
        if((passwordField.text?.count ?? 0 < 6) && wrongInput != true){
            //Define that something is wrong
            wrongInput = true;
            alertBox.message = "Please enter a password with at least 6 charachters";
            
            //Display the alertBox
            self.present(alertBox, animated: true);
        }
        
        
        //Check if pw equal to repeatedPw and is not already set an alert
        if((repeatPwField.text != passwordField.text) && wrongInput != true){
            //Define that something is wrong
            wrongInput = true;
            alertBox.message = "Password input is not equal";
            
            //Display the alertBox
            self.present(alertBox, animated: true);
        }
        
        //If the input is ok it will redirect to next page and is not already set an alert
        if(wrongInput == false){
            
            //Open next view, prepare method will be launched
            performSegue(withIdentifier: "MyRegisterSegue", sender: self)
            
        }
    }
    
    //Regex pattern for checking the email
    func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let email = emailField.text;
        let password = passwordField.text;
        
        let destinationController = segue.destination as! DetailsSignupViewController;
        destinationController.email = email;
        destinationController.password = password;
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}