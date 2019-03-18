

import UIKit
import Firebase

class FirstViewController: UIViewController {

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


}

