//
//  LoginViewController.swift
//  skirun
//
//  Created by AISLAB on 11.03.19.
//  Copyright © 2019 hevs. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController,  UITextFieldDelegate {

    
    @IBOutlet weak var myRegisterToBottom_Gap: NSLayoutConstraint!
    @IBOutlet weak var myLoginToTopTitle_Gap: NSLayoutConstraint!
    @IBOutlet weak var emailField: UITextField!
    
    @IBOutlet weak var passwordField: UITextField!
    
    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var registerButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        designTextField()
        
        //KEYBOARD - RETURN = Button "next"
        self.emailField.delegate = self
        self.passwordField.delegate = self
        
        //If the user is already logged we skip the page
        Auth.auth().addStateDidChangeListener { auth, user in
            if user != nil {
                self.performSegue(withIdentifier: "alreadyLoggedIn", sender: nil)
            } 
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    
    @objc func keyBoardWillShow(notification:Notification){
        print("Up")
        if let userInfo = notification.userInfo as? Dictionary<String, AnyObject>{
            let frame = userInfo[UIResponder.keyboardFrameEndUserInfoKey]
            let keyBoardRect = frame?.cgRectValue
            if let keyBoardHeight = keyBoardRect?.height{
                self.myRegisterToBottom_Gap.constant = keyBoardHeight
                
                self.myLoginToTopTitle_Gap.constant = 50
                
                UIView.animate(withDuration: 0.5, animations:{
                    self.view.layoutIfNeeded()
                })
            }
        }
    }
    
    @objc func keyBoardWillHide(notification:Notification){
        print("Up")
        
        self.myRegisterToBottom_Gap.constant = 150
        
        self.myLoginToTopTitle_Gap.constant = 150
        UIView.animate(withDuration: 0.5, animations:{
            self.view.layoutIfNeeded()
        })
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    //when tap return-keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        loginAction(self)
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func loginAction(_ sender: Any) {
        Auth.auth().signIn(withEmail: emailField.text!, password: passwordField.text!) { (user, error) in
            if error == nil{
                print("LAUNCHED")
                self.performSegue(withIdentifier: "alreadyLoggedIn", sender: self)
            }
            else{
                let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                
                alertController.addAction(defaultAction)
                self.present(alertController, animated: true, completion: nil)
            }
        }
    }
    
    
    //UI Design purpose
    func designTextField(){
        emailField.borderStyle = UITextField.BorderStyle.roundedRect
        emailField.backgroundColor = UIColor.white
        
        passwordField.borderStyle = UITextField.BorderStyle.roundedRect
        passwordField.backgroundColor = UIColor.white
    }

}
