//
//  DSDAViewController.swift
//  QLDA_IOS
//
//  Created by datlh on 2/16/17.
//  Copyright © 2017 datlh. All rights reserved.
//

import UIKit

class DSDA_VC: Base_VC , UITableViewDataSource, UITableViewDelegate{
    
    @IBOutlet weak var tbDSDA: UITableView!
   
    var DSDA = [NhomDA]()
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.tbDSDA.rowHeight = UITableViewAutomaticDimension

       
        
        
        //self.addSlideMenuButton()
    }
    
    func Alert(data : Data) {
        let json = try? JSONSerialization.jsonObject(with: data, options: [])
       if let dic = json as? [String:Any] {
          if let arrDSDA = dic["GetDuAnResult"] as? [[String]] {
        
        
            for itemDA in arrDSDA {
            
                var itemNhomDA = NhomDA()
                itemNhomDA.TenDA = itemDA[1] as String
                itemNhomDA.GiaiDoan=itemDA[4] as String
                itemNhomDA.NhomDA = itemDA[3] as String
                itemNhomDA.ThoiGianThucHien=itemDA[8] as String
                itemNhomDA.TongMucDauTu=itemDA[6] as String
                itemNhomDA.GiaTriGiaiNgan=itemDA[7] as String
              self.DSDA.append(itemNhomDA)
            
            }
            
            DispatchQueue.global(qos: .userInitiated).async {
                DispatchQueue.main.async {
                    
                    self.tbDSDA.reloadData()
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let ApiUrl : String = "\(UrlPreFix.QLDA.rawValue)/GetDuAn"
        //let szUser=lblName.
        let params : String = "{\"szUsername\" : \"demo1\", \"szPassword\": \"abc@123\"}"
        
        ApiService.Post(url: ApiUrl, params: params, callback: Alert, errorCallBack: AlertError)    }

    
    @IBAction func backLogin(_ sender: Any) {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
 
    //Table
    
     func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.DSDA.count
    }
     let myColorBoder : UIColor = UIColor(netHex: 0xcccccc)
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "idCustomcell", for: indexPath) as! CustomCellDSDATableViewCell
        
        let itemNhomDA :NhomDA = self.DSDA[indexPath.row]
        cell.lblTenDuAn.text = itemNhomDA.TenDA!
        cell.lblNhomDuAn.text = itemNhomDA.NhomDA!
        cell.lblGiaiDoan.text = itemNhomDA.GiaiDoan!
        cell.lblGiaTriGiaiNgan.text = itemNhomDA.GiaTriGiaiNgan!
        cell.lblTongDauTu.text = itemNhomDA.TongMucDauTu!
        cell.lblThoiGianThucHien.text = itemNhomDA.ThoiGianThucHien!
        
        cell.UiViewGroup.layer.borderColor = myColorBoder.cgColor
        cell.UiViewGroup.layer.borderWidth=1

        cell.UiViewDetail.layer.borderColor = myColorBoder.cgColor
        cell.UiViewDetail.layer.borderWidth=1
        
   
      //  cell.UIViewTieuDe.layer.borderWidth=1
        
        cell.lblTenDuAn.layer.borderColor = myColorBoder.cgColor
        cell.lblTenDuAn.layer.borderWidth=1
        
        
        let borderBottom = CALayer()
        let borderWidth = CGFloat(1.0)
        borderBottom.borderColor =  myColorBoder.cgColor
        borderBottom.borderWidth = borderWidth
        borderBottom.frame = CGRect(x: 0, y: cell.UiViewBDThongTinCT.frame.height, width: cell.UiViewBDThongTinCT.frame.width, height: 1)
        cell.UiViewBDThongTinCT.layer.addSublayer(borderBottom)
        cell.UiViewBDThongTinCT.layer.masksToBounds = true
        
        
        cell.UiViewThongTinChiTiet.layer.borderColor = myColorBoder.cgColor
        cell.UiViewThongTinChiTiet.layer.borderWidth=1
     //   cell.UiViewThongTinChiTiet.layer.masksToBounds=true
        
        cell.UiViewBDThongTin.layer.borderColor = myColorBoder.cgColor
        cell.UiViewBDThongTin.layer.borderWidth=1
        
      //  cell.UiViewContent.layer.borderWidth=1
        /* if let image = feedEntry.image {
         cell.trackAlbumArtworkView.image = image
         } else {
         feedManager.fetchImageAtIndex(index: indexPath.row, completion: { (index) in
         self.handleImageLoadForIndex(index: index)
         })
         }
         
         cell.audioPlaybackView.isHidden = !expandedCellPaths.contains(indexPath)
         */
       
        
        eventClick.addTarget(self, action:  #selector(DSDA_VC.tappedMe))
       
        cell.imgDetail.addGestureRecognizer(eventClick)
        
        return cell
    }
     let eventClick = UITapGestureRecognizer()
    func tappedMe()
    {
       self.tbDSDA.reloadData()
    }
}
