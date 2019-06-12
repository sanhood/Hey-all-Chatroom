//
//  Message.swift
//  Howdy!
//
//  Created by Danoosh Chamani on 4/3/19.
//  Copyright © 2019 Danoosh Chamani. All rights reserved.
//

import Foundation

struct Message:Decodable {
    var text: String!
    var isMe: Bool!
    var sender:String!
    var timeStamp:Double!
    var senderID:Int
    init(json: [String:Any]){
        text = json["message"] as? String ?? ""
        senderID = json["senderID"] as! Int
        isMe = (senderID == myProfile.id!) ? true : false
        sender = json["senderName"] as? String ?? "unk"
        timeStamp = json["timeStamp"] as? Double ?? 0
    }
}
