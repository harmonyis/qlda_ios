//
//  MenuLeft_.swift
//  QLDA_IOS
//
//  Created by datlh on 2/20/17.
//  Copyright © 2017 datlh. All rights reserved.
//

import UIKit

class MenuLeft_VC: UIViewController , UITableViewDataSource, UITableViewDelegate{

    @IBOutlet weak var tblMenuLeft: UITableView!
    var arrayMenu = [Dictionary<String,String>]()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tblMenuLeft.tableFooterView = UIView()
        self.tblMenuLeft.separatorStyle = UITableViewCellSeparatorStyle.none
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateArrayMenuOptions()
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
        tblMenuLeft.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayMenu.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let cell : UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cellMenu")!
        let cell : UITableViewCell = tableView.dequeueReusableCell(withIdentifier: arrayMenu[indexPath.row]["name"]!)!

        cell.selectionStyle = UITableViewCellSelectionStyle.none
        cell.layoutMargins = UIEdgeInsets.zero
        cell.preservesSuperviewLayoutMargins = false
        cell.backgroundColor = UIColor.clear
        
        let lblTitle : UILabel = cell.contentView.viewWithTag(101) as! UILabel
        //let imgIcon : UIImageView = cell.contentView.viewWithTag(100) as! UIImageView
        
        //imgIcon.image = UIImage(named: arrayMenuOptions[indexPath.row]["icon"]!)
        lblTitle.text = arrayMenu[indexPath.row]["title"]!
        if(Int32(indexPath.row) == Config.SelectMenuIndex){
            lblTitle.textColor = UIColor(netHex:0x17C2FF)
            cell.backgroundColor =  UIColor(netHex:0xE4E4E4)
        }
        else{
            lblTitle.textColor = UIColor(netHex:0x000000)
            cell.backgroundColor =  UIColor(netHex:0xFFFFFF)
        }
        
        if(Int32(indexPath.row) == 7){
            //cell.layer.borderWidth = 1.0
            //cell.layer.borderColor = UIColor.gray.cgColor
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //let cell : UITableViewCell = tblMenuLeft.cellForRow(at: indexPath)!
        
        
        let index = Int32(indexPath.row)
        Config.SelectMenuIndex = index
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
}
