//
//  LoginVC.swift
//  QLDA_IOS
//
//  Created by datlh on 2/16/17.
//  Copyright © 2017 datlh. All rights reserved.
//

import UIKit
class Login_VC: UIViewController {
    
    @IBOutlet weak var lblMesage: UILabel!
    @IBOutlet weak var lblMatKhau: UITextField!
    @IBOutlet weak var lblTenDangNhap: UITextField!
    //var service = ApiService()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    var szMatKhau : String = ""
    var szTenDangNhap : String = ""
    @IBAction func Login(_ sender: Any) {
        let ApiUrl : String = "\(UrlPreFix.QLDA.rawValue)/CheckUser"
        //let szUser=lblName.
        szMatKhau = (lblMatKhau.text)!
        szTenDangNhap = (lblTenDangNhap.text)!
        let params : String = "{\"szUsername\" : \""+szTenDangNhap+"\", \"szPassword\": \""+szMatKhau+"\"}"
        
        ApiService.Post(url: ApiUrl, params: params, callback: Alert, errorCallBack: AlertError)
        
    }
    func Alert(data : Data) {
        let json = try? JSONSerialization.jsonObject(with: data, options: [])
        if let dic = json as? [String:Any] {
            if let idUser = dic["CheckUserResult"] as? String {
                let nIdUser:Int = Int(idUser)!
                if nIdUser > 0 {
                    DispatchQueue.global(qos: .userInitiated).async {
                        DispatchQueue.main.async {
                            ChatHub.initChatHub()
                            ChatHub.initEvent()
                            ChatCommon.getContacts()
                            variableConfig.m_szUserName = self.szTenDangNhap
                            variableConfig.m_szPassWord = self.szMatKhau
                            let vc = self.storyboard?.instantiateViewController(withIdentifier: "DSDA") as! DSDA_VC
                            self.navigationController?.pushViewController(vc, animated: true)
                        }
                    }
                }
                else {
                    DispatchQueue.global(qos: .userInitiated).async {
                        DispatchQueue.main.async {
                            self.lblMesage.text="Sai tên tài khoản hoặc mật khẩu"
                        }
                    }
                    
                }
            }
        }
    }
    func AlertError(error : Error) {
        let message = error.localizedDescription
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
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
