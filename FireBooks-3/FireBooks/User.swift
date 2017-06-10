//
//  User.swift
//  FireBooks
//
//  Created by NYU_SPS on 4/29/17.
//  Copyright © 2017 NYU. All rights reserved.
//

import Foundation

struct User {
    
    let uid:String
    let email:String
    init(authData:FIRUser) {
        uid = authData.uid
        email = authData.email!
    }
    init(uid:String, email:String) {
        self.uid = uid
        self.email = email
    }
}
