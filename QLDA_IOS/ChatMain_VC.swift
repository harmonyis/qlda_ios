//
//  Chat_VC.swift
//  QLDA_IOS
//
//  Created by datlh on 2/17/17.
//  Copyright © 2017 datlh. All rights reserved.
//

import UIKit
import SwiftR

class ChatMain_VC: Base_VC , UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate{
    @IBOutlet weak var btnCreateGroup: UIButton!
    
    @IBOutlet weak var aivLoad: UIActivityIndicatorView!
    @IBOutlet weak var tblListContact: UITableView!
    @IBOutlet weak var txtText: UITextField!
    //var service = ApiService()
    
    @IBOutlet weak var searchContact: UISearchBar!
    var arrayMenu = [Dictionary<String,String>]()
    var listContact = [UserContact]()
    
    var passContactID:Int!
    var passContactType:Int!
    
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
        //Remove empty cell
        tblListContact.tableFooterView = UIView(frame: .zero)
        self.searchContact.isUserInteractionEnabled = false
        btnCreateGroup.layer.cornerRadius = 25
        //var img : UIImage = #imageLiteral(resourceName: "ic_createGroup")
        //img.resizingMode
        btnCreateGroup.setImage(#imageLiteral(resourceName: "ic_createGroup"), for: UIControlState.normal)
        btnCreateGroup.imageEdgeInsets = UIEdgeInsetsMake(40,40,40,40)
        if(ChatCommon.listContact.count == 0){
              getContacts()
        }
        else{
            self.listContact = ChatCommon.listContact
            self.aivLoad.isHidden = true
            self.tblListContact.isHidden = false
            self.tblListContact.reloadData()
            self.searchContact.isUserInteractionEnabled = true
        }
    }
    
    @IBAction func goToChat(_ sender: Any) {
        //let vc = storyboard?.instantiateViewController(withIdentifier: "Chat") as! Chat_VC
        //self.navigationController?.pushViewController(vc, animated: true)
        //vc.passData = "122"
    }
    
    func getContacts(){
        listContact = [UserContact]()
        let apiUrl : String = "\(UrlPreFix.Chat.rawValue)/Chat_Getcontacts/\(ChatHub.userID)"
        ApiService.Get(url: apiUrl, callback: alert, errorCallBack: alertError)
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
                contact.ReceiverOfMessage = item["ReceiverOfMessage"] as? Int
                contact.SenderOfMessage = item["SenderOfMessage"] as? Int
                contact.TypeOfContact = item["TypeOfContact"] as? Int
                contact.TypeOfMessage = item["TypeOfMessage"] as? Int
                
                listContact.append(contact)
            }
        }
        
        ChatCommon.listContact = listContact
        
        //DispatchQueue.global(qos: .userInitiated).async {
        //DispatchQueue.main.async {
        //self.tblListContact.reloadData()
        //}
        //}
        
        DispatchQueue.main.async() { () -> Void in
            self.aivLoad.isHidden = true
            self.tblListContact.isHidden = false
            self.tblListContact.reloadData()
            self.searchContact.isUserInteractionEnabled = true
        }
    }
    
    func alertError(error : Error) {
        let message = error.localizedDescription
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    var searchActive : Bool = false
    var data = ["San Francisco","New York","San Jose","Chicago","Los Angeles","Austin","Seattle"]
    var filtered = [UserContact]()
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchActive = true;
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        /*filtered = data.filter({ (text) -> Bool in
            let tmp: NSString = text
            let range = tmp.rangeOfString(searchText, options: NSStringCompareOptions.CaseInsensitiveSearch)
            return range.location != NSNotFound
        })*/
        filtered = listContact.filter() {
            if let name = ($0 as UserContact).Name?.lowercased() as String! {
                return name.contains(searchText.lowercased())
            } else {
                return false
            }
        }
        if(filtered.count == 0){
            searchActive = false;
        } else {
            searchActive = true;
        }
        self.tblListContact.reloadData()
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cellContact")!
        
        //cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
        
        var contact : UserContact
        if(searchActive){
            contact = filtered[indexPath.row]
        }
        else{
            contact = listContact[indexPath.row]
        }
        
        //cell.textLabel?.text = listContact[indexPath.row].Name
        
        let imgContact : UIImageView = cell.contentView.viewWithTag(100) as! UIImageView
        let lblContactName : UILabel = cell.contentView.viewWithTag(101) as! UILabel
        let lblLastMessage : UILabel = cell.contentView.viewWithTag(102) as! UILabel
        let imgOnline : UIImageView = cell.contentView.viewWithTag(103) as! UIImageView
        
 
        imgContact.maskCircle(anyImage: contact.Picture!)
        lblContactName.text = contact.Name
        lblLastMessage.text = contact.LatestMessage
        if(!contact.Online!){
            imgOnline.isHidden = true
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let contact : UserContact = listContact[indexPath.row]
        
        passContactID = contact.ContactID
        passContactType = contact.TypeOfContact
        
        performSegue(withIdentifier: "GoToChat", sender: self)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(searchActive){
            return filtered.count
        }
        return listContact.count
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "GoToChat") {
            if let chatVC = segue.destination as? Chat_VC{
                chatVC.contactID = passContactID
                chatVC.contactType = passContactType
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
