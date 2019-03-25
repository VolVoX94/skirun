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
    
    //Competiontion nodes
    case NODE_ENDDATE = "endDate";
    case NODE_REFAPI = "refAPI";
    case NODE_STARTDATE = "startDate";
    case NODE_GUESTCLUBS = "guestClubs";
    case NODE_DISCIPLINES = "disciplines";
    
}
