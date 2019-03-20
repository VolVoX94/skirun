

import UIKit
import Firebase
import FirebaseDatabase

class FirstViewController: UITableViewController{
    
    var myCompetition:Competition?
    var competitions:[Competition]?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Delete seperator lines in the view
        self.tableView.separatorStyle = .none
        
        //Load data from firebase
        loadData()
        
        
    }
    
    @IBAction func backButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func showDetails(_ sender: Any) {
        //Open next view, prepare method will be launched
        performSegue(withIdentifier: "MyAvailabiltySegue", sender: self)
        
    }
    
    //give information to next view
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("test")
    }
    
    func loadData(){
        //Get data for the list
        let competitionSession:FirebaseSession = FirebaseSession.competition;
        
        var ref: DatabaseReference!
        ref =  Database.database().reference()
        
        ref.child(competitionSession.rawValue).queryOrderedByKey().observe(.childAdded) { (snapshot) in
            let snapValue = snapshot.value as! NSDictionary
            
            //Create temp object
            self.myCompetition = Competition(
                name: snapValue["name"] as? String ?? "",
                startDateTime: snapValue["stardDateTime"] as? String ?? "",
                endDateTime: snapValue["endDateTime"] as? String ?? "",
                guestClub: snapValue["guestClub"] as? String ?? "",
                refAPI: snapValue["refAPI"] as? String ?? "",
                discipline: snapValue["discipline"] as? String ?? "");
            
            print(self.myCompetition?.name)
            
            //Add the item to the list
            self.competitions?.append(self.myCompetition!)
            self.tableView.reloadData()
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return competitions?.count ?? 0;
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
        
        let nameLabel = cell?.viewWithTag(1) as! UILabel
        nameLabel.text = competitions?[indexPath.row].name
        
        return cell!
        
    }
  
}

