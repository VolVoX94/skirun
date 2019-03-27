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
    let typeJob:String
    let startTime: Int
    let endTime: Int
    let nbPeople: Int
    
    init(title: String, description: String, typeJob: String, startTime: Int, endTime: Int, nbPeople: Int) {
        self.title = title;
        self.description = description;
        self.typeJob = typeJob;
        self.startTime = startTime;
        self.endTime = endTime;
        self.nbPeople = nbPeople;
    }
    
    
    func toAnyObject() -> Any {
        return [
            "description": description,
            "typeJob":typeJob,
            "startTime": startTime,
            "endTime": endTime,
            "nbPeople": nbPeople
        ]
    }
    
    
    
    
}
