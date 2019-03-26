

import UIKit

class FirstViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    private var data:[String] = []
    private var name:String?
    private var date:String?
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        
        FirebaseManager.getCompetitons(completion: { (data) in
            self.data = Array(data)
        })
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
        cell.textLabel?.font = UIFont(name: "Avenir Next", size: 18)
        cell.textLabel?.textColor = UIColor.white
        
        return cell //4.
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
                self.name = data[indexPath.row]
                self.date = data[indexPath.row]
                var cell:UITableViewCell = tableView.cellForRow(at: indexPath)!
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
}

