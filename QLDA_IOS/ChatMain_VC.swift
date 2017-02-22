//
//  Chat_VC.swift
//  QLDA_IOS
//
//  Created by datlh on 2/17/17.
//  Copyright © 2017 datlh. All rights reserved.
//

import UIKit
import SwiftR

class ChatMain_VC: Base_VC , UITableViewDataSource, UITableViewDelegate{

    @IBOutlet weak var aivLoad: UIActivityIndicatorView!
    @IBOutlet weak var tblListContact: UITableView!
    @IBOutlet weak var txtText: UITextField!
    var service = ApiService()
    
    var arrayMenu = [Dictionary<String,String>]()
    var listContact = [UserContact]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ChatHub.initChatHub()
        initEnvetChatHub()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        aivLoad.startAnimating()
        tblListContact.isHidden = true
        getContacts()
    }

    @IBAction func goToChat(_ sender: Any) {
        //let vc = storyboard?.instantiateViewController(withIdentifier: "Chat") as! Chat_VC
        //self.navigationController?.pushViewController(vc, animated: true)
        //vc.passData = "122"
    }
    
    func getContacts(){
        listContact = [UserContact]()
        let apiUrl : String = "\(UrlPreFix.Chat.rawValue)/Chat_Getcontacts/\(ChatHub.userID)"
        service.Get(url: apiUrl, callback: alert, errorCallBack: alertError)
    }
    
    
    func alert(data : Data) {
        //let result = String(data: data, encoding: String.Encoding.utf8)
        let json = try? JSONSerialization.jsonObject(with: data, options: [])
        
        if let dic = json as? [[String:Any]] {
            for item in dic{
                let contact = UserContact()
                contact.ContactID =  item["ContactID"] as? Int
                //contact.TimeOfLatestMessage = item["TimeOfLatestMessage"] as! Date
                contact.LatestMessage = item["LatestMessage"] as? String
                contact.LatestMessageID = item["LatestMessageID"] as? Int64
                contact.LoginName = item["LoginName"] as? String
                contact.Name = item["Name"] as? String
                contact.NumberOfNewMessage = item["NumberOfNewMessage"] as? Int
                contact.Online = item["Online"] as? Bool
                contact.PictureUrl = item["PictureUrl"] as? String
                contact.setPicture()
                //contact.Picture = Common.setImageFromURl(url: contact.PictureUrl!)
                contact.ReceiverOfMessage = item["ReceiverOfMessage"] as? Int
                contact.SenderOfMessage = item["SenderOfMessage"] as? Int
                contact.TypeOfContact = item["TypeOfContact"] as? Int
                contact.TypeOfMessage = item["TypeOfMessage"] as? Int
                
                listContact.append(contact)
            }
        }
        //DispatchQueue.global(qos: .userInitiated).async {
            //DispatchQueue.main.async {
                //self.tblListContact.reloadData()
            //}
        //}
        
        DispatchQueue.main.async() { () -> Void in
            self.aivLoad.isHidden = true
            self.tblListContact.isHidden = false
            self.tblListContact.reloadData()
        }
    }
    
    func alertError(error : Error) {
        let message = error.localizedDescription
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cellContact")!
        let contact : UserContact = listContact[indexPath.row]
        //cell.textLabel?.text = listContact[indexPath.row].Name
        
        let imgContact : UIImageView = cell.contentView.viewWithTag(100) as! UIImageView
        let lblContactName : UILabel = cell.contentView.viewWithTag(101) as! UILabel
        let lblLastMessage : UILabel = cell.contentView.viewWithTag(102) as! UILabel
        
        imgContact.image = contact.Picture
        lblContactName.text = contact.Name
        lblLastMessage.text = contact.LatestMessage
        return cell
    }
    var valueToPass:String!
    var valueToPass2:String!
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let index = Int(indexPath.row)
        
        let indexPath = tableView.indexPathForSelectedRow!
        let currentCell = tableView.cellForRow(at: indexPath)! as UITableViewCell
        
        valueToPass = currentCell.textLabel?.text
        valueToPass2 = listContact[index].PictureUrl
        performSegue(withIdentifier: "GoToChat", sender: self)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listContact.count
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "GoToChat") {
            if let gtChat = segue.destination as? Chat_VC{
                gtChat.passData = valueToPass
                gtChat.pictureUrl = valueToPass2
            }

        }
    }

    
    // Chat hub
    
    func initEnvetChatHub(){
        ChatHub.chatHub.on("receivePrivateMessage") {args in
            var sender = args?[0] as? [Any]
            let receiver = args?[1] as? [Any]
            let inbox = args?[2] as? [Any]           
            
            let senderID = (sender![0] as? Int)!
            let senderName = (sender![1] as? String)!
            let receiverID = (receiver![0] as? Int)!
            let receiverName = (receiver![1] as? String)
            let msg = (inbox![0] as? String)!
            let msgType = (inbox![1] as? Int)!
            let inboxID = (inbox![2] as? Int64)
        }
    }
    
}
