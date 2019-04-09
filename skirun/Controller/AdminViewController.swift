//
//  AdminViewController.swift
//  skirun
//
//  Created by iOS Dev on 13.03.19.
//  Copyright © 2019 hevs. All rights reserved.
//

import UIKit

class AdminViewController: UIViewController {
    
   

    @IBOutlet weak var myAdminPWButton: UIButton!
    
    override func viewDidLoad() {
        let keyManageController = KeyAdminViewController()
        keyManageController.automaticKeyGeneration()
        super.viewDidLoad()
    }
    
    
    @IBAction func adminPWFunc(_ sender: Any) {
        performSegue(withIdentifier: "MyAdminKeySegue", sender: self)
    }
    
    @IBAction func back(_ sender: Any) {
    self.dismiss(animated: false, completion: nil)
    }
}
