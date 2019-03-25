

import UIKit
import Firebase
import FirebaseDatabase

class FirstViewController: UIViewController, UITableViewDataSource{
    
    var myCompetition:Competition?
    var competitions:[Competition] = []
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        tableView.dataSource = self
        
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
                name: snapshot.key,
                startDateTime: snapValue["stardDateTime"] as? String ?? "",
                endDateTime: snapValue["endDateTime"] as? String ?? "",
                guestClub: snapValue["guestClub"] as? String ?? "",
                refAPI: snapValue["refAPI"] as? String ?? "",
                discipline: snapValue["discipline"] as? String ?? "");
            
            //Add the item to the list
            self.competitions.insert(self.myCompetition!, at: 0)
        }
    }
    
    func numberOfSections(in tableView:UITableView) -> Int{
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("NUMBEROFROWSINSECTION---", competitions.count)
        return competitions.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyCell")!
        
        cell.textLabel?.text = competitions[indexPath.row].name
        
        print("CELLFORROWAT---", self.myCompetition?.name)
        return cell
    }
}

