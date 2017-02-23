//
//  DSDAViewController.swift
//  QLDA_IOS
//
//  Created by datlh on 2/16/17.
//  Copyright © 2017 datlh. All rights reserved.
//

import UIKit

class DSDA_VC: Base_VC {
    
    //var service = ApiService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let ApiUrl : String = "\(UrlPreFix.QLDA.rawValue)/GetDuAn"
        //let szUser=lblName.
        let params : String = "{\"szUsername\" : \"demo1\", \"szPassword\": \"abc@123\"}"
        
        ApiService.Post(url: ApiUrl, params: params, callback: Alert, errorCallBack: AlertError)
        
        
        //self.addSlideMenuButton()
    }
    
    func Alert(data : Data) {
        let json = try? JSONSerialization.jsonObject(with: data, options: [])
       if let dic = json as? [String:Any] {
          if let idUser = dic["GetDuAnResult"] as? [[String]] {
       
        print(idUser[0][0])
        
            }
        }
    }
    func AlertError(error : Error) {
        let message = error.localizedDescription
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    
    @IBAction func backLogin(_ sender: Any) {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
