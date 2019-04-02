//
//  Result.swift
//  skirun
//
//  Created by AISLAB on 02.04.19.
//  Copyright © 2019 hevs. All rights reserved.
//

import Foundation


class Result {
    
    var number: String
    var result: String
    var status: String

    
    init(number: String, result: String) {
        self.number = number
        self.result = result
        self.status = "accepted"
    }
    
    
    func toAnyObject() -> Any {
        return [
            "result": result,
            "status": status,
        ]
    }
    
}
