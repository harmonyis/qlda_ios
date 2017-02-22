//
//  Common.swift
//  QLDA_IOS
//
//  Created by datlh on 2/22/17.
//  Copyright © 2017 datlh. All rights reserved.
//

import Foundation
class Common{
    static func setImageFromURl(url: String) -> UIImage{

        if let url = NSURL(string: url) {
            if let data = NSData(contentsOf: url as URL) {
                return UIImage(data: data as Data)!
            }
            else{
                return UIImage()
            }
        }
        else{
            return UIImage()
        }
    }
}
