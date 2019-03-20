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
    let startTime: String
    let endTime: String
    let nbPeople: String
    
    init(title: String, description: String, startTime: String, endTime: String, nbPeople: String) {
        self.title = title;
        self.description = description;
        self.startTime = startTime;
        self.endTime = endTime;
        self.nbPeople = nbPeople;
    }
    
    
    func toAnyObject() -> Any {
        return [
            "description": description,
            "startTime": startTime,
            "endTime": endTime,
            "nbPeople": nbPeople
        ]
    }
    
    
    
    
}
