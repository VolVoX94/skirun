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
    let discipline: String
    let jobs: String
    
    
    init(title: String, description: String, startTime: Int, endTime: Int, nbPeople: Int, location: String, discipline: String, jobs: String) {
        self.title = title;
        self.description = description;
        self.startTime = startTime;
        self.endTime = endTime;
        self.nbPeople = nbPeople;
        self.location = location;
        self.discipline = discipline;
        self.jobs = jobs;
    }
    
    
    func toAnyObject() -> Any {
        return [
            "description": description,
            "startTime": startTime,
            "endTime": endTime,
            "nbPeople": nbPeople,
            "location": location,
            "discipline": discipline,
            "jobs": jobs,
        ]
    }
    
    
    
    
}
