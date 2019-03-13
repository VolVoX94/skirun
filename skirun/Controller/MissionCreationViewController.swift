//
//  MissionCreationViewController.swift
//  skirun
//
//  Created by iOS Dev on 13.03.19.
//  Copyright © 2019 hevs. All rights reserved.
//

import UIKit


class MissionCreationViewController: UIViewController {
    
    
    @IBOutlet weak var startTime: UITextField!
    
    @IBOutlet weak var endTime: UITextField!
    
    @IBOutlet weak var timePicker: UIDatePicker!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        timePicker.isHidden = true
        timePickerStart()

        // Do any additional setup after loading the view.
    }
    
    
    func timePickerStart(){
        
        timePicker.isHidden = false
        let number = 10
        print(number)
    }
    
    
    
    @IBAction func timePickerChanged(_ sender: Any) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        let strDate = dateFormatter.string(from: timePicker.date)
        startTime.text = strDate
        
        
    }
    
    

    @IBAction func backCompetition(_ sender: Any) {
        dismiss(animated: true, completion: nil)
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
