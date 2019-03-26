//
//  FirebaseManager.swift
//  skirun
//
//  Created by AISLAB on 20.03.19.
//  Copyright © 2019 hevs. All rights reserved.
//

import Foundation
import Firebase

class FirebaseManager{
    

    
    static func getCompetitons(completion: @escaping ([String]) -> Void) {
        let ref:DatabaseReference = Database.database().reference().child(FirebaseSession.competition.rawValue);
        var competitions = [String]()
        ref.observe(.value, with: { (snapshot) in
                for childSnapshot in snapshot.children{
                    competitions.append((childSnapshot as AnyObject).key as String)
                }
            completion(competitions)
        })
    }
    /*
    static func getDisciplines(completion: @escaping ([String]) -> Void) {
       let ref:DatabaseReference = Database.database().reference().child("disciplinesV2");
        ref.observe(.childAdded, with: { (snapshot) in
            let name: String = (snapshot.key as? String)!
            debugPrint("XXXXXXXXXXX",name)
        })
        
    }*/
    
    
    
    static func getDisciplines(completion: @escaping ([String])-> Void){
        let ref:DatabaseReference = Database.database().reference().child("disciplinesV2");
        var numberOfDisciplines = [String]()
        
        ref.observe(.childAdded, with: { (snapshot) in
            let name:String = snapshot.key
            print("XXXXXXXXXXX",name)
            
           numberOfDisciplines.append(name)
            completion(numberOfDisciplines)
        })
    }
    
    
    
    
    static func getCompetiton(name: String, completion: @escaping (Competition) -> Void) {
        let ref:DatabaseReference = Database.database().reference().child(FirebaseSession.competition.rawValue).child(name);
        
        ref.observe(.value, with: { (snapshot) in
            let competition = Competition(name: snapshot.key, startDateTime: snapshot.childSnapshot(forPath: FirebaseSession.NODE_STARTDATE.rawValue).value as! Int, endDateTime: snapshot.childSnapshot(forPath: FirebaseSession.NODE_ENDDATE.rawValue).value as! CLongLong, refAPI: snapshot.childSnapshot(forPath: FirebaseSession.NODE_REFAPI.rawValue).value as! String)
            
            
            completion(competition)
        })
    }
}
