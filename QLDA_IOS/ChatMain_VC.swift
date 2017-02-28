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
    var passContactName:String!
    
    //var chatHub: Hub = Hub("chatHub")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initEnvetChatHub()
        btnCreateGroup.layer.cornerRadius = 25
        btnCreateGroup.setImage(#imageLiteral(resourceName: "ic_createGroup"), for: UIControlState.normal)
        btnCreateGroup.imageEdgeInsets = UIEdgeInsetsMake(40,40,40,40)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        aivLoad.startAnimating()
        tblListContact.isHidden = true
        tblListContact.tableFooterView = UIView(frame: .zero)

        self.listContact = ChatCommon.listContact
        self.aivLoad.isHidden = true
        self.tblListContact.isHidden = false
        self.reloadData()
    }
    
    @IBAction func goToChat(_ sender: Any) {
        //let vc = storyboard?.instantiateViewController(withIdentifier: "Chat") as! Chat_VC
        //self.navigationController?.pushViewController(vc, animated: true)
        //vc.passData = "122"
    }
    
    var searchActive : Bool = false
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
        passContactName = contact.Name
        
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
                chatVC.contactName = passContactName
            }
        }
    }
    
    
    // Chat hub
    
    func initEnvetChatHub(){
        ChatHub.addChatHub(hub:  ChatHub.chatHub)
        ChatHub.chatHub.on("onConnected") {args in            
            self.reloadData()
        }
        
        ChatHub.chatHub.on("onDisconnected") {args in
            self.reloadData()
        }
        ChatHub.chatHub.on("receivePrivateMessage") {args in
            self.reloadData()
        }
        ChatHub.chatHub.on("receiveGroupMessage") {args in
            self.reloadData()
        }
        ChatHub.chatHub.on("receiveChatGroup") {args in
            self.reloadData()
        }
    }
    
    func reloadData(){
        DispatchQueue.global(qos: .userInitiated).async {
            DispatchQueue.main.async {
                self.tblListContact.reloadData()
            }
        }
    }
    
    /*
     func myEncrypt(encryptData:String) -> NSData?{
     
     var myKeyData : NSData = ("myEncryptionKey" as NSString).data(using: String.Encoding.utf8.rawValue)! as NSData
     var myRawData : NSData = encryptData.data(using: String.Encoding.utf8)! as NSData
     var iv : [UInt8] = [56, 101, 63, 23, 96, 182, 209, 205]  // I didn't use
     var buffer_size : size_t = myRawData.length + kCCBlockSize3DES
     var buffer = UnsafeMutablePointer<NSData>.alloc(buffer_size)
     var num_bytes_encrypted : size_t = 0
     
     let operation: CCOperation = UInt32(kCCEncrypt)
     let algoritm:  CCAlgorithm = UInt32(kCCAlgorithm3DES)
     let options:   CCOptions   = UInt32(kCCOptionECBMode + kCCOptionPKCS7Padding)
     let keyLength        = size_t(kCCKeySize3DES)
     
     var Crypto_status: CCCryptorStatus = CCCrypt(operation, algoritm, options, myKeyData.bytes, keyLength, nil, myRawData.bytes, myRawData.length, buffer, buffer_size, &num_bytes_encrypted)
     
     if UInt32(Crypto_status) == UInt32(kCCSuccess){
     
     var myResult: NSData = NSData(bytes: buffer, length: num_bytes_encrypted)
     
     free(buffer)
     println("my result \(myResult)") //This just prints the data
     
     let keyData: NSData = myResult
     let hexString = keyData.toHexString()
     println("hex result \(hexString)") // I needed a hex string output
     
     
     myDecrypt(myResult) // sent straight to the decryption function to test the data output is the same
     return myResult
     }else{
     free(buffer)
     return nil
     }
     }
     
     
     func myDecrypt(decryptData : NSData) -> NSData?{
     
     var mydata_len : Int = decryptData.length
     var keyData : NSData = ("myEncryptionKey" as NSString).dataUsingEncoding(NSUTF8StringEncoding)!
     
     var buffer_size : size_t = mydata_len+kCCBlockSizeAES128
     var buffer = UnsafeMutablePointer<NSData>.alloc(buffer_size)
     var num_bytes_encrypted : size_t = 0
     
     var iv : [UInt8] = [56, 101, 63, 23, 96, 182, 209, 205]  // I didn't use
     
     let operation: CCOperation = UInt32(kCCDecrypt)
     let algoritm:  CCAlgorithm = UInt32(kCCAlgorithm3DES)
     let options:   CCOptions   = UInt32(kCCOptionECBMode + kCCOptionPKCS7Padding)
     let keyLength        = size_t(kCCKeySize3DES)
     
     var decrypt_status : CCCryptorStatus = CCCrypt(operation, algoritm, options, keyData.bytes, keyLength, nil, decryptData.bytes, mydata_len, buffer, buffer_size, &num_bytes_encrypted)
     
     if UInt32(decrypt_status) == UInt32(kCCSuccess){
     
     var myResult : NSData = NSData(bytes: buffer, length: num_bytes_encrypted)
     free(buffer)
     println("decrypt \(myResult)")
     
     var stringResult = NSString(data: myResult, encoding:NSUTF8StringEncoding)
     println("my decrypt string \(stringResult!)")
     return myResult
     }else{
     free(buffer)
     return nil
     
     }
     }*/
}
