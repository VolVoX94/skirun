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
    
    
    @IBAction func nextButtonFunc(_ sender: Any) {
        if(isValidEmail(testStr: emailField.text!)){
            if(passwordField.text?.count ?? 0 >= 6){
                let nextController:DetailsSignupViewController = DetailsSignupViewController();
                
                //Send data to the next controller
                nextController.email = emailField.text;
                nextController.password = passwordField.text;
                
                //Open next view
                self.present(nextController, animated: true, completion: nil);
                
            }
                //wrong password
            else{
                let alertPassword = UIAlertController(
                    title: "Password not accepted",
                    message: "Please enter a password with at least 6 charachters",
                    preferredStyle: .actionSheet);
                
                self.present(alertPassword, animated: true);
            }
        }
            //wrong email
        else{
            let alertPassword = UIAlertController(
                title: "Email not accepted",
                message: "Email should be like xyz@xy.xy",
                preferredStyle: .actionSheet);
            
            self.present(alertPassword, animated: true);
        }
    }
    
    func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
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
