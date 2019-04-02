//
//  AvailabilityController.swift
//  skirun
//
//  Created by Admin on 01.04.19.
//  Copyright © 2019 hevs. All rights reserved.
//

import UIKit

class AvailabilityController: UIViewController{

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func nextButton(_ sender: Any) {
        performSegue(withIdentifier: "MyNextSegue", sender: self)
    }

}
