//
//  UIView.swift
//  QLDA_IOS
//
//  Created by datlh on 3/2/17.
//  Copyright © 2017 datlh. All rights reserved.
//

import UIKit

extension UIView{
    func createBadge(tag : Int, number : Int, frame : CGRect){
        let label = UILabel(frame: frame)
        label.layer.borderColor = UIColor.clear.cgColor
        label.layer.borderWidth = 2
        label.layer.cornerRadius = label.bounds.size.height / 2
        label.textAlignment = .center
        label.layer.masksToBounds = true
        label.font = UIFont.systemFont(ofSize: 10)
        label.textColor = .white
        label.backgroundColor = .red
        label.tag = tag
        
        if(number > 0){
            label.text = String(number)
            label.isHidden = false
        }
        else{
            label.text = ""
            label.isHidden = true
        }
        self.addSubview(label)
    }
    
    func updateBadge(label : UILabel, number : Int){
        if(number > 0){
            label.text = String(number)
            label.isHidden = false
        }
        else{
            label.text = ""
            label.isHidden = true
        }
    }
}
