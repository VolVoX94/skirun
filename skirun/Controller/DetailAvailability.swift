//
//  DetailAvailability.swift
//  skirun
//
//  Created by Admin on 25.03.19.
//  Copyright © 2019 hevs. All rights reserved.
//

import UIKit

class DetailAvailability: UIViewController, UITableViewDataSource, UITableViewDelegate{
        
    private var data:[String] = []
    var name:String?
    var date:String?
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var myCompetitionName: UILabel!
    
    @IBOutlet weak var myStartDateLabel: UILabel!
        
        override func viewDidLoad() {
            super.viewDidLoad()
            tableView.dataSource = self
            
            FirebaseManager.getCompetitons(completion: { (data) in
                self.data = Array(data)
            })
            
            self.myCompetitionName.text = self.name
            self.myStartDateLabel.text = self.name
        }
        

    @IBAction func nextButton(_ sender: Any) {
            performSegue(withIdentifier: "MyNextSegue", sender: self)
        }
        @IBAction func backButton(_ sender: Any) {
            self.dismiss(animated: true, completion: nil)
        }
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return data.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cellCompetition")! //1.
            
            let text = data[indexPath.row] //2.
            
            cell.textLabel?.text = text //3.
            
            return cell //4.
        }
}
