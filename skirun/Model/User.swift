//
//  User.swift
//  skirun
//
//  Created by Admin on 13.03.19.
//  Copyright © 2019 hevs. All rights reserved.
//

import Foundation

class User {
    
    
    let firstName: String
    let lastName: String
    let email: String
    let phone: String
    let admin: Bool
    let password: String
    
    init(firstName: String, lastName: String, phone: String, admin: Bool, email: String, password: String) {
        self.firstName = firstName;
        self.lastName = lastName;
        self.email = email;
        self.phone = phone;
        self.admin = admin;
        self.password = password;
    }
    
    
    func toAnyObject() -> Any {
        return [
            "firstName": firstName,
            "lastName": lastName,
            "email": email,
            "phone": phone,
            "admin": admin
        ]
    }
}
