//
//  SettingsViewController.swift
//  skirun
//
//  Created by AISLAB on 12.03.19.
//  Copyright © 2019 hevs. All rights reserved.
//

import UIKit
import Firebase

class SettingsViewController: UIViewController {
    
    let uid:String? = Auth.auth().currentUser?.email
    
    @IBOutlet weak var uidLabel: UILabel!
    
    @IBOutlet weak var logoutButton: UIButton!
    
    @IBAction func logoutFunc(_ sender: Any) {
        do
        {
            try Auth.auth().signOut()
        }
        catch let error as NSError
        {
            let alertController = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    
    @IBAction func changeRoleButton(_ sender: Any) {
        performSegue(withIdentifier: "toRole", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.uidLabel.text = uid

        // Do any additional setup after loading the view.
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
