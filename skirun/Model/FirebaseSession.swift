//
//  FirebaseSession.swift
//  skirun
//
//  Created by Admin on 13.03.19.
//  Copyright © 2019 hevs. All rights reserved.
//

import Foundation

enum FirebaseSession:String {
    case user = "usersV2"
    case competition = "competitionsV2"
    case discipline = "disciplinesV2"
    case club = "clubsV2"
    case jobType = "typeJobsV2"
    case results = "results"
    case admin = "adminV2"
    
    //Competiontion nodes
    case NODE_ENDDATE = "endDate";
    case NODE_REFAPI = "refAPI";
    case NODE_STARTDATE = "startDate";
    case NODE_GUESTCLUBS = "guestClubs";
    case NODE_DISCIPLINES = "disciplines";
    
    //Mission nodes
    case MISSION_DESCRIPTION = "description";
    case MISSION_LOCATION = "location";
    case MISSION_ENDDATE = "endDateTime";
    case MISSION_NBROFPEOPLE = "nbrPeople";
    case MISSION_RESULT_BY_BIB = "resultsByBibNumber";
    case MISSION_SELECTED = "selected";
    case MISSION_STARTDATE = "startDateTime";
    case MISSION_SUBSCRIBED = "subscribed";
    case MISSION_TYPE_JOB = "typeJob";
    
    //User nodes
    case USER_FIRSTNAME = "firstName";
    case USER_EMAIL = "email";
    case USER_LASTNAME = "lastName";
    case USER_PHONE = "phone";
    case USER_JOBPREFERENCE = "jobPreference";
    case USER_ADMIN = "admin";
    
    //Admin nodes
    case ADMIN_CHECKNUMBER = "checkNumber";
    case ADMIN_LASTUPDATE = "lastUpdate";
}
