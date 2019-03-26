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
    
    //Obtain all the discipline
    static func getDisciplines(completion: @escaping ([String])-> Void){
        let ref:DatabaseReference = Database.database().reference().child(FirebaseSession.discipline.rawValue);
        var numberOfDisciplines = [String]()
        
        ref.observe(.value, with: { (snapshot) in
            for childSnapshot in snapshot.children{
                numberOfDisciplines.append((childSnapshot as AnyObject).key as String)
                print((childSnapshot as AnyObject).key as String)
            }
            completion(numberOfDisciplines)
        })
        
    }
    
    //Obtain all the job
    static func getJobs(completion: @escaping ([String])-> Void){
        let ref:DatabaseReference = Database.database().reference().child(FirebaseSession.jobType.rawValue);
        var jobs = [String]()
        
        ref.observe(.value, with: { (snapshot) in
            for childSnapshot in snapshot.children{
                jobs.append((childSnapshot as AnyObject).key as String)
                print((childSnapshot as AnyObject).key as String)
            }
            completion(jobs)
        })
        
    }
    
    
    

    static func getCompetiton(name: String, completion: @escaping (Competition) -> Void) {
        let ref:DatabaseReference = Database.database().reference().child(FirebaseSession.competition.rawValue).child(name);
        
        ref.observe(.value, with: { (snapshot) in
            let competition = Competition(name: snapshot.key, startDateTime: snapshot.childSnapshot(forPath: FirebaseSession.NODE_STARTDATE.rawValue).value as! Int, endDateTime: snapshot.childSnapshot(forPath: FirebaseSession.NODE_ENDDATE.rawValue).value as! Int, refAPI: snapshot.childSnapshot(forPath: FirebaseSession.NODE_REFAPI.rawValue).value as! String)
            
            
            completion(competition)
        })
    }
    
    //---------------- DISCIPLINES ------------
    
    static func getDisciplinesOfCompetition(name: String, completion: @escaping ([String])-> Void){
        let ref:DatabaseReference = Database.database().reference().child(FirebaseSession.competition.rawValue).child(name).child("disciplines");
        var numberOfDisciplines = [String]()
        
        ref.observe(.childAdded, with: { (snapshot) in
            let name:String = snapshot.key
            print("XXXXXXXXXXX",name)
            
            numberOfDisciplines.append(name)
            completion(numberOfDisciplines)
        })
    }
    
    //----------------- MISSIONS ------------------
    static func getMissionsOfDisciplines(competitionName: String, disciplineName: String, completion: @escaping ([String])-> Void){
        let ref:DatabaseReference = Database.database().reference().child(FirebaseSession.competition.rawValue).child(competitionName).child("disciplines").child(disciplineName);
        var numberOfMissions = [String]()
        
        ref.observe(.childAdded, with: { (snapshot) in
            let name:String = snapshot.key
            print("XXXXXXXXXXX",name)
            
            numberOfMissions.append(name)
            completion(numberOfMissions)
        })
    }
    
}
