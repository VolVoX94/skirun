//
//  Competition.swift
//  skirun
//
//  Created by Admin on 20.03.19.
//  Copyright © 2019 hevs. All rights reserved.
//

import UIKit

class Competition {

    let name: String
    let startDateTime: Date
    let endDateTime: Date
    let guestClub: String
    let refAPI: String //Open for extension
    let discipline: String
    
    init(name: String, startDateTime: Date, endDateTime: Date, guestClub: String, refAPI: String, discipline: String) {
        self.name = name;
        self.startDateTime = startDateTime;
        self.endDateTime = endDateTime;
        self.guestClub = guestClub;
        self.refAPI = refAPI;
        self.discipline = discipline;
    }
    
    
    func toAnyObject() -> Any {
        return [
            "name": name,
            "startDateTime": startDateTime,
            "endDateTime": endDateTime,
            "guestClub": guestClub,
            "refAPI": refAPI,
            "discipline": discipline
        ]
    }

}
