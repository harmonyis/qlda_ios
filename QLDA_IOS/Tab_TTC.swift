//
//  Tab_TTC.swift
//  QLDA_IOS
//
//  Created by Hoang The Anh on 02/03/2017.
//  Copyright © 2017 datlh. All rights reserved.
//

import UIKit
import Foundation
import XLPagerTabStrip

class Tab_TTC: UIViewController, IndicatorInfoProvider {
    
    let cellIdentifier = "postCell"
    var blackTheme = false
    var itemInfo = IndicatorInfo(title: "Thông tin chung")
    
    @IBOutlet weak var uiViewThongTin: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        //  self.ViewData.autoresizesSubviews = true
        
        
    }
    let myColorBoder : UIColor = UIColor(netHex: 0xcccccc)
    func Suscess(data : Data) {
        let json = try? JSONSerialization.jsonObject(with: data, options: [])
        if let dic = json as? [String:Any] {
            print(dic)
            if let arrTTDA = dic["GetThongTinDuAnResult"] as? [String] {
                let arrlblTTDA = ["Tên dự án","Chủ đầu tư","Mục tiêu","Quy mô","Thời gian thực hiện","Lĩnh vực","Nhóm dự án","Hình thức đầu tư","Hình thức quản lý dự án","Giai đoạn dự án","Tình trạng dự án","Nguồn vốn"]
                DispatchQueue.global(qos: .userInitiated).async {
                    DispatchQueue.main.async {
                        var icount = 0
                        var totalHeight : CGFloat = 0
                        for itemTTDA in arrTTDA {
                            var uiView = UIView()
                            var lable:UILabel = UILabel()
                            lable.textColor = UIColor.black
                            lable.font = UIFont(name:"HelveticaNeue-Bold", size: 13.0)
                            lable.text = arrlblTTDA[icount]
                            icount = 1 + icount
                            lable.frame = CGRect(x: 10, y: 0 , width: self.uiViewThongTin.frame.width, height: CGFloat.greatestFiniteMagnitude)
                            lable.numberOfLines = 0
                            lable.sizeToFit()
                            uiView.addSubview(lable)
                            
                            uiView.frame = CGRect(x: 0,y: totalHeight ,width: self.uiViewThongTin.frame.width - 10 , height: lable.frame.height + 4)
                            totalHeight = totalHeight + uiView.frame.height
                            
                            self.uiViewThongTin.addSubview(uiView)
                            uiView = UIView()
                            //self.uiViewThongTin.addSubview(uiView)
                            print(lable.frame.height)
                            var lblTenDuAn:UILabel = UILabel()
                            lblTenDuAn.textColor = UIColor.black
                            lblTenDuAn.font = UIFont(name:"HelveticaNeue", size: 13.0)
                            lblTenDuAn.text = itemTTDA
                            lblTenDuAn.frame = CGRect(x: 10, y: 30 , width: self.uiViewThongTin.frame.width - 10,  height: CGFloat.greatestFiniteMagnitude)
                            
                            lblTenDuAn.numberOfLines = 0
                            lblTenDuAn.sizeToFit()
                            
                            
                            uiView.addSubview(lblTenDuAn)
                            var calHeight : CGFloat = 27
                            if lblTenDuAn.frame.height > 20 {
                                calHeight = lblTenDuAn.frame.height + 7
                            }
                            uiView.frame = CGRect(x: 0,y: totalHeight ,width: self.uiViewThongTin.frame.width, height: calHeight + 4)
                            totalHeight = totalHeight + uiView.frame.height
                            
                            let borderBottom = CALayer()
                            let borderWidth = CGFloat(1)
                            borderBottom.borderColor =  self.myColorBoder.cgColor
                            borderBottom.borderWidth = borderWidth
                            borderBottom.frame = CGRect(x: 0, y: calHeight, width: self.uiViewThongTin.frame.width, height: 1)
                            uiView.layer.addSublayer(borderBottom)
                            uiView.layer.masksToBounds = true
                            
                            self.uiViewThongTin.addSubview(uiView)
                        }
                        let heightConstraint = self.uiViewThongTin.heightAnchor.constraint(equalToConstant: totalHeight)
                        NSLayoutConstraint.activate([heightConstraint])
                        //   self.uiViewThongTin.heightAnchor.constraint(
                        //        equalTo: 500,
                        //       multiplier: 0.65).isActive = true
                        /*  self.lblTenDuAn.text = arrDSDA[0]
                         self.lblTenDuAn.sizeToFit()
                         self.UiViewTenDuAn.frame = CGRect(x: 0, y: 0, width: 15, height: 90)
                         
                         self.lblChuDauTu.text = arrDSDA[1]
                         self.lblMucTieu.text = arrDSDA[2]
                         self.lblQuyMo.text = arrDSDA[3]
                         self.lblThoiGianTH.text = arrDSDA[4]
                         self.lblLinhVuc.text = arrDSDA[5]
                         self.lblNhomDuAn.text = arrDSDA[6]
                         */
                    }
                }                }
        }
    }
    
    
    
    func Error(error : Error) {
        let message = error.localizedDescription
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let ApiUrl : String = "\(UrlPreFix.QLDA.rawValue)/GetThongTinDuAn"
        //let szUser=lblName.
        let params : String = "{\"szIdDuAn\" : \""+(String)(variableConfig.m_szIdDuAn)+"\",\"szUsername\" : \""+variableConfig.m_szUserName+"\", \"szPassword\": \""+variableConfig.m_szPassWord+"\"}"
        
        ApiService.Post(url: ApiUrl, params: params, callback: Suscess, errorCallBack: Error)    }
    
    
    init(itemInfo: IndicatorInfo) {
        self.itemInfo = itemInfo
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    // MARK: - UITableViewDataSource
    
    
    
    // MARK: - IndicatorInfoProvider
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return itemInfo
    }
}
