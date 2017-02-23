//
//  Chat_VC.swift
//  QLDA_IOS
//
//  Created by datlh on 2/17/17.
//  Copyright © 2017 datlh. All rights reserved.
//

import UIKit

class Chat_VC: UIViewController {
    
    var contactID : Int!
    var contactType : Int!
    var service = ApiService()
    override func viewDidLoad() {
        super.viewDidLoad()
        print(contactID, contactType)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
