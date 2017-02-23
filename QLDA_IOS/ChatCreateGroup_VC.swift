//
//  ChatCreateGroup_.swift
//  QLDA_IOS
//
//  Created by datlh on 2/22/17.
//  Copyright © 2017 datlh. All rights reserved.
//

import UIKit

class ChatCreateGroup_Cell: UITableViewCell{
    @IBOutlet weak var lblContactName: UILabel!
    @IBOutlet weak var imgContact: UIImageView!
    @IBOutlet weak var btnCheck: UIButton!
}

class ChatCreateGroup_VC: UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    @IBOutlet weak var tblListContact: UITableView!
    var listUserChecked : [Int] = []
    var listContact : [UserContact] = [UserContact]()
    @IBOutlet weak var txtGroupName: UITextField!
    @IBOutlet weak var btnCreateGroup: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        btnCreateGroup.setImage(#imageLiteral(resourceName: "PlayIcon"), for: UIControlState.normal)
        btnCreateGroup.imageEdgeInsets = UIEdgeInsetsMake(30,30,30,30)
        //Remove empty cell
        tblListContact.tableFooterView = UIView(frame: .zero)
        
        listContact = ChatCommon.listContact.filter() {
            if let contactType = ($0 as UserContact).TypeOfContact as Int! {
                return contactType == 1
            } else {
                return false
            }
        }
        self.tblListContact.reloadData()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let cell2 : UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cellContact")!
        let cell : ChatCreateGroup_Cell = tableView.dequeueReusableCell(withIdentifier: "cellContact") as! ChatCreateGroup_Cell
        var contact : UserContact
        contact = listContact[indexPath.row]
        //cell.btnCheck.layer.cornerRadius = 12
        if(listUserChecked.contains(contact.ContactID!)){
            cell.btnCheck.setImage(#imageLiteral(resourceName: "ic_check"), for: UIControlState.normal)
            cell.btnCheck.tintColor = UIColor.green
        }
        else{
            cell.btnCheck.setImage(#imageLiteral(resourceName: "ic_uncheck"), for: UIControlState.normal)
            cell.btnCheck.tintColor = UIColor.darkGray
        }
        cell.btnCheck.imageEdgeInsets = UIEdgeInsetsMake(30,30,30,30)
        
        cell.imgContact.maskCircle(anyImage: contact.Picture!)
        cell.lblContactName.text = contact.Name
        cell.btnCheck.tag = contact.ContactID!
        
        //cell.target(forAction: #selector(ChatCreateGroup_VC.selectUser(sender:)), withSender: self)
        cell.btnCheck.addTarget(self, action: #selector(ChatCreateGroup_VC.selectUser(sender:)), for: UIControlEvents.touchUpInside)
        
        return cell
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return listContact.count
    }
        
    @IBAction func btnCreateGroupTouchUpInside(_ sender: Any) {
        let apiUrl : String = "\(UrlPreFix.Chat.rawValue)/Chat_CreateGroupChat/"
        let params : String = "{\"groupName\" : \"tên nhóm\", \"imageData\":\"\", \"host\": \"59\", \"listUserID\": \"59,58,46\"}"

        ApiService.Post(url: apiUrl, params: params, callback: callbackCreateGroup, errorCallBack: errorCreateGroup)
         print(listUserChecked)
    }
    
    func callbackCreateGroup(data : Data) {
        let result = String(data: data, encoding: String.Encoding.utf8)
        
        
        print(result)
        /*
        let json = try? JSONSerialization.jsonObject(with: data, options: [])
        
        if let dic = json as? [String:Any] {
            if let dataResult = dic["GetAllFileUploadResult"] as? [String:Any] {
                if let array = dataResult["DataResult"] as? [[String:Any]] {
                    /*for obj in array {
                     if let imgName = obj["ImageName"] as? String {
                     print(imgName)
                     }
                     }*/
                    
                    //lblTenAnh.text = array[0]["ImageName"] as? String
                    //self.lblTenAnh.text = "ádasdasd"
                    let imageName = array[0]["ImageName"] as? String
                    
                    let alert = UIAlertController(title: "Sucess", message: imageName, preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }*/
        
        //print(json)
        
    }
    
    
    func errorCreateGroup(error : Error) {
        let message = error.localizedDescription
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func selectUser(sender: UIButton!)
    {
        let value = sender.tag;
        
        if let index : Int = listUserChecked.index(of: value){
            listUserChecked.remove(at: index)
        }
        else{
            listUserChecked.append(value)
        }
        self.tblListContact.reloadData()
        
    }
}
