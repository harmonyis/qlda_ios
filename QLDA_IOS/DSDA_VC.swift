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
    var indexTrangThaiDuAnCha = Set<Int>()
    var indexGroupDuAnCon = Set<Int>()
    var indexTrangThaiDuAnCon = Set<String>()
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.tbDSDA.rowHeight = UITableViewAutomaticDimension
        
        
        self.automaticallyAdjustsScrollViewInsets = false
        
        //    self.tbDSDA.rowHeight = UITableViewAutomaticDimension
        //    self.tbDSDA.estimatedRowHeight = 190
        
        self.tbDSDA.alwaysBounceVertical = false
        
        //self.addSlideMenuButton()
    }
    
    func Alert(data : Data) {
        let json = try? JSONSerialization.jsonObject(with: data, options: [])
        if let dic = json as? [String:Any] {
            if let arrDSDA = dic["GetDuAnResult"] as? [[String]] {
                
                
                for itemDA in arrDSDA {
                    
                    if itemDA[0] == itemDA[5] {
                        let itemNhomDA = NhomDA()
                        itemNhomDA.IdDA = itemDA[0] as String
                        itemNhomDA.TenDA = itemDA[1] as String
                        itemNhomDA.GiaiDoan = itemDA[4] as String
                        itemNhomDA.NhomDA = itemDA[3] as String
                        itemNhomDA.ThoiGianThucHien = itemDA[8] as String
                        itemNhomDA.TongMucDauTu = itemDA[6] as String
                        itemNhomDA.GiaTriGiaiNgan = itemDA[7] as String
                        self.DSDA.append(itemNhomDA)
                        
                    }
                    else if  self.DSDA.contains(where: { $0.IdDA! == itemDA[5] }) {
                        let NhomDuAn = self.DSDA.first(where: { $0.IdDA! == itemDA[5] })
                        print(itemDA[5])
                        print(itemDA[0])
                        var NhomDuAnCon = [DuAn]()
                        NhomDuAnCon = (NhomDuAn?.DuAnCon)!
                        
                        let DuAnCon = DuAn()
                        DuAnCon.IdDA = itemDA[0] as String
                        DuAnCon.TenDA = itemDA[1] as String
                        DuAnCon.GiaiDoan = itemDA[4] as String
                        DuAnCon.NhomDA = itemDA[3] as String
                        DuAnCon.ThoiGianThucHien = itemDA[8] as String
                        DuAnCon.TongMucDauTu = itemDA[6] as String
                        DuAnCon.GiaTriGiaiNgan = itemDA[7] as String
                        
                        NhomDuAnCon.append(DuAnCon)
                        
                        self.DSDA.remove(at: self.DSDA.index(where: { $0.IdDA! == itemDA[5] })!)
                        NhomDuAn?.DuAnCon=NhomDuAnCon
                        self.DSDA.append(NhomDuAn!)
                    }
                    
                    
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
    
    /*  func numberOfSections(in tableView: UITableView) -> Int {
     return 1
     }
     */
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.DSDA.count
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if(self.indexGroupDuAnCon.contains(section))
        {
            return 0
        }
        else {
            return self.DSDA[section].DuAnCon!.count
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if !self.indexTrangThaiDuAnCon.contains((String)(indexPath.section)+"-"+(String)(indexPath.row)) {
            return 40
        }
        return 190
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if !self.indexTrangThaiDuAnCha.contains(section) {
            return 40
        }
        return 190
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "idCustomcell") as! CustomCellDSDATableViewCell
        
        //  cell.scrollEnabled = false
        let itemNhomDA :NhomDA = self.DSDA[section]
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
        
        if (itemNhomDA.DuAnCon?.count)!>0 {
            
            if !self.indexGroupDuAnCon.contains(section)
            {
                let image : UIImage = UIImage(named:"ic_Group-Up")!
                cell.imgGroup.image = image
                
            }
            else
            {
                let image : UIImage = UIImage(named:"ic_Group-Down")!
                cell.imgGroup.image = image
                
            }
        }
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
        cell.UiViewBDThongTin.layer.borderColor = myColorBoder.cgColor
        cell.UiViewBDThongTin.layer.borderWidth=1
        
        var eventClick = UITapGestureRecognizer()
        
        cell.imgDetail.tag = section
        eventClick.addTarget(self, action:  #selector(DSDA_VC.duAnChaClickDetail(sender: )))
        cell.imgDetail.addGestureRecognizer(eventClick)
        cell.imgDetail.isUserInteractionEnabled = true;
        
        eventClick = UITapGestureRecognizer()
        cell.imgGroup.tag = section
        eventClick.addTarget(self, action:  #selector(DSDA_VC.duAnChaClickGroup(sender: )))
        cell.imgGroup.addGestureRecognizer(eventClick)
        cell.imgGroup.isUserInteractionEnabled = true;
        
        cell.UiViewThongTinChiTiet.isHidden = !self.indexTrangThaiDuAnCha.contains(section)
        
        
        return cell
    }
    func duAnChaClickGroup(sender: UITapGestureRecognizer)
    {
        //print(sender.view?.tag)
        let value  = (sender.view?.tag)
        
        if self.indexGroupDuAnCon.contains(value!) {
            self.indexGroupDuAnCon.remove(value!)
        }
        else {
            self.indexGroupDuAnCon.insert(value!)
            
        }
        
        // self.tbDSDA.beginUpdates()
        //    self.tbDSDA.endUpdates()
        self.tbDSDA.reloadData()
    }
    
    func duAnChaClickDetail(sender: UITapGestureRecognizer)
    {
        //print(sender.view?.tag)
        let value  = (sender.view?.tag)
        
        if self.indexTrangThaiDuAnCha.contains(value!) {
            self.indexTrangThaiDuAnCha.remove(value!)
        }
        else {
            self.indexTrangThaiDuAnCha.insert(value!)
            
        }
        // self.tbDSDA.beginUpdates()
        //    self.tbDSDA.endUpdates()
        self.tbDSDA.reloadData()
    }
    
    
    /*    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
     return self.DSDA.count
     }
     */
    let myColorBoder : UIColor = UIColor(netHex: 0xcccccc)
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //tableView.scrollToRow(at: indexPath, at: .top, animated: false)
        
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "idCustomcell", for: indexPath) as! CustomCellDSDATableViewCell
        let itemNhomDA :NhomDA = self.DSDA[indexPath.section]
        let itemDuAnCon :[DuAn] = itemNhomDA.DuAnCon!
        cell.lblTenDuAn.text = itemDuAnCon[indexPath.row].TenDA!
        cell.lblNhomDuAn.text = itemDuAnCon[indexPath.row].NhomDA!
        cell.lblGiaiDoan.text = itemDuAnCon[indexPath.row].GiaiDoan!
        cell.lblGiaTriGiaiNgan.text = itemDuAnCon[indexPath.row].GiaTriGiaiNgan!
        cell.lblTongDauTu.text = itemDuAnCon[indexPath.row].TongMucDauTu!
        cell.lblThoiGianThucHien.text = itemDuAnCon[indexPath.row].ThoiGianThucHien!
        
        cell.UiViewGroup.layer.borderColor = myColorBoder.cgColor
        cell.UiViewGroup.layer.borderWidth=1
        
        cell.UiViewDetail.layer.borderColor = myColorBoder.cgColor
        cell.UiViewDetail.layer.borderWidth=1
        
        cell.imgGroup.isHidden=true
        
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
        
        // cell.imgDetail.addTarget(self, action: #selector(DSDA_VC.tappedMe()))
        let eventClick = UITapGestureRecognizer()
        let value=(String)(indexPath.section)+"-"+(String)(indexPath.row)
        cell.imgDetail.accessibilityLabel = value
        print(indexPath.row)
        eventClick.addTarget(self, action:  #selector(DSDA_VC.duAnConClickDetail(sender: )))
        
        cell.imgDetail.addGestureRecognizer(eventClick)
        cell.imgDetail.isUserInteractionEnabled = true;
        
        cell.UiViewThongTinChiTiet.isHidden = !self.indexTrangThaiDuAnCon.contains(value)
        //  print("ssssss")
        return cell
    }
    
    func duAnConClickDetail(sender: UITapGestureRecognizer)
    {
        //print(sender.view?.tag)
        let value : String = (sender.view?.accessibilityLabel)!
        // print(value)
        
        //  print(self.expandedCellPaths)
        if self.indexTrangThaiDuAnCon.contains(value) {
            self.indexTrangThaiDuAnCon.remove(value)
        }
        else {
            self.indexTrangThaiDuAnCon.insert(value)
            
        }
        // self.tbDSDA.beginUpdates()
        //    self.tbDSDA.endUpdates()
        self.tbDSDA.reloadData()
    }
}
