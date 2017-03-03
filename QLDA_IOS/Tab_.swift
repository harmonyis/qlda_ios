//
//  Tab_.swift
//  QLDA_IOS
//
//  Created by Hoang The Anh on 02/03/2017.
//  Copyright © 2017 datlh. All rights reserved.
//

import UIKit
import Foundation
import XLPagerTabStrip

class Tab_:ButtonBarPagerTabStripViewController {
    
    @IBOutlet weak var shadowView: UIView!
    
    @IBOutlet weak var uiViewTenDuAn: UIView!
    let graySpotifyColor = UIColor(netHex: 0xcccccc)
    let darkGraySpotifyColor = UIColor(netHex: 0xcccccc)
    
    override func viewDidLoad() {
        // change selected bar color
        
        settings.style.buttonBarBackgroundColor = graySpotifyColor
        settings.style.buttonBarItemBackgroundColor = graySpotifyColor
        settings.style.selectedBarBackgroundColor = UIColor(netHex: 0x0e83d5)
        settings.style.buttonBarItemFont = UIFont(name: "HelveticaNeue-Light", size:14) ?? UIFont.systemFont(ofSize: 14)
        settings.style.selectedBarHeight = 1.0
        settings.style.buttonBarMinimumLineSpacing = 0
        settings.style.buttonBarItemTitleColor = .black
        settings.style.buttonBarItemsShouldFillAvailableWidth = true
        
        
        settings.style.buttonBarLeftContentInset = 5
        settings.style.buttonBarRightContentInset = 5
        
        changeCurrentIndexProgressive = { (oldCell: ButtonBarViewCell?, newCell: ButtonBarViewCell?, progressPercentage: CGFloat, changeCurrentIndex: Bool, animated: Bool) -> Void in
            guard changeCurrentIndex == true else { return }
            oldCell?.label.textColor = UIColor(netHex: 0xbbbbbb)
            newCell?.label.textColor = UIColor(netHex: 0x0e83d5)
            
            
        }
        super.viewDidLoad()
        
        let uiView = UIView()
        let lable:UILabel = UILabel()
        lable.textColor = UIColor.white
        lable.font = UIFont(name:"HelveticaNeue-Bold", size: 13.0)
        lable.text = variableConfig.m_szTenDuAn
        lable.frame = CGRect(x: 10, y: 10 , width: self.view.frame.width - 10, height: CGFloat.greatestFiniteMagnitude)
        lable.numberOfLines = 0
        lable.sizeToFit()
        uiView.addSubview(lable)
        
        var calHeight : CGFloat = 37
        if lable.frame.height > 20 {
            calHeight = (CGFloat)((Double)(lable.frame.height*1.5)) + 15
        }
        
        uiView.frame = CGRect(x: 0,y: 5 ,width: self.uiViewTenDuAn.frame.width - 10 , height: calHeight)
        //    self.uiViewTenDA.frame = CGRect(x: 0,y: 70 ,width: self.uiViewTenDA.frame.width - 10 , height: lable.frame.height + 4)
        self.uiViewTenDuAn.addSubview(uiView)
        self.uiViewTenDuAn.heightAnchor.constraint(
            equalTo: uiView.heightAnchor,
            multiplier: 0.65).isActive = true
        
        
        self.addLeftBarButton()
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
        self.addRightBarButton()
    }
    func addLeftBarButton(){
        let btnShowMenu = UIButton(type: UIButtonType.system)
        btnShowMenu.setImage(self.defaultMenuImage(), for: UIControlState())
        btnShowMenu.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        //btnShowMenu.target = self.revealViewController()
        //btnShowMenu.action = Selector("revealToggle:")
        //btnShowMenu.addTarget(self, action: Selector("revealToggle:")), for: UIControlEvents.touchUpInside)
        
        btnShowMenu.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: UIControlEvents.touchUpInside)
        let customBarItem = UIBarButtonItem(customView: btnShowMenu)
        self.navigationItem.leftBarButtonItem = customBarItem;
    }
    
    func defaultMenuImage() -> UIImage {
        var defaultMenuImage = UIImage()
        
        UIGraphicsBeginImageContextWithOptions(CGSize(width: 30, height: 22), false, 0.0)
        
        UIColor.black.setFill()
        UIBezierPath(rect: CGRect(x: 0, y: 3, width: 30, height: 1)).fill()
        UIBezierPath(rect: CGRect(x: 0, y: 10, width: 30, height: 1)).fill()
        UIBezierPath(rect: CGRect(x: 0, y: 17, width: 30, height: 1)).fill()
        
        UIColor.white.setFill()
        UIBezierPath(rect: CGRect(x: 0, y: 4, width: 30, height: 1)).fill()
        UIBezierPath(rect: CGRect(x: 0, y: 11,  width: 30, height: 1)).fill()
        UIBezierPath(rect: CGRect(x: 0, y: 18, width: 30, height: 1)).fill()
        
        defaultMenuImage = UIGraphicsGetImageFromCurrentImageContext()!
        
        UIGraphicsEndImageContext()
        
        return defaultMenuImage;
    }
    
    func addRightBarButton(){
        let btnNotiMenu = UIButton(type: UIButtonType.system)
        btnNotiMenu.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        btnNotiMenu.setImage(UIImage(named: "ic_noti"), for: UIControlState())
        btnNotiMenu.imageEdgeInsets = UIEdgeInsets(top: 30, left: 30, bottom: 30, right: 30)
        let customNotiBarItem = UIBarButtonItem(customView: btnNotiMenu)
        
        let btnChatMenu = UIButton(type: UIButtonType.system)
        btnChatMenu.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        btnChatMenu.addTarget(self, action: #selector(Base_VC.onChatBarPressesd(_:)), for: UIControlEvents.touchUpInside)
        btnChatMenu.setImage(UIImage(named: "HomeIcon"), for: UIControlState())
        btnChatMenu.imageEdgeInsets = UIEdgeInsets(top: 30, left: 30, bottom: 30, right: 30)
        let customChatBarItem = UIBarButtonItem(customView: btnChatMenu)
        
        let btnMapMenu = UIButton(type: UIButtonType.system)
        btnMapMenu.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        btnMapMenu.setImage(UIImage(named: "ic_map"), for: UIControlState())
        btnMapMenu.imageEdgeInsets = UIEdgeInsets(top: 30, left: 30, bottom: 30, right: 30)
        let customMapBarItem = UIBarButtonItem(customView: btnMapMenu)
        
        self.navigationItem.rightBarButtonItems = [customNotiBarItem, customChatBarItem, customMapBarItem]
    }
    
    func onChatBarPressesd(_ sender : UIButton){
        Config.SelectMenuIndex = -1
        let vc = storyboard?.instantiateViewController(withIdentifier: "ChatMain") as! ChatMain_VC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    // MARK: - PagerTabStripDataSource
    
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        
        let child_6 = self.storyboard?.instantiateViewController(withIdentifier: "Tab_TTC") as! Tab_TTC
        child_6.blackTheme = true
        return [child_6]
    }
    
    // MARK: - Actions
    
    @IBAction func closeAction(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}

