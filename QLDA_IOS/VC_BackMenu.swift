//
//  VC_BackMenu.swift
//  QLDA_IOS
//
//  Created by datlh on 2/20/17.
//  Copyright © 2017 datlh. All rights reserved.
//

import Foundation

class VC_BackMenu: UITableViewController{
    var tableArray = [String]()
    
    override func viewDidLoad() {
        tableArray = ["menuDSDA","menuTMDT","menuNVDT"]
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell1")!
        //var cell = tableView.dequeueReusableCell(withIdentifier: tableArray[indexPath.row], for: indexPath)
        cell.textLabel?.text = tableArray[indexPath.row]
        return cell
    }
}
