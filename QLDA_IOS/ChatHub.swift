//
//  ChatHub.swift
//  QLDA_IOS
//
//  Created by datlh on 2/21/17.
//  Copyright © 2017 datlh. All rights reserved.
//

import Foundation
import SwiftR

class ChatHub {
    static var chatHub: Hub!
    static var connection: SignalR!
    static var userID = 59
    static var userName = "demo2"
    
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
        chatHub.on("receivePrivateMessage") {args in
            if let name = args?[0] as? String, let message = args?[1] as? String{
                print("Connection ID\(name + message)")
            }
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
            var newContact : UserContact = UserContact() 
            newContact.ContactID = groupID
            newContact.LatestMessage = "Bạn vừa tạo nhóm"
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
            ChatCommon.listContact.append(newContact)
           // print(groupID, groupName, host, pictureUrl)

        }
    }
}
