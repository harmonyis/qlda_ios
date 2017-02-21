//
//  BaseViewController.swift
//  AKSwiftSlideMenu
//
//  Created by Ashish on 21/09/15.
//  Copyright (c) 2015 Kode. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController, SlideMenuDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func slideMenuItemSelectedAtIndex(_ index: Int32) {
        let topViewController : UIViewController = self.navigationController!.topViewController!
        print("View Controller is : \(topViewController) \n", terminator: "")
        switch(index){
        case 0:
            //print("Home\n", terminator: "")
            self.openViewControllerBasedOnIdentifier("DSDA")
            break
        case 1:
            self.openViewControllerBasedOnIdentifier("BDTMDT")
            break
        case 2:
            self.openViewControllerBasedOnIdentifier("BDNVDT")
            break
        case 3:
            self.openViewControllerBasedOnIdentifier("BDGiaiNgan")
            break
        case 8:
            self.navigationController!.popToRootViewController(animated: true)
            Config.SelectMenuIndex = 0
            return
        default:
            print("default\n", terminator: "")
        }
        Config.SelectMenuIndex = index
    }
    
    func openViewControllerBasedOnIdentifier(_ strIdentifier:String){
        let destViewController : UIViewController = self.storyboard!.instantiateViewController(withIdentifier: strIdentifier)
        
        let topViewController : UIViewController = self.navigationController!.topViewController!
        
        if (topViewController.restorationIdentifier! == destViewController.restorationIdentifier!){
            print("Same VC")
        } else {
            self.navigationController!.pushViewController(destViewController, animated: true)
        }
    }
    
    func addSlideMenuButton(){
        let btnShowMenu = UIButton(type: UIButtonType.system)
        btnShowMenu.setImage(self.defaultMenuImage(), for: UIControlState())
        btnShowMenu.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        btnShowMenu.addTarget(self, action: #selector(BaseViewController.onSlideMenuButtonPressed(_:)), for: UIControlEvents.touchUpInside)
        let customBarItem = UIBarButtonItem(customView: btnShowMenu)
        self.navigationItem.leftBarButtonItem = customBarItem;
        
        let btnNotiMenu = UIButton(type: UIButtonType.system)
        btnNotiMenu.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        btnNotiMenu.setImage(UIImage(named: "ic_noti"), for: UIControlState())
        btnNotiMenu.imageEdgeInsets = UIEdgeInsets(top: 30, left: 30, bottom: 30, right: 30)
        let customNotiBarItem = UIBarButtonItem(customView: btnNotiMenu)
        
        let btnChatMenu = UIButton(type: UIButtonType.system)
        btnChatMenu.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        btnChatMenu.addTarget(self, action: #selector(BaseViewController.onChatBarPressesd(_:)), for: UIControlEvents.touchUpInside)
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
    
    func onSlideMenuButtonPressed(_ sender : UIButton){
        if (sender.tag == 10)
        {
            // To Hide Menu If it already there
            self.slideMenuItemSelectedAtIndex(-1);
            
            sender.tag = 0;
            
            let viewMenuBack : UIView = view.subviews.last!
            
            UIView.animate(withDuration: 0.3, animations: { () -> Void in
                var frameMenu : CGRect = viewMenuBack.frame
                frameMenu.origin.x = -1 * UIScreen.main.bounds.size.width
                viewMenuBack.frame = frameMenu
                viewMenuBack.layoutIfNeeded()
                viewMenuBack.backgroundColor = UIColor.clear
                }, completion: { (finished) -> Void in
                    viewMenuBack.removeFromSuperview()
            })
            
            return
        }
        
        sender.isEnabled = false
        sender.tag = 10
        
        let menuVC : MenuViewController = self.storyboard!.instantiateViewController(withIdentifier: "MenuViewController") as! MenuViewController
        menuVC.btnMenu = sender
        menuVC.delegate = self
        self.view.addSubview(menuVC.view)
        self.addChildViewController(menuVC)
        menuVC.view.layoutIfNeeded()
        
        
        menuVC.view.frame=CGRect(x: 0 - UIScreen.main.bounds.size.width, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height);
        
        UIView.animate(withDuration: 0.3, animations: { () -> Void in
            menuVC.view.frame=CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height);
            sender.isEnabled = true
            }, completion:nil)
    }
    
    func onChatBarPressesd(_ sender : UIButton){
        let vc = storyboard?.instantiateViewController(withIdentifier: "ChatMain") as! ChatMain_VC
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
