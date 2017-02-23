//
//  UIImageView.swift
//  QLDA_IOS
//
//  Created by datlh on 2/22/17.
//  Copyright © 2017 datlh. All rights reserved.
//

import UIKit
extension UIImageView {
    public func maskCircle(anyImage: UIImage) {
        self.contentMode = UIViewContentMode.scaleAspectFill
        self.layer.cornerRadius = self.frame.height / 2
        self.layer.masksToBounds = false
        self.clipsToBounds = true
        
        // make square(* must to make circle),
        // resize(reduce the kilobyte) and
        // fix rotation.
        self.image = anyImage
    }
}
