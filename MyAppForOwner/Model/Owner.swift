//
//  Owner.swift
//  MyAppForOwner
//
//  Created by 阿揆 on 2021/3/6.
//

import Foundation

struct Owner: Codable, Identifiable {
    
    var id: String
    var name: String
    var location: String
    var email: String
    var phoneNumber: String
    var pic: [String]
    var about: String
    var type: String
    
    
//    init(id: String, name: String, location: String, email: String, phoneNumber: String, pic: [String], about: String, type: String) {
//        self.id = ""
//        self.name = ""
//        self.location = ""
//        self.email = ""
//        self.phoneNumber = ""
//        self.pic = [String]()
//        self.about = ""
//        self.type = ""
//    }
    
}
