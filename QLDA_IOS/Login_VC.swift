//
//  LoginVC.swift
//  QLDA_IOS
//
//  Created by datlh on 2/16/17.
//  Copyright © 2017 datlh. All rights reserved.
//

import UIKit
class Login_VC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Do any additional setup after loading the view.
    }
    @IBAction func Login(_ sender: Any) {
        //let st = UIStoryboard(name : "Main", bundle: nil)
        //let vc = st.instantiateViewController(withIdentifier: "DSDA") as! DSDA_VC
        let vc = storyboard?.instantiateViewController(withIdentifier: "DSDA") as! DSDA_VC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Hide the navigation bar on the this view controller
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Show the navigation bar on other view controllers
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
}
