//
//  Mission.swift
//  skirun
//
//  Created by iOS Dev on 20.03.19.
//  Copyright © 2019 hevs. All rights reserved.
//

import Foundation

class Mission {
    
    let title : String
    let description: String
    let startTime: Int
    let endTime: Int
    let nbPeople: Int
    let location: String
    let jobs: String
    var selected: [String]
    
    
    init(title: String, description: String, startTime: Int, endTime: Int, nbPeople: Int, location: String,  jobs: String) {
        self.title = title
        self.description = description
        self.startTime = startTime
        self.endTime = endTime
        self.nbPeople = nbPeople
        self.location = location
        self.jobs = jobs
        self.selected = [String]()
    }
    
    
    func toAnyObject() -> Any {
        return [
            "description": description,
            "startDateTime": startTime,
            "endDateTime": endTime,
            "nbrPeople": nbPeople,
            "location": location,
            "typeJob": jobs,
        ]
    }
    
    
    
    
}
