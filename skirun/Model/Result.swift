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
    var unit: String

    
    init(number: String, result: String, unit: String) {
        self.number = number
        self.result = result
        self.unit = unit
    }
    
    
    func toAnyObject() -> Any {
        return [
            "result": result,
            "unit": unit,
        ]
    }
    
}
