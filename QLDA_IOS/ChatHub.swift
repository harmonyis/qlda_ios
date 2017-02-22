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
            print("Connection ID")
        }
        
        connection.reconnecting = {
            print("Connection ID")
        }
        
        connection.connected = {
            print("Connection ID")
            //DispatchQueue.main.async() { () -> Void in
            ChatHub.conect()
            //}
        }
        
        connection.reconnected = {
            print("Connection ID")
        }
        
        connection.disconnected = {
            print("Connection ID")
        }
        
        connection.connectionSlow = { print("Connection slow...") }
        

        
        connection.start()
        
    }
    static func conect(){
        if let hub = chatHub {
            do {
                try hub.invoke("Connect", arguments: [59, "demo2"])
            } catch {
                print(error)
            }
        }
    }
}
