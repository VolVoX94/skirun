//
//  AdminManagementViewController.swift
//  skirun
//
//  Created by iOS Dev on 13.03.19.
//  Copyright © 2019 hevs. All rights reserved.


import UIKit

class AdminManagementViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    @IBOutlet weak var chamLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    private var data: [String] = []
    private var fontCellSize:CGFloat?
    var selectedCompetition = "none"
    

    override func viewDidLoad() {
        super.viewDidLoad()
        fontCellSize = 20
        checkDeviceSize()
        tableView.dataSource = self
        tableView.delegate = self
        
        FirebaseManager.getCompetitons(completion: { (data) in
            self.data = Array(data)
            self.tableView.reloadData()
        })
    }
    
    func checkDeviceSize(){
        let screenSize: CGRect = UIScreen.main.bounds
        let screenHeight = screenSize.height
        let factor = screenHeight/568
        if(factor < 1.2){
            self.fontCellSize = 15
            self.chamLabel.font = UIFont(name: "AvenirNext-MediumItalic", size: 15)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellCompetition")!//1.
        cell.textLabel?.textColor = UIColor.white
        let text = data[indexPath.row] //2.
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        cell.textLabel?.text = text //3.
        cell.textLabel?.font = UIFont(name: "Avenir Next Medium", size: self.fontCellSize!)
        cell.textLabel?.textColor = UIColor.white
        
        return cell //4.
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        selectedCompetition = data[indexPath.item]
        performSegue(withIdentifier: "toChampionship", sender: self)
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destinationController = segue.destination as! CompetionCreationViewController;
        destinationController.selectedCompetition = selectedCompetition;
    }
    
    @IBAction func addAction(_ sender: Any) {
        selectedCompetition = "none"
        performSegue(withIdentifier: "toChampionship", sender: self)
    }
    
    
    @IBAction func backAdmin(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
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

