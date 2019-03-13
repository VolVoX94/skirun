//
//  DetailsSignupViewController.swift
//  skirun
//
//  Created by AISLAB on 11.03.19.
//  Copyright © 2019 hevs. All rights reserved.
//

import UIKit
import Firebase

class DetailsSignupViewController: UIViewController {
    var email: String?
    var password: String?
    var firstName: String?
    var lastName: String?
    var phone: String?

    @IBOutlet weak var fnameField: UITextField!
    @IBOutlet weak var lnameField: UITextField!
    @IBOutlet weak var phonefield: UITextField!
    @IBOutlet weak var registerButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    //When click on register button
    func handleSignUp(){
        self.firstName = fnameField.text;
        self.lastName = lnameField.text;
        self.phone = phonefield.text;
        
        //expressions
        
        print(firstName! + lastName! + phone! + password! + email!);
        
        /*Auth.auth().createUser(
            withEmail: self.email!,
            password: self.password!) { user, error in
            if error == nil && user != nil {
                print("user created")
            }
            else {
                print("Error creating user: \(error!.localizedDescription)")
            }
        }*/
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
