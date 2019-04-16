//
//  VideoViewController.swift
//  CameraIOS
//
//  Created by Jaufray on 12/03/2019.
//  Copyright © 2019 black and white. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation
import MobileCoreServices

import FirebaseStorage
import Firebase

class VideoViewController: UIViewController{

    var bipNumber:Int = 0
    var currentCompetition: String! = ""
    var currentDiscipline: String! = ""
    var currentMission: String! = ""
    var currentMissionObject: Mission!
    
    @IBOutlet weak var missionDescription: UITextView!
    
    var storageReference : StorageReference {
        return Storage.storage().reference().child("videos")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadMission()
    }
    
    @IBAction func recordButton(_ sender: AnyObject) {
        VideoHelper.startMediaBrowser(delegate: self , sourceType: .camera)
    }
    
    @IBAction func backButton(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
    
    //If want to save in the albums and photos of the device
    /*
    @objc func video(_ videoPath: String, didFinishSavingWithError error: Error?, contextInfo info: AnyObject) {
        let title = (error == nil) ? "Success" : "Error"
        let message = (error == nil) ? "Video was saved" : "Video failed to save"
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    */
    
    func loadMission(){
        FirebaseManager.getMission(nameCompetition: currentCompetition, nameDiscipline: currentDiscipline, nameMission: currentMission) { (data) in
            self.currentMissionObject = data
            self.missionDescription.text = self.currentMissionObject.description
        }
    }

    
}


extension VideoViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        dismiss(animated: true, completion: nil)
        
        guard let mediaType = info[UIImagePickerController.InfoKey.mediaType] as? String,
            mediaType == (kUTTypeMovie as String),
            let url = info[UIImagePickerController.InfoKey.mediaURL] as? URL
            //UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(url.path)
            else { return }
        
        // Save video to albums and photos
        //UISaveVideoAtPathToSavedPhotosAlbum(url.path, self, #selector(video(_:didFinishSavingWithError:contextInfo:)), nil)
        
        let semaphore = DispatchSemaphore(value: 1)
        
        DispatchQueue.global().async {
            semaphore.wait()
            
            
            let title = "BIP number"
            let message = "Save video linked to the skier"
            
            let inputController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            inputController.addTextField { (textField: UITextField!) in
                textField.placeholder = "Enter Bib Number"
                textField.keyboardType = .numberPad
            }
            
            let submitAction = UIAlertAction(title: "Submit", style: .default) { (paramAction:UIAlertAction) in
                if let textFields = inputController.textFields{
                    let theTextFields = textFields as [UITextField]
                    let enteredNumber = theTextFields[0].text!

                    self.bipNumber = Int(enteredNumber)!
                    semaphore.signal()
                }
            }
            
            inputController.addAction(submitAction)
            self.present(inputController, animated: true, completion: nil)
        }
        
        DispatchQueue.global().async {
            semaphore.wait()
            
            //Date formater
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale(identifier: "fr_CH")
            dateFormatter.dateFormat = "dd-MM-yyyy' 'HH:mm:ssZZZZZ"
            //Date
            let date = Date()
            /*let calendar = Calendar.current
            let day = calendar.component(.day, from: date)
            let month = calendar.component(.month, from: date)
            let year = calendar.component(.year, from: date)
            let hour = calendar.component(.hour, from: date)
            let minutes = calendar.component(.minute, from: date)
            */
            //let newDate = dateFormatter.date(from: dateFormatter.string(from: date))
            
            let uploadVideoReference = self.storageReference.child("\(self.currentCompetition!)_\(self.currentDiscipline!)_\(self.currentMission!)_\(self.bipNumber)_\(dateFormatter.string(from: date)))")
            let uploadTask = uploadVideoReference.putFile(from: url)
            
            uploadTask.observe(.success, handler: { (snapshot) in
                let title = (snapshot.error == nil) ? "Success" : "Error"
                let message = (snapshot.error == nil) ? "Video was saved" : "Error! Video failed to save"
                
                let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil))
                self.present(alert, animated: true, completion: nil)
            })
            uploadTask.resume()
            semaphore.signal()
        }
        
    }
    
}
