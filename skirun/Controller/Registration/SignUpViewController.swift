//
//  SignUpViewController.swift
//  skirun
//
//  Created by AISLAB on 11.03.19.
//  Copyright © 2019 hevs. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController, UITextFieldDelegate {

    //Frontend element relations
    @IBOutlet weak var myThirdFieldHeight: NSLayoutConstraint!
    @IBOutlet weak var mySecondFieldHeight: NSLayoutConstraint!
    @IBOutlet weak var myFieldHeight: NSLayoutConstraint!
    @IBOutlet weak var myBottomToButton_Gap: NSLayoutConstraint!
    @IBOutlet weak var myThirdToSecodField_Gap: NSLayoutConstraint!
    @IBOutlet weak var mySecondToFirstField_Gap: NSLayoutConstraint!
    @IBOutlet weak var myFirstTextToTitle_Gap: NSLayoutConstraint!
    @IBOutlet weak var myTitleToTop_Gap: NSLayoutConstraint!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var repeatPwField: UITextField!
    @IBOutlet weak var nextButton: UIButton!
    
    //Constructor
    override func viewDidLoad() {
        super.viewDidLoad()

        //UI field designing
        designTextField()
        
        //KEYBOARD - RETURN = Button "next"
        self.emailField.delegate = self
        self.passwordField.delegate = self
        self.repeatPwField.delegate = self
        
        //set height when keyboard is activated
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    //When keyboard is activated - frontend will change to following attributes:
    @objc func keyBoardWillShow(notification:Notification){
        print("Up")
        if let userInfo = notification.userInfo as? Dictionary<String, AnyObject>{
            let frame = userInfo[UIResponder.keyboardFrameEndUserInfoKey]
            let keyBoardRect = frame?.cgRectValue
            if let keyBoardHeight = keyBoardRect?.height{
                //Calculating relation
                let screenSize: CGRect = UIScreen.main.bounds
                let screenHeight = screenSize.height
                let factor = screenHeight/568
                self.myBottomToButton_Gap.constant = keyBoardHeight + 10*factor
                
                self.myTitleToTop_Gap.constant = -100
                self.myFirstTextToTitle_Gap.constant = 120*factor
                self.mySecondToFirstField_Gap.constant = 20*factor
                self.myThirdToSecodField_Gap.constant = 20*factor
                self.myFieldHeight.constant = 35
                self.myThirdFieldHeight.constant = 35
                self.mySecondFieldHeight.constant = 35
                
                UIView.animate(withDuration: 0.5, animations:{
                    self.view.layoutIfNeeded()
                })
            }
        }
    }
    
    //When keyboard is deactivated - frontend will have to following default attributes:
    @objc func keyBoardWillHide(notification:Notification){
        print("Up")
        
        self.myFieldHeight.constant = 40
        self.myThirdFieldHeight.constant = 40
        self.mySecondFieldHeight.constant = 40
        self.myTitleToTop_Gap.constant = 68
        self.myFirstTextToTitle_Gap.constant = 74
        self.mySecondToFirstField_Gap.constant = 42
        self.myThirdToSecodField_Gap.constant = 42
        self.myBottomToButton_Gap.constant = 38
        UIView.animate(withDuration: 0.5, animations:{
            self.view.layoutIfNeeded()
        })
    }
    
    //Back button
    @IBAction func backButton(_ sender: Any) {
            self.dismiss(animated: true, completion: nil)
    }
    
    //When you click somewhere keyboard will disappear
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    //when tap return-keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        nextButtonFunc(self)
        textField.resignFirstResponder()
        return true
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
    
    //Prepare opening of next screen, automatically called when performSegue is called (nextButton)
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let email = emailField.text;
        let password = passwordField.text;
        
        let destinationController = segue.destination as! DetailsSignupViewController;
        destinationController.email = email;
        destinationController.password = password;
    }

    //UI Design purpose
    func designTextField(){
        emailField.borderStyle = UITextField.BorderStyle.roundedRect
        emailField.backgroundColor = UIColor.white
        
        passwordField.borderStyle = UITextField.BorderStyle.roundedRect
        passwordField.backgroundColor = UIColor.white
        
        repeatPwField.borderStyle = UITextField.BorderStyle.roundedRect
        repeatPwField.backgroundColor = UIColor.white
    }
}
