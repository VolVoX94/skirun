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
    

    // ------------------ Competitions
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
    
    //---------------- Get Mission ------------
    static func getMission(nameCompetition: String,nameDiscipline: String, nameMission: String, completion: @escaping (Mission) -> Void) {
        let ref:DatabaseReference = Database.database().reference().child(FirebaseSession.competition.rawValue).child(nameCompetition).child(FirebaseSession.NODE_DISCIPLINES.rawValue).child(nameDiscipline).child(nameMission);
        
        ref.observe(.value, with: { (snapshot) in
            print(snapshot)
            let mission = Mission(title: snapshot.key,
                                  description: snapshot.childSnapshot(forPath:
                                    FirebaseSession.MISSION_DESCRIPTION.rawValue).value as! String,
                                  startTime: snapshot.childSnapshot(forPath:
                                    FirebaseSession.MISSION_STARTDATE.rawValue).value as! Int,
                                  endTime: snapshot.childSnapshot(forPath: FirebaseSession.MISSION_ENDDATE.rawValue).value as! Int,
                                  nbPeople: snapshot.childSnapshot(forPath: FirebaseSession.MISSION_NBROFPEOPLE.rawValue).value as! Int,
                                  location: snapshot.childSnapshot(forPath:
                                    FirebaseSession.MISSION_DOOR.rawValue).value as! String, discipline: "null",
                                  jobs: snapshot.childSnapshot(forPath:
                                    FirebaseSession.MISSION_TYPE_JOB.rawValue).value as! String)
            completion(mission)
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
            missions.removeAll()
            for childSnapshot in snapshot.children{
                let tempMission = Mission(title: (childSnapshot as AnyObject ).key as String,
                                          description: snapshot.childSnapshot(forPath: (childSnapshot as AnyObject).key as String).childSnapshot(forPath: FirebaseSession.MISSION_DESCRIPTION.rawValue).value as! String,
                                          startTime: snapshot.childSnapshot(forPath: (childSnapshot as AnyObject).key as String).childSnapshot(forPath: FirebaseSession.MISSION_STARTDATE.rawValue).value as! Int, endTime: snapshot.childSnapshot(forPath: (childSnapshot as AnyObject).key as String).childSnapshot(forPath: FirebaseSession.MISSION_ENDDATE.rawValue).value as! Int, nbPeople:  snapshot.childSnapshot(forPath: (childSnapshot as AnyObject).key as String).childSnapshot(forPath: FirebaseSession.MISSION_NBROFPEOPLE.rawValue).value as! Int, location:" ", discipline: "String", jobs: snapshot.childSnapshot(forPath: (childSnapshot as AnyObject).key as String).childSnapshot(forPath: FirebaseSession.MISSION_TYPE_JOB.rawValue).value as! String)
            
                var selected = [String]()
                
                
                
                for selectedChild in ((childSnapshot as AnyObject).childSnapshot(forPath: FirebaseSession.MISSION_SELECTED.rawValue)).children{
                    selected.append((selectedChild as AnyObject ).key as String)
                }
                
                tempMission.selected = selected
                missions.append(tempMission)
            }
            completion(missions)
        })
    }
    
    //----------------- USER
    static func getUserByUID(uidUser: String, completion: @escaping (User) -> Void) {
        let ref:DatabaseReference = Database.database().reference().child(FirebaseSession.user.rawValue).child(uidUser);
        print(uidUser)
        ref.observe(.value, with: { (snapshot) in
            
            
            //CREATING USER OBJECT
            let tempUser = User(firstName: snapshot.childSnapshot(forPath: FirebaseSession.USER_FIRSTNAME.rawValue).value as! String,
                                lastName: snapshot.childSnapshot(forPath: FirebaseSession.USER_LASTNAME.rawValue).value as! String,
                                phone: snapshot.childSnapshot(forPath: FirebaseSession.USER_PHONE.rawValue).value as! String,
                                admin: false, // NOT NECESSARY
                email: snapshot.childSnapshot(forPath: FirebaseSession.USER_EMAIL.rawValue).value as! String,
                password: "" //NOT NECESSARY
            )
            
            
            //ADDING TO LIST
            completion(tempUser)
        })

        
    }
    
    
    // -------------------------- SUBSCRIBERS
    static func getSubscriberOfMission(competitionName: String, disciplineName: String, nameMission:String, completion: @escaping ([String], DatabaseReference)-> Void){
        let ref:DatabaseReference = Database.database().reference().child(FirebaseSession.competition.rawValue).child(competitionName).child(FirebaseSession.NODE_DISCIPLINES.rawValue).child(disciplineName).child(nameMission).child(FirebaseSession.MISSION_SUBSCRIBED.rawValue);
        
        var userList = [String]()
        
        ref.observe(.value, with: { (snapshot) in
            for childSnapshot in snapshot.children {
                userList.append((childSnapshot as AnyObject).key as String)
            }
            completion(userList, ref)
        })
    }
    
    //Add Subscribers to missions
    static func saveSubscribersToMission(uidUser:String, nameMission:String, nameDiscipline:String, nameCompetition:String){
        
        //set the reference to the name of the new cometition
        let ref:DatabaseReference = Database.database().reference().child(FirebaseSession.competition.rawValue).child(nameCompetition).child(FirebaseSession.NODE_DISCIPLINES.rawValue).child(nameDiscipline).child(nameMission).child(FirebaseSession.MISSION_SUBSCRIBED.rawValue);
        
        let newChild = ref.child(uidUser)
        newChild.setValue(true);
        
    }
    
    //Delete Subscribers
    static func deleteSubscriber(uidUser:String, nameMission:String, nameDiscipline:String, nameCompetition:String){
        
        //set the reference to the name of the new cometition
        let ref:DatabaseReference = Database.database().reference().child(FirebaseSession.competition.rawValue).child(nameCompetition).child(FirebaseSession.NODE_DISCIPLINES.rawValue).child(nameDiscipline).child(nameMission).child(FirebaseSession.MISSION_SUBSCRIBED.rawValue);
        
        let newChild = ref.child(uidUser)
        newChild.removeValue()
    }
    
    //Check State for availability Switch
    static func checkIfAlreadySubscribed(uidUser:String, missionData: [Mission], nameDiscipline:String, nameCompetition:String, completion: @escaping ([String])-> Void){
        
        var states = [String]()
        
        for item in missionData{
            let ref:DatabaseReference = Database.database().reference().child(FirebaseSession.competition.rawValue).child(nameCompetition).child(FirebaseSession.NODE_DISCIPLINES.rawValue).child(nameDiscipline).child(item.title).child(FirebaseSession.MISSION_SUBSCRIBED.rawValue);
            print(item.title)
            ref.observe(.value, with: { (snapshot) in
                for childSnapshot in snapshot.children{
                    //Load UID
                    let tempUid:String = (childSnapshot as AnyObject).key as String
                    print(item.title)
                    print(tempUid, " - Compared with - ", uidUser)
                    //Check if currentUser has an subscription
                    if(tempUid == uidUser){
                        //Identifier for mission
                        
                        states.append(item.jobs)
                        for item in states{
                            print("states", item)
                        }
                        
                    }
                    completion(states)
                }
            })
        }
    }
}
