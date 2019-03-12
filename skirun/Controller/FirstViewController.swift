

import UIKit
import Firebase

class FirstViewController: UIViewController {

    @IBOutlet weak var logoutButton: UIButton!
    
    
    @IBAction func logoutFunct(_ sender: Any) {
        do
        {
            try Auth.auth().signOut()
        }
        catch let error as NSError
        {
            
        }
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }


}

