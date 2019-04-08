//
//  Competition.swift
//  skirun
//
//  Created by Admin on 20.03.19.
//  Copyright © 2019 hevs. All rights reserved.
//

import UIKit

class Competition {

    var name: String
    var startDateTime: Int
    var endDateTime: Int
    var guestClub: String
    var refAPI: String //Open for extension
    var discipline: String
    
    init(name: String, startDateTime: Int, endDateTime: Int, refAPI: String) {
        self.name = name;
        self.startDateTime = startDateTime;
        self.endDateTime = endDateTime;
        self.refAPI = refAPI;
        self.guestClub = "";
        self.discipline = "";
    }
    
    
    func toAnyObject() -> Any {
        return [
            "startDate" : startDateTime,
            "endDate": endDateTime,
            "refAPI": refAPI,
        ]
    }

}
