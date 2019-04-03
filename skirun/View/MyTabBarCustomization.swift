//
//  MyTabBarCustomization.swift
//  skirun
//
//  Created by Admin on 03.04.19.
//  Copyright © 2019 hevs. All rights reserved.
//

import UIKit

class MyTabBarCustomization: UITabBarController {

    @IBOutlet weak var myTabBar: UITabBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        var newFrame = tabBar.frame
        newFrame.size.height = 88;
        newFrame.origin.y = view.frame.size.height - 2
        myTabBar.frame.size.height = 50;
        myTabBar.frame = newFrame
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
