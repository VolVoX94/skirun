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
    
    
    static func getCompetiton(name: String, completion: @escaping (Competition) -> Void) {
        let ref:DatabaseReference = Database.database().reference().child(FirebaseSession.competition.rawValue).child(name);
        
        ref.observe(.value, with: { (snapshot) in
            let competition = Competition(name: snapshot.key, startDateTime: snapshot.childSnapshot(forPath: FirebaseSession.NODE_STARTDATE.rawValue).value as! CLongLong, endDateTime: snapshot.childSnapshot(forPath: FirebaseSession.NODE_ENDDATE.rawValue).value as! CLongLong, refAPI: snapshot.childSnapshot(forPath: FirebaseSession.NODE_REFAPI.rawValue).value as! String)
            
            
            completion(competition)
        })
    }
}
