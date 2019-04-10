

import UIKit
import Firebase

class FirstViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    private var data:[String] = []
    private var name:String?
    private var date:String?
    
    @IBOutlet weak var myWaitAnimation: UIActivityIndicatorView!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var noDataLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        
        self.myWaitAnimation.startAnimating()
        loadData()
     
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(self.data.count == 0 && self.myWaitAnimation.isAnimating == false){
            self.noDataLabel.text = "No data"
        }
        else{
            self.noDataLabel.text = ""
        }
        return data.count
    }
    
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
        cell.textLabel?.font = UIFont(name: "Avenir Next Medium", size: 20)
        cell.textLabel?.textColor = UIColor.white
        
        return cell //4.
    }
    
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
            cell.contentView.backgroundColor = UIColor(red:0.00, green:0.15, blue:0.29, alpha:1.0)
            performSegue(withIdentifier: "MyNextAvailability", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "MyNextAvailability"){
            let destinationController = segue.destination as! DetailAvailability;
            destinationController.name = self.name;
            destinationController.date = self.date;
        }
    }
    
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

