//
//  Chat_VC.swift
//  QLDA_IOS
//
//  Created by datlh on 2/17/17.
//  Copyright © 2017 datlh. All rights reserved.
//

import UIKit
import SwiftR

class Chat_VC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    fileprivate let cellId = "cellId"
    @IBOutlet weak var txtMessage: UITextField!
    var messages: [ChatMessage] = [ChatMessage]()
    var contactID : Int!
    var contactType : Int!
    var contactName : String!
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = contactName
        ChatHub.addChatHub(hub: ChatHub.chatHub)
        self.initEnvetChatHub()
        collectionView.backgroundColor = UIColor.white
        collectionView.register(Chat2_Cell.self, forCellWithReuseIdentifier: cellId)
        getMessage()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        collectionView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        return messages.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! Chat2_Cell
        let msg = messages[indexPath.item]
        
        cell.messageTextView.text = msg.Message
        //cell.profileImageView.image = #imageLiteral(resourceName: "ic_contactUser")
        
        if let messageText = msg.Message {
            
            //cell.profileImageView.image = UIImage(named: profileImageName)
            
            let w : Int = Int(view.frame.width * 7 / 10)
            let size = CGSize(width: w, height: 1000)
            let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
            let estimatedFrame = NSString(string: messageText).boundingRect(with: size, options: options, attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 16)], context: nil)
            
            if (msg.IsMe)!{
                cell.messageTextView.frame = CGRect(x: view.frame.width - estimatedFrame.width - 8 - 8 - 8, y: 0, width: estimatedFrame.width + 16, height: estimatedFrame.height + 20)
                
                cell.textBubbleView.frame = CGRect(x: view.frame.width - estimatedFrame.width - 16 - 8 - 8, y: 0, width: estimatedFrame.width + 16 + 8, height: estimatedFrame.height + 20)
                
                //cell.profileImageView.isHidden = true
                
                cell.textBubbleView.backgroundColor = UIColor(red: 0, green: 137/255, blue: 249/255, alpha: 1)
                //cell.bubbleImageView.image = ChatLogMessageCell.blueBubbleImage
                //cell.bubbleImageView.tintColor = UIColor(red: 0, green: 137/255, blue: 249/255, alpha: 1)
                cell.messageTextView.textColor = UIColor.white
                
            } else {
                cell.messageTextView.frame = CGRect(x: 8 + 4, y: 0, width: estimatedFrame.width + 16, height: estimatedFrame.height + 20)
                
                cell.textBubbleView.frame = CGRect(x: 4, y: 0, width: estimatedFrame.width + 8 + 8 + 16, height: estimatedFrame.height + 20)
                
               // cell.profileImageView.isHidden = false
                
                cell.textBubbleView.backgroundColor = UIColor(white: 0.95, alpha: 1)
                //cell.bubbleImageView.image = ChatLogMessageCell.grayBubbleImage
                //cell.bubbleImageView.tintColor = UIColor(white: 0.95, alpha: 1)
                cell.messageTextView.textColor = UIColor.black
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let w : Int = Int(view.frame.width * 7 / 10)
        if let messageText = messages[indexPath.item].Message {
            let size = CGSize(width: w, height: 1000)
            let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
            let estimatedFrame = NSString(string: messageText).boundingRect(with: size, options: options, attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 16)], context: nil)
            
            return CGSize(width: view.frame.width, height: estimatedFrame.height + 20)
        }
        
        return CGSize(width: w, height: 100)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(8, 0, 0, 0)
    }
    
    func getMessage(){
        print("data: ", contactID, contactName, contactType)
        if contactType == 1 {
            let apiUrl : String = "\(UrlPreFix.Chat.rawValue)/Chat_GetPrivateMessage?senderID=\(ChatHub.userID)&receiverID=\(String(contactID))"
            ApiService.Get(url: apiUrl, callback: callbackGetMsg, errorCallBack: errorGetMsg)
        }
        else{
            let apiUrl : String = "\(UrlPreFix.Chat.rawValue)/Chat_GetGroupMessage/\(String(contactID))"
            ApiService.Get(url: apiUrl, callback: callbackGetMsg, errorCallBack: errorGetMsg)
        }
    }
    func callbackGetMsg(data : Data) {
        let json = try? JSONSerialization.jsonObject(with: data, options: [])
        if let dic = json as? [[String:Any]] {
            for item in dic{
                let msg = ChatMessage()
                msg.ID =  item["InboxID"] as? Int64
                msg.Message = item["Message"] as? String
                msg.MessageType = item["TypeMessage"] as? Int
                msg.ContactType = item["Type"] as? Int
                msg.SenderID = item["SenderID"] as? Int
                if msg.SenderID == ChatHub.userID {
                    msg.IsMe = true
                    msg.SenderName = ChatHub.userName
                }
                else{
                    msg.IsMe = false
                    msg.SenderName = ChatCommon.listContact.filter(){
                        if(msg.ContactType == $0.TypeOfContact && msg.SenderID == $0.ContactID){
                            return true
                        }else{
                            return false
                        }
                        }.first?.Name
                }
                msg.Created = Date(jsonDate: item["Created"] as! String)
                messages.append(msg)
            }
        }
        
        DispatchQueue.main.async() { () -> Void in
            self.collectionView.reloadData()
            self.scrollToBottom(animate: false)
        }
    }
    
    func errorGetMsg(error : Error) {
        let message = error.localizedDescription
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func sendMessage(){
        do {
            var funcName = "SendPrivateMessage"
            if(contactType == 2){
                funcName = "SendGroupMessage"
            }
            //print(ChatHub.userID, ChatHub.userName, contactID, contactName, txtMessage.text!)
            try ChatHub.chatHub.invoke(funcName, arguments: [ChatHub.userID, ChatHub.userName, contactID, contactName, txtMessage.text!])
            txtMessage.text = ""
        } catch {
            print(error)
        }
    }
    
    @IBAction func btnSendTouchUpInside(_ sender: UIButton) {
         sendMessage()
    }
    
    func initEnvetChatHub(){
        if contactType == 1{
            ChatHub.chatHub.on("receivePrivateMessage") { args in
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
                
                self.receiveMessage(senderID: senderID, senderName: senderName, receiverID: receiverID, receiverName: receiverName, message: msg, messageType: msgType, inboxID: inboxID, contactType: 1)
                
                DispatchQueue.global(qos: .userInitiated).async {
                    DispatchQueue.main.async {
                        self.collectionView.reloadData()
                        self.scrollToBottom(animate: true)
                    }
                }
            }
        }
        else{
            ChatHub.chatHub.on("receiveGroupMessage") {args in
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
                
                self.receiveMessage(senderID: senderID, senderName: senderName, receiverID: receiverID, receiverName: receiverName, message: msg, messageType: msgType, inboxID: inboxID, contactType: 2)
                
                DispatchQueue.global(qos: .userInitiated).async {
                    DispatchQueue.main.async {
                        self.collectionView.reloadData()
                        self.scrollToBottom(animate: true)
                    }
                }
            }
        }
    }
    
    func receiveMessage(senderID : Int, senderName : String, receiverID : Int, receiverName : String, message : String, messageType : Int, inboxID : Int64, contactType : Int){
        let newChat : ChatMessage = ChatMessage()
        newChat.ContactType = contactType
        newChat.ID = inboxID
        if ChatHub.userID == senderID{
            newChat.IsMe = true
        }
        else {
            newChat.IsMe = false
        }
        newChat.Message = message
        newChat.MessageType = messageType
        newChat.SenderID = senderID
        newChat.SenderName = senderName
        messages.append(newChat)
    }
    
    
    func scrollToBottom(animate : Bool){
        if(self.messages.count > 0){
            let indexPath = IndexPath(row: self.messages.count - 1, section: 0)
            self.collectionView.scrollToItem(at: indexPath, at: .bottom, animated: animate)
            //self.tblConversation.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }
    }
}

class Chat2_Cell: BaseCell2 {
    
    let messageTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.text = "Sample message"
        textView.backgroundColor = UIColor.clear
        return textView
    }()
    
    let textBubbleView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.95, alpha: 1)
        view.layer.cornerRadius = 15
        view.layer.masksToBounds = true
        return view
    }()
    
    override func setupViews() {
        super.setupViews()
        addSubview(textBubbleView)
        addSubview(messageTextView)
    }
    
}

class BaseCell2: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
    }
}
