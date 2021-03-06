

import UIKit
import Firebase

class FirstViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    //Attributes
    private var data:[String] = []
    private var name:String?
    private var date:String?
    private var fontSizeCell:CGFloat?
    
    //Frontend elements relation
    @IBOutlet weak var myWaitAnimation: UIActivityIndicatorView!
    @IBOutlet weak var myAvailabilityTitle: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var noDataLabel: UILabel!
    
    //Constructor
    override func viewDidLoad() {
        super.viewDidLoad()
        //Default size for cell, used for small Device -> will overwritten by checkDeviceSize
        self.fontSizeCell = 20
        checkDeviceSize()
        tableView.dataSource = self
        tableView.delegate = self
        
        self.myWaitAnimation.startAnimating()
        loadData()
     
    }
    
    //Method to rearange elements when using a small device
    func checkDeviceSize(){
        let screenSize: CGRect = UIScreen.main.bounds
        let screenHeight = screenSize.height
        let factor = screenHeight/568
        if(factor < 1.2){
            self.fontSizeCell = 15
            self.myAvailabilityTitle.font = UIFont(name: "AvenirNext-Bold", size: 20)
        }
    }
    
    //Default method to display tableview
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(self.data.count == 0 && self.myWaitAnimation.isAnimating == false){
            self.noDataLabel.text = "No data"
        }
        else{
            self.noDataLabel.text = ""
        }
        return data.count
    }
    
    //Default method to draw each cell in tableView
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellCompetition")! //1.
        var text = ""
        
        //EXCEPTION - CATCH NULLPOINTER
        do{
            text = try assignData(data: data, index: indexPath.row)//2.
        } catch let error as NSError{
            text = "NULL"
            print(error.localizedDescription)
        }
        
        cell.textLabel?.text = text //3.
        cell.textLabel?.font = UIFont(name: "Avenir Next Medium", size: self.fontSizeCell!)
        cell.textLabel?.textColor = UIColor.white
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        return cell //4.
    }
    
    //Default method to check which cell is selected
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //EXCEPTION - CATCH NAME VISUALISATION
        do{
            self.name = try assignData(data: data, index: indexPath.row)
            self.date = try assignData(data: data, index: indexPath.row)
        } catch{
            self.name = "NULL"
            self.date = "NULL"
            print(error.localizedDescription)
        }
            let cell:UITableViewCell = tableView.cellForRow(at: indexPath)!
            //cell.contentView.backgroundColor = UIColor(red:0.00, green:0.15, blue:0.29, alpha:1.0)
            performSegue(withIdentifier: "MyNextAvailability", sender: self)
    }
    
    //Default method which is called just before next screen is openend
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "MyNextAvailability"){
            let destinationController = segue.destination as! DetailAvailability;
            destinationController.name = self.name;
            destinationController.date = self.date;
        }
    }
    
    //Method to load data, for displaying its information in the tableView
    func loadData(){
        
        FirebaseManager.getCompetitons(completion: { (data) in
            self.data = Array(data)
            self.tableView.reloadData()
            self.myWaitAnimation.stopAnimating()
        })
    }
    
    //ERROR - HANDLING
    func assignData(data:[String], index:Int) throws -> String{
        return data[index]
    }
}

