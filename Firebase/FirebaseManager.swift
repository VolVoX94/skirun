//
//  FirebaseManager.swift
//  skirun
//
//  Created by AISLAB on 20.03.19.
//  Copyright © 2019 hevs. All rights reserved.
//

//1. Competition
//2. Jobs
//3. Discipline
//4. Mission
//5. User
//6. Subscriber
import Foundation
import Firebase

class FirebaseManager{
    
    //1.-------------------------- COMPETITION --------------------------
    //**** GET COMPETITIONS AS STRING
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
    
    
    // ****** GET COMPETITION AS OBJECT
    static func getCompetiton(name: String, completion: @escaping (Competition) -> Void) {
        let ref:DatabaseReference = Database.database().reference().child(FirebaseSession.competition.rawValue).child(name);
        
        ref.observe(.value, with: { (snapshot) in
            let competition = Competition(name: snapshot.key,
                                          startDateTime: snapshot.childSnapshot(forPath: FirebaseSession.NODE_STARTDATE.rawValue).value as? Int ?? 0,
                                          endDateTime: snapshot.childSnapshot(forPath: FirebaseSession.NODE_ENDDATE.rawValue).value as? Int ?? 0,
                                          refAPI: snapshot.childSnapshot(forPath: FirebaseSession.NODE_REFAPI.rawValue).value as? String ?? "NULL")
            completion(competition)
        })
    }
    
    //2. -------------------------- JOBS --------------------------
    // ****** GET JOBS AS STRING
    static func getJobs(completion: @escaping ([String])-> Void){
        let ref:DatabaseReference = Database.database().reference().child(FirebaseSession.jobType.rawValue);
        var jobs = [String]()
        // get all the job preferences in a list
        ref.observe(.value, with: { (snapshot) in
            for childSnapshot in snapshot.children{
                // put it in the list
                jobs.append((childSnapshot as AnyObject).key as String)
            }
            completion(jobs)
        })
    }
    
    // ****** GET THE JOB FROM CURRENT USER AS STRING
    static func getJobsFromUser(uidUser: String, completion: @escaping (String) -> Void) {
        let ref:DatabaseReference = Database.database().reference().child(FirebaseSession.user.rawValue).child(uidUser);
        var job = String()
        // get the job in the current user
        ref.observe(.value, with: { (snapshot) in
            job = snapshot.childSnapshot(forPath: FirebaseSession.USER_JOBPREFERENCE.rawValue).value as? String ?? "NULL"
            
            completion(job)
        })
    }
  
    
    //3.-------------------------- DISCIPLINES --------------------------
    
    //***** GET DISCIPLINE AS STRING
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
    
    //4.-------------------------- MISSIONS --------------------------
    //***** Get Mission
    static func getMission(nameCompetition: String,nameDiscipline: String, nameMission: String, completion: @escaping (Mission) -> Void) {
        let ref:DatabaseReference = Database.database().reference().child(FirebaseSession.competition.rawValue).child(nameCompetition).child(FirebaseSession.NODE_DISCIPLINES.rawValue).child(nameDiscipline).child(nameMission);
        
        ref.observe(.value, with: { (snapshot) in
            let mission = Mission(title: snapshot.key,
                                  description: snapshot.childSnapshot(forPath:
                                    FirebaseSession.MISSION_DESCRIPTION.rawValue).value as? String ?? "NULL",
                                  startTime: snapshot.childSnapshot(forPath:
                                    FirebaseSession.MISSION_STARTDATE.rawValue).value as? Int ?? 0,
                                  endTime: snapshot.childSnapshot(forPath: FirebaseSession.MISSION_ENDDATE.rawValue).value as? Int ?? 0,
                                  nbPeople: snapshot.childSnapshot(forPath: FirebaseSession.MISSION_NBROFPEOPLE.rawValue).value as? Int ?? 0,
                                  location: snapshot.childSnapshot(forPath:
                                    FirebaseSession.MISSION_LOCATION.rawValue).value as? String ?? "NULL",
                                  jobs: snapshot.childSnapshot(forPath:
                                    FirebaseSession.MISSION_TYPE_JOB.rawValue).value as? String ?? "NULL")
            completion(mission)
        })
    }
    
    

    
    static func getDisciplinesOfCompetition(name: String, completion: @escaping ([String])-> Void){
        let ref:DatabaseReference = Database.database().reference().child(FirebaseSession.competition.rawValue).child(name).child("disciplines");
        var numberOfDisciplines = [String]()
        
        ref.observe(.value, with: { (snapshot) in
            
            for childSnapshot in snapshot.children{
                numberOfDisciplines.append((childSnapshot as AnyObject).key as String)
            }
            completion(numberOfDisciplines)
        })
    }
    
