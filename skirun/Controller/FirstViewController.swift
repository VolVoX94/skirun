

import UIKit
import Firebase

class FirstViewController: UITableViewController {
    
    var myCompetition:Competition?;
    let competitions = [myCompetition];

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
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
    
    func loadData(uid:String){
        //Get data for the list
        let competitionSession:FirebaseSession = FirebaseSession.competition;
        
        var ref: DatabaseReference!
        ref = Database.database().reference();
        
        ref.child(competitionSession.rawValue).childByAutoId()
        
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        <#code#>
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        <#code#>
    }


}

