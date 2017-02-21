//
//  UserContact.swift
//  QLDA_IOS
//
//  Created by datlh on 2/21/17.
//  Copyright © 2017 datlh. All rights reserved.
//

import Foundation
class UserContact{
    
    init() {
        ContactID = 0
        Name = ""
        LoginName = ""
        PictureUrl = ""
        LatestMessage = ""
        LatestMessageID = 0
        TimeOfLatestMessage = Date()
        TypeOfContact = 1
        TypeOfMessage = 1
        Online = false
        SenderOfMessage = 0
        ReceiverOfMessage = 0
        NumberOfNewMessage = 0
    }
    
    var ContactID : Int?
    var Name : String?
    var LoginName : String?
    var PictureUrl : String?
    var LatestMessage : String?
    var LatestMessageID : Int64?
    var TimeOfLatestMessage : Date?
    var TypeOfContact : Int?
    var TypeOfMessage : Int?
    var Online : Bool?
    var SenderOfMessage : Int?
    var ReceiverOfMessage : Int?
    var NumberOfNewMessage: Int?
}
