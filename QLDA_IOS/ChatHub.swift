//
//  ChatHub.swift
//  QLDA_IOS
//
//  Created by datlh on 2/21/17.
//  Copyright © 2017 datlh. All rights reserved.
//

import Foundation
import SwiftR
import UserNotifications

class ChatHub {
    static var chatHub: Hub!
    static var connection: SignalR!
    static var userID = 59
    static var userName = "demo2"
    
    static func addChatHub(hub : Hub){
        connection.addHub(hub)
        connection.connect()
    }
    
    static func initChatHub(){
        connection = SignalR("http://harmonysoft.vn:8089/QLDA_Services/")
        //connection.useWKWebView = true
        connection.signalRVersion = .v2_2_0
        
        chatHub = Hub("chatHub")
        /*
        chatHub.on("receivePrivateMessage") {
            if let name = args?[0] as? String, let message = args?[1] as? String{
                print("Connection ID\(name + message)")
            }
        }*/
        connection.addHub(chatHub)
        
        // SignalR events
        
        connection.starting = {
            //print("Connection ID")
        }
        
        connection.reconnecting = {
            //print("Connection ID")
        }
        
        connection.connected = {
            //print("Connection ID")
            //DispatchQueue.main.async() { () -> Void in
            ChatHub.conect()
            //}
        }
        
        connection.reconnected = {
            //print("Connection ID")
        }
        
        connection.disconnected = {
            //print("Connection ID")
        }
        
        connection.connectionSlow = {
            //print("Connection slow...")
        }
        

        
        connection.start()
        
    }
    static func conect(){
        if let hub = chatHub {
            do {
                try hub.invoke("Connect", arguments: [userID, userName])
            } catch {
                //print(error)
            }
        }
    }
    
    static func initEvent(){
        chatHub.on("onConnected"){args in
            let userID = args?[0] as? Int
            ChatCommon.listContact.filter() {
                let contact = $0 as UserContact
                if contact.ContactID == userID && contact.TypeOfContact == 1{
                    return true
                }
                return false
            }.first?.Online = true
            
        }
        
        chatHub.on("onDisconnected"){args in
            let userID = args?[0] as? Int
            ChatCommon.listContact.filter() {
                let contact = $0 as UserContact
                if contact.ContactID == userID && contact.TypeOfContact == 1{
                    return true
                }
                return false
                }.first?.Online = false
            
        }
        
        chatHub.on("receivePrivateMessage") {args in
            let sender = args?[0] as? [Any]
            let receiver = args?[1] as? [Any]
            let inbox = args?[2] as? [Any]
            
            let senderID = (sender![0] as? Int)!
            let senderName = (sender![1] as? String)!
            let receiverID = (receiver![0] as? Int)!
            let receiverName = (receiver![1] as? String)!
            let msg = (inbox![0] as? String)!
            let msgType = (inbox![1] as? Int)!
            let inboxID = (inbox![2] as? Int64)!
            
            changeDataWhenReciveMessage(inboxID: inboxID, message: msg, messageType: msgType, senderID: senderID, senderName: senderName, receiverID: receiverID, receiverName: receiverName, contactType: 1)
        }
        
        chatHub.on("receiveGroupMessage") {args in
            
            let sender = args?[0] as? [Any]
            let receiver = args?[1] as? [Any]
            let inbox = args?[2] as? [Any]
            
            let senderID = (sender![0] as? Int)!
            let senderName = (sender![1] as? String)!
            let receiverID = (receiver![0] as? Int)!
            let receiverName = (receiver![1] as? String)!
            let msg = (inbox![0] as? String)!
            let msgType = (inbox![1] as? Int)!
            let inboxID = (inbox![2] as? Int64)!
            
            changeDataWhenReciveMessage(inboxID: inboxID, message: msg, messageType: msgType, senderID: senderID, senderName: senderName, receiverID: receiverID, receiverName: receiverName, contactType: 2)
        }
        
        chatHub.on("receiveChatGroup") {args in
            var groupID : Int = 0
            var host : Int = 0
            var groupName : String = ""
            var pictureUrl : String = ""
            if let temp = args?[0] as? Int{
                 groupID = temp
            }
            if let temp = args?[1] as? String{
                groupName = temp
            }
            
            if let temp = args?[2] as? Int{
                host = temp
            }
            if let temp = args?[3] as? String{
                pictureUrl = temp
            }
            print(groupID, groupName, host, pictureUrl)
            let newContact : UserContact = UserContact()
            newContact.ContactID = groupID
            if(host == ChatHub.userID){
                newContact.LatestMessage = "Bạn vừa tạo nhóm"
            }
            else{
                newContact.LatestMessage = "Bạn vừa được thêm vào nhóm"
            }
            newContact.LatestMessageID = 0
            newContact.LoginName = ""
            newContact.Name = groupName
            newContact.NumberOfNewMessage = 1
            newContact.Online = false
            newContact.PictureUrl = pictureUrl
            newContact.ReceiverOfMessage = groupID
            newContact.SenderOfMessage = 0
            newContact.TypeOfContact = 2
            newContact.TypeOfMessage = 0
            newContact.setPicture()
            ChatCommon.listContact.insert(newContact, at: 0)
        }
    }
    static func changeDataWhenReciveMessage(inboxID : Int64, message : String, messageType : Int, senderID : Int, senderName : String,  receiverID : Int, receiverName : String, contactType : Int){
        
        var contactID : Int
        if(contactType == 2){
            contactID = receiverID
        }
        else{
            contactID = senderID
            if senderID == ChatHub.userID{
                contactID = receiverID
            }
        }

        let filter = ChatCommon.listContact.filter(){
            if $0.ContactID == contactID && $0.TypeOfContact == contactType{
                return true
            }
            return false
        }
        var newContact : UserContact
        if filter.count == 0{
            newContact = UserContact()
            newContact.ContactID = contactID
            newContact.Name = senderName
            newContact.LatestMessage = message
            newContact.TypeOfContact = contactType
            newContact.SenderOfMessage = senderID
            newContact.ReceiverOfMessage = receiverID
            newContact.TypeOfMessage = messageType
            newContact.NumberOfNewMessage = 1
            newContact.LatestMessageID = inboxID
        }
        else{
            newContact = filter.first!
       
            newContact.LatestMessage = message
            newContact.SenderOfMessage = senderID;
            newContact.ReceiverOfMessage = receiverID
            newContact.TypeOfMessage = messageType;
            newContact.NumberOfNewMessage = newContact.NumberOfNewMessage! + 1
            /*
            if senderID == ChatHub.userID{
                newContact.NumberOfNewMessage = 0;
            }
            else{
                newContact.NumberOfNewMessage = 0;
            }*/
            newContact.LatestMessageID = inboxID;
            ChatCommon.listContact = ChatCommon.listContact.filter() { $0.ContactID != contactID || $0.TypeOfContact != contactType}
        }
        ChatCommon.listContact.insert(newContact, at: 0)
        notification()
    }
    
    static func notification(){
        let content = UNMutableNotificationContent()
        content.title = "Thông báo"
        content.subtitle = "subsite"
        content.body = "Đây là thông báo"
        content.badge = 1
        
        let request = UNNotificationRequest(identifier: "test", content: content, trigger: nil)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
}