    //----------------- MISSIONS ------------------
    //****** GET MISSION BY DISCIPLINE
    static func getMissionsOfDisciplines(competitionName: String, disciplineName: String, completion: @escaping ([String])-> Void){
        let ref:DatabaseReference = Database.database().reference().child(FirebaseSession.competition.rawValue).child(competitionName).child(FirebaseSession.NODE_DISCIPLINES.rawValue).child(disciplineName);
        var numberOfMissions = [String]()
        
        ref.observe(.value, with: { (snapshot) in
            for childSnapshot in snapshot.children{
                numberOfMissions.append((childSnapshot as AnyObject).key as String)
            }
            completion(numberOfMissions)
        })
    }
    
    //****** GET MISSION AS MISSION OBJECT
    static func getMisOfDisciplines(competitionName: String, disciplineName: String, completion: @escaping ([Mission])-> Void){
        let ref:DatabaseReference = Database.database().reference().child(FirebaseSession.competition.rawValue).child(competitionName).child(FirebaseSession.NODE_DISCIPLINES.rawValue).child(disciplineName);
        var missions:[Mission] = []
        ref.observe(.value, with: { (snapshot) in
            missions.removeAll()
            for childSnapshot in snapshot.children{
                let object = snapshot.childSnapshot(forPath: (childSnapshot as AnyObject).key as String)
                let tempMission = Mission(title: (childSnapshot as AnyObject ).key as String,
                                          description: object.childSnapshot(forPath: FirebaseSession.MISSION_DESCRIPTION.rawValue).value as? String ??  "NULL",
                                          startTime: object.childSnapshot(forPath: FirebaseSession.MISSION_STARTDATE.rawValue).value as? Int ?? 0,
                                          endTime: object.childSnapshot(forPath: FirebaseSession.MISSION_ENDDATE.rawValue).value as? Int ?? 0,
                                          nbPeople:  object.childSnapshot(forPath: FirebaseSession.MISSION_NBROFPEOPLE.rawValue).value as? Int ?? 0,
                                          location: object.childSnapshot(forPath: FirebaseSession.MISSION_LOCATION.rawValue).value as? String ??  "NULL",
                                          jobs: object.childSnapshot(forPath: FirebaseSession.MISSION_TYPE_JOB.rawValue).value as? String ??  "NULL")
            
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
    
    //5.-------------------------- USER --------------------------
    //****** GET USER BY ID
    static func getUserByUID(uidUser: String, completion: @escaping (User) -> Void) {
        let ref:DatabaseReference = Database.database().reference().child(FirebaseSession.user.rawValue).child(uidUser);
        ref.observe(.value, with: { (snapshot) in
            var tempUser = User(firstName: "NULL", lastName: "NULL", phone: "NULL", admin: false, email: "NULL", password: "", jobPreference: "")
            if(snapshot.childSnapshot(forPath: FirebaseSession.USER_FIRSTNAME.rawValue).value is NSNull){
                tempUser = User(firstName: "NULL", lastName: "NULL", phone: "NULL", admin: false, email: "NULL", password: "", jobPreference: "NULL")
            }
            else{
                //CREATING USER OBJECT
                tempUser = User(firstName: snapshot.childSnapshot(forPath: FirebaseSession.USER_FIRSTNAME.rawValue).value as? String ?? "NULL",
                                    lastName: snapshot.childSnapshot(forPath: FirebaseSession.USER_LASTNAME.rawValue).value as? String ?? "NULL",
                                    phone: snapshot.childSnapshot(forPath: FirebaseSession.USER_PHONE.rawValue).value as? String ?? "NULL",
                                    admin: snapshot.childSnapshot(forPath: FirebaseSession.USER_ADMIN.rawValue).value as! Bool, // NOT NECESSARY
                    email: snapshot.childSnapshot(forPath: FirebaseSession.USER_EMAIL.rawValue).value as? String ?? "NULL",
                    password: "", jobPreference: ""//NOT NECESSARY
                )
            }

            //ADDING TO LIST
            completion(tempUser)
        })
        
    }
    
    // SAVE THE JOB SELECTED BY THE USER IN THE CURRENT USER
    static func saveJobPreferenceInUser(uidUser:String, newJobPreference:String){
        // save the job in the user
        let ref:DatabaseReference = Database.database().reference().child(FirebaseSession.user.rawValue).child(uidUser).child(FirebaseSession.USER_JOBPREFERENCE.rawValue);
        // set new job preference
        ref.setValue(newJobPreference)
        
    }
    
    
    // 6.-------------------------- SUBSCRIBERS --------------------------------
    // ******* GET USER BY MISSION
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
    
    // ******** Add Subscribers to missions
    static func saveSubscribersToMission(uidUser:String, nameMission:String, nameDiscipline:String, nameCompetition:String){
        
        //set the reference to the name of the new cometition
        let ref:DatabaseReference = Database.database().reference().child(FirebaseSession.competition.rawValue).child(nameCompetition).child(FirebaseSession.NODE_DISCIPLINES.rawValue).child(nameDiscipline).child(nameMission).child(FirebaseSession.MISSION_SUBSCRIBED.rawValue);

        let newChild = ref.child(uidUser)
        newChild.setValue(false);
    }
    
    // ******* SAVE SUBSCRIBER TO SELECTED
    static func saveFinalSubscriberToMission(uidUser:String, allUidOfUsers:[String], nameMission:String, nameDiscipline:String, nameCompetition:String){
        
        //set the reference to the name of the new cometition
        let ref:DatabaseReference = Database.database().reference().child(FirebaseSession.competition.rawValue).child(nameCompetition).child(FirebaseSession.NODE_DISCIPLINES.rawValue).child(nameDiscipline).child(nameMission).child(FirebaseSession.MISSION_SELECTED.rawValue);
        
        ref.removeValue()
        
        //Add new child
        let newChild = ref.child(uidUser)
        newChild.setValue(true)
    }
    
    // ******* SAVE SUBSCRIBER TO SELECTED
    static func saveFinalSubscribersToMission(uidUsers:[String], nameMission:String, nameDiscipline:String, nameCompetition:String){
        
        //set the reference to the name of the new cometition
        let ref:DatabaseReference = Database.database().reference().child(FirebaseSession.competition.rawValue).child(nameCompetition).child(FirebaseSession.NODE_DISCIPLINES.rawValue).child(nameDiscipline).child(nameMission).child(FirebaseSession.MISSION_SELECTED.rawValue);
        
        ref.removeValue()
        
        for item in uidUsers{
            let newChild = ref.child(item)
            newChild.setValue(true)
        }
    }
    
    // ****** DELETE SUBSCRIBER
    static func deleteSubscriber(uidUser:String, nameMission:String, nameDiscipline:String, nameCompetition:String){
        
        //set the reference to the name of the new cometition
        let ref:DatabaseReference = Database.database().reference().child(FirebaseSession.competition.rawValue).child(nameCompetition).child(FirebaseSession.NODE_DISCIPLINES.rawValue).child(nameDiscipline).child(nameMission).child(FirebaseSession.MISSION_SUBSCRIBED.rawValue);
        
        let newChild = ref.child(uidUser)
        newChild.removeValue()
    }
    
    //****** CHECK SUBSCRIBER STATE
    static func checkIfAlreadySubscribed(uidUser:String, missionData: [Mission], nameDiscipline:String, nameCompetition:String, completion: @escaping ([String])-> Void){
        
        var states = [String]()
        
        for item in missionData{
            let ref:DatabaseReference = Database.database().reference().child(FirebaseSession.competition.rawValue).child(nameCompetition).child(FirebaseSession.NODE_DISCIPLINES.rawValue).child(nameDiscipline).child(item.title).child(FirebaseSession.MISSION_SUBSCRIBED.rawValue);
            ref.observe(.value, with: { (snapshot) in
                for childSnapshot in snapshot.children{
                    //Load UID
                    let tempUid:String = (childSnapshot as AnyObject).key as String
                    //Check if currentUser has an subscription
                    if(tempUid == uidUser){
                        //Identifier for mission
                        
                        states.append(item.jobs)
                    }
                    completion(states)
                }
            })
        }
    }
    
    
    //******* CHECK SUBSCRIBER FINAL SELECTED STATE
    static func checkAlreadySelected(uidUser:String, nameMission:String, nameDiscipline:String, nameCompetition:String, completion: @escaping (String)-> Void){
        let ref:DatabaseReference = Database.database().reference().child(FirebaseSession.competition.rawValue).child(nameCompetition).child(FirebaseSession.NODE_DISCIPLINES.rawValue).child(nameDiscipline).child(nameMission).child(FirebaseSession.MISSION_SELECTED.rawValue);
        
        var tempUID:String = ""
        
        ref.observe(.value, with: { (snapshot) in
            for childSnapshot in snapshot.children {
                tempUID = ((childSnapshot as AnyObject).key as String)
            }
            completion(tempUID)
        })
    }
    
    //******* CHECK SUBSCRIBER FINAL SELECTED STATE
    static func checkAlreadySelectedUsers(nameMission:String, nameDiscipline:String, nameCompetition:String, completion: @escaping ([String])-> Void){
        let ref:DatabaseReference = Database.database().reference().child(FirebaseSession.competition.rawValue).child(nameCompetition).child(FirebaseSession.NODE_DISCIPLINES.rawValue).child(nameDiscipline).child(nameMission).child(FirebaseSession.MISSION_SELECTED.rawValue);
        
        var tempUIDS = [String]()
        
        ref.observe(.value, with: { (snapshot) in
            for childSnapshot in snapshot.children {
                tempUIDS.append((childSnapshot as AnyObject).key as String)
            }
            completion(tempUIDS)
        })
    }
    
    
    //------------- ADMIN
    //**** compare numbers
    static func checkAdminNumber(inputNumber:String, result: @escaping(Bool)-> Void){
         let ref:DatabaseReference = Database.database().reference().child(FirebaseSession.admin.rawValue)
        ref.observe(.value, with: {(snapshot) in
            let tempNumber = snapshot.childSnapshot(forPath: FirebaseSession.ADMIN_CHECKNUMBER.rawValue).value as? String ?? "NULL"
            
            if(inputNumber == tempNumber){
                result(true)
            }
            else{
                result(false)
            }
        })
    }
    
    
    //**** Save generated key into firebase
    static func saveKey(key:String, date:String){
        let ref:DatabaseReference = Database.database().reference().child(FirebaseSession.admin.rawValue).child(FirebaseSession.ADMIN_CHECKNUMBER.rawValue)
        
        ref.setValue(key)
        
        let refDate:DatabaseReference = Database.database().reference().child(FirebaseSession.admin.rawValue).child(FirebaseSession.ADMIN_LASTUPDATE.rawValue)
        
        refDate.setValue(date)
    }
    
    //**** Check pw automation
    static func isNewKeyNeeded(inputDate:String, result: @escaping(Bool)-> Void){
        let ref:DatabaseReference = Database.database().reference().child(FirebaseSession.admin.rawValue)
        
        ref.observe(.value, with: {(snapshot) in
            var tempNumber = snapshot.childSnapshot(forPath: FirebaseSession.ADMIN_CHECKNUMBER.rawValue).value as! String
            if(tempNumber.suffix(2) != inputDate){
                result(true)
            }
            else{
                result(false)
            }
        })
    }
    
    //**** Get last Updated date
    static func getLastCheckNumberDate(result: @escaping(String)-> Void){
        let ref:DatabaseReference = Database.database().reference().child(FirebaseSession.admin.rawValue)
        
        ref.observe(.value, with: {(snapshot) in
            var tempDate = snapshot.childSnapshot(forPath: FirebaseSession.ADMIN_LASTUPDATE.rawValue).value as! String
            result(tempDate)
        })
    }
}
