//
//  ViewController.swift
//  skirun
//
//  Created by Admin on 25.02.19.
//  Copyright © 2019 GROUP2. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //test
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    //FOR TESTING CONTINIOUS INTEGRATION
    func isNumberOk(num: Int) -> Bool {
        if (num % 2 == 0){
            return true
        }
        else {
            return false
        }
    }
    
    func printHello(){
        print("hello")
    }
}




