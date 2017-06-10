//
//  Book.swift
//  FireBooks
//
//  Created by NYU_SPS on 4/29/17.
//  Copyright © 2017 NYU. All rights reserved.
//

import Foundation

struct Book {
    
    let key:String
    let name:String
    let author:String
    let ref: FIRDatabaseReference?
    
    init(name:String, author:String) {
        self.key = ""
        self.name = name
        self.author = author
        self.ref = nil
    }
    init(snapshot:FIRDataSnapshot) {
        key = snapshot.key
        ref = snapshot.ref
        let value = snapshot.value as! [String:AnyObject]
        name = value["name"] as! String
        author = value["author"] as! String
    }
    
    func toAnyObject() -> Any {
        return [
        "name":name,
        "author":author
        ]
    }
}
