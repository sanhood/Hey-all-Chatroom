//
//  Profile.swift
//  Howdy!
//
//  Created by Danoosh Chamani on 5/9/19.
//  Copyright © 2019 Danoosh Chamani. All rights reserved.
//

import Foundation

struct Profile {
    var id: Int!
    var email: String!
    var nickName: String?
    var token: String!
    var firstName:String?
    var lastName:String?
    var bio:String?
    var friendList:[Profile]?
    var status:Bool!
    func toDictionary() -> [String:Any] {
        var dict = [String:Any]()
        if firstName != nil {
            dict["firstName"] = firstName!
        }
        if lastName != nil {
            dict["lastName"] = lastName!
        }
        if bio != nil {
            dict["bio"] = bio!
        }
        if nickName != nil {
            dict["nickName"] = nickName!
        }
        return dict
    }
    
    func save() {
        UserDefaults.standard.setValue(token, forKey: "token")
        UserDefaults.standard.setValue(id, forKey: "id")
        UserDefaults.standard.setValue(nickName, forKey: "nickName")
        UserDefaults.standard.setValue(email, forKey: "email")
        UserDefaults.standard.setValue(firstName, forKey: "firstName")
        UserDefaults.standard.setValue(lastName, forKey: "lastName")
        UserDefaults.standard.setValue(bio, forKey: "bio")
        UserDefaults.standard.synchronize()
    }
    
    mutating func load(){
        nickName =  UserDefaults.standard.value(forKey: "nickName") as? String
        id = UserDefaults.standard.value(forKey: "id") as? Int
        email = UserDefaults.standard.value(forKey: "email") as? String
        token = UserDefaults.standard.value(forKey: "token") as? String
        firstName = UserDefaults.standard.value(forKey: "firstName") as? String
        lastName = UserDefaults.standard.value(forKey: "lastName") as? String
        bio = UserDefaults.standard.value(forKey: "bio") as? String
    }
    
    
}
