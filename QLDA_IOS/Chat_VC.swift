//
//  Chat_VC.swift
//  QLDA_IOS
//
//  Created by datlh on 2/17/17.
//  Copyright © 2017 datlh. All rights reserved.
//

import UIKit

class Chat_Cell: UITableViewCell{
    @IBOutlet weak var viewLeft: UIView!
    @IBOutlet weak var viewRight: UIView!
    @IBOutlet weak var lblContactName: UILabel!
    @IBOutlet weak var lblMessage: UILabel!
    
    @IBOutlet weak var lblContactNameRight: UILabel!
    @IBOutlet weak var lblMessageRight: UILabel!
}


class Chat_VC: UIViewController, UITableViewDataSource, UITableViewDelegate{
    @IBOutlet weak var btnSend: UIButton!
    @IBOutlet weak var txtMessage: UITextField!
    @IBOutlet weak var tblConversation: UITableView!
    var contactID : Int!
    var contactType : Int!
    var contactName : String!
    var service = ApiService()
    var listMessage : [ChatMessage] = [ChatMessage]()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = contactName
        //self.tblConversation.separatorStyle = UITableViewCellSeparatorStyle.none
    }   
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getMessage()
        self.tblConversation.allowsSelection = false
        //self.tblConversation.reloadData()
        //self.scrollToBottom()
    }
    
    @IBAction func btnSendTouchUpInside(_ sender: UIButton) {
        sendMessage()
    }
    
    func sendMessage(){
        if let hub = ChatHub.chatHub {
            do {
                try hub.invoke("SendPrivateMessage", arguments: [ChatHub.userID, ChatHub.userName, contactID, contactName, txtMessage.text!])
            } catch {
                print(error)
            }
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : Chat_Cell = tableView.dequeueReusableCell(withIdentifier: "cellChat") as! Chat_Cell
        let msg : ChatMessage = listMessage[indexPath.row]

        if(msg.IsMe!){
            cell.viewLeft.isHidden = true
            cell.viewRight.isHidden = false
            cell.lblContactNameRight.text = msg.SenderName
            cell.lblMessageRight.text = msg.Message
            //cell.lblMessageRight.sizeToFit()
        }else{
            cell.viewLeft.isHidden = false
            cell.viewRight.isHidden = true
            cell.lblContactName.text = msg.SenderName
            cell.lblMessage.text = msg.Message
            //cell.lblMessage.sizeToFit()
        }
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {        
        return listMessage.count;
    }
    /*
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
         return UITableViewAutomaticDimension
    }*/

    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        //return UITableViewAutomaticDimension
        
        let cell : Chat_Cell = tableView.dequeueReusableCell(withIdentifier: "cellChat") as! Chat_Cell
        let msg : ChatMessage = listMessage[indexPath.row]
        let stringSizeAsText: CGSize = getStringSizeForFont(font: UIFont.systemFont(ofSize: 16), myText: msg.Message!)
        
        var labelWidth: CGFloat
        if(msg.IsMe!){
            labelWidth = cell.lblMessageRight.frame.width
        }
        else{
            labelWidth = cell.lblMessage.frame.width
        }        
        
        //let originalLabelHeight: CGFloat = cell.lblMessage.frame.height
        
        let labelLines: CGFloat = CGFloat(ceil(Float(stringSizeAsText.width/labelWidth)))
        
        //let height =  tableView.rowHeight - originalLabelHeight + CGFloat(labelLines*stringSizeAsText.height)
        let height = CGFloat(labelLines * (stringSizeAsText.height + 3))
        return height + 17
 
    }
 
    func getStringSizeForFont(font: UIFont, myText: String) -> CGSize {
        let fontAttributes = [NSFontAttributeName: font]
        let size = (myText as NSString).size(attributes: fontAttributes)
        
        return size
        
    }
    
    func getMessage(){
        if contactType == 1 {
            let apiUrl : String = "\(UrlPreFix.Chat.rawValue)/Chat_GetPrivateMessage?senderID=\(ChatHub.userID)&receiverID=\(String(contactID))"
            print(apiUrl)
            ApiService.Get(url: apiUrl, callback: callbackGetMsg, errorCallBack: errorGetMsg)
        }
        else{
            
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
                
                listMessage.append(msg)
            }
        }
        
        DispatchQueue.main.async() { () -> Void in
            self.tblConversation.reloadData()
            self.scrollToBottom()
        }
    }
    
    func errorGetMsg(error : Error) {
        let message = error.localizedDescription
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func scrollToBottom(){
        DispatchQueue.global(qos: .background).async {
            let indexPath = IndexPath(row: self.listMessage.count-1, section: 0)
            self.tblConversation.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }
    }
}
