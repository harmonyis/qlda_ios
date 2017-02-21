//
//  Chat_VC.swift
//  QLDA_IOS
//
//  Created by datlh on 2/17/17.
//  Copyright © 2017 datlh. All rights reserved.
//

import UIKit

class ChatMain_VC: Base_VC , UITableViewDataSource, UITableViewDelegate{

    @IBOutlet weak var tblListContact: UITableView!
    @IBOutlet weak var txtText: UITextField!
    
    var arrayMenu = [Dictionary<String,String>]()
    
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
        updateArrayMenuOptions()
    }

    @IBAction func goToChat(_ sender: Any) {
        //let vc = storyboard?.instantiateViewController(withIdentifier: "Chat") as! Chat_VC
        //self.navigationController?.pushViewController(vc, animated: true)
        //vc.passData = "122"
    }
    
    func updateArrayMenuOptions(){
        arrayMenu = [Dictionary<String,String>]()
        arrayMenu.append(["title":"Danh sách dự án", "name":"menuDSDA"])
        arrayMenu.append(["title":"Biểu đồ tổng mức đầu tư", "name":"menuTMDT"])
        arrayMenu.append(["title":"Biểu đồ nguồn vốn đầu tư", "name":"menuNVDT"])
        arrayMenu.append(["title":"Biểu đồ giải ngân", "name":"menuGiaiNgan"])
        arrayMenu.append(["title":"Cảnh báo", "name":"menuCanhBao"])
        arrayMenu.append(["title":"Quản lý hình ảnh", "name":"menuQLHA"])
        arrayMenu.append(["title":"Lịch", "name":"menuLich"])
        arrayMenu.append(["title":"Thông tin cá nhân", "name":"menuTTCN"])
        arrayMenu.append(["title":"Thoát", "name":"menuThoat"])
        tblListContact.reloadData()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cellMenu")!
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let index = Int32(indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayMenu.count
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "GoToChat"{
            if let gtChat = segue.destination as? Chat_VC{
                gtChat.passData = txtText.text
            }
        }
    }

}
