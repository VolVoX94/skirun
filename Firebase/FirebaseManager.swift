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
            competitions.removeAll()
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
            }
            completion(jobs)
        })
        
    }
    
    
    

    static func getCompetiton(name: String, completion: @escaping (Competition) -> Void) {
        let ref:DatabaseReference = Database.database().reference().child(FirebaseSession.competition.rawValue).child(name);
        
        ref.observe(.value, with: { (snapshot) in
            let competition = Competition(name: snapshot.key,
                                          startDateTime: snapshot.childSnapshot(forPath: FirebaseSession.NODE_STARTDATE.rawValue).value as! Int,
                                          endDateTime: snapshot.childSnapshot(forPath: FirebaseSession.NODE_ENDDATE.rawValue).value as! Int,
                                          refAPI: snapshot.childSnapshot(forPath: FirebaseSession.NODE_REFAPI.rawValue).value as! String)
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
    
    //Get all missions as "MISSION"-Objects
    static func getMisOfDisciplines(competitionName: String, disciplineName: String, completion: @escaping ([Mission])-> Void){
        let ref:DatabaseReference = Database.database().reference().child(FirebaseSession.competition.rawValue).child(competitionName).child("disciplines").child(disciplineName);
        var missions:[Mission] = []
        ref.observe(.value, with: { (snapshot) in
            for childSnapshot in snapshot.children{
                let tempMission = Mission(title: (childSnapshot as AnyObject).key as String,
                                          description: snapshot.childSnapshot(forPath: (childSnapshot as AnyObject).key as String).childSnapshot(forPath: FirebaseSession.MISSION_DESCRIPTION.rawValue).value as! String,
                                          startTime: snapshot.childSnapshot(forPath: (childSnapshot as AnyObject).key as String).childSnapshot(forPath: FirebaseSession.MISSION_STARTDATE.rawValue).value as! Int, endTime: snapshot.childSnapshot(forPath: (childSnapshot as AnyObject).key as String).childSnapshot(forPath: FirebaseSession.MISSION_ENDDATE.rawValue).value as! Int, nbPeople:  snapshot.childSnapshot(forPath: (childSnapshot as AnyObject).key as String).childSnapshot(forPath: FirebaseSession.MISSION_NBROFPEOPLE.rawValue).value as! Int, location:" ", discipline: "String", jobs: snapshot.childSnapshot(forPath: (childSnapshot as AnyObject).key as String).childSnapshot(forPath: FirebaseSession.MISSION_TYPE_JOB.rawValue).value as! String)
            
                
                missions.append(tempMission)
            }
            completion(missions)
        })
    }
    
    //Add Subscribers to missions
    static func saveSubscribersToMission(uidUser:String, nameMission:String, nameDiscipline:String, nameCompetition:String){
        
        //set the reference to the name of the new cometition
        let ref:DatabaseReference = Database.database().reference().child(FirebaseSession.competition.rawValue).child(nameCompetition).child(FirebaseSession.NODE_DISCIPLINES.rawValue).child(nameDiscipline).child(nameMission).child(FirebaseSession.MISSION_SUBSCRIBED.rawValue);
        
            let newChild = ref.child(uidUser)
            newChild.setValue(true);

    }
    
    //Add Subscribers to missions
    static func deleteSubscriber(uidUser:String, nameMission:String, nameDiscipline:String, nameCompetition:String){
        
        //set the reference to the name of the new cometition
        let ref:DatabaseReference = Database.database().reference().child(FirebaseSession.competition.rawValue).child(nameCompetition).child(FirebaseSession.NODE_DISCIPLINES.rawValue).child(nameDiscipline).child(nameMission).child(FirebaseSession.MISSION_SUBSCRIBED.rawValue);
        
        let newChild = ref.child(uidUser)
        newChild.removeValue()
    }
    
    static func checkIfAlreadySubscribed(uidUser:String, nameDiscipline:String, nameCompetition:String, completion: @escaping ([String])-> Void){
        var tempMissionData:[Mission] = []
        
        var states = [String]()
        FirebaseManager.getMisOfDisciplines(competitionName: nameCompetition, disciplineName: nameDiscipline) { (missionData) in
            tempMissionData = Array(missionData)
            states.removeAll()
            //For every mission in list
            for item in tempMissionData{
                let ref:DatabaseReference = Database.database().reference().child(FirebaseSession.competition.rawValue).child(nameCompetition).child(FirebaseSession.NODE_DISCIPLINES.rawValue).child(nameDiscipline).child(item.title).child("subscribed");
                
                
                ref.observe(.value, with: { (snapshot) in
                    for childSnapshot in snapshot.children{
                        //Load UID
                        let tempUid:String = (childSnapshot as AnyObject).key as String
                        //Check if currentUser has an subscription
                        if(tempUid == uidUser){
                            //Identifier for mission
                            print("IN",item.description)
                            states.append(item.description)
                        }
                    }

                    //print(states.count)
                    completion(states)
                    
                })
            }
        }
    }
}
