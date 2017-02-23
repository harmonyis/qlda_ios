//
//  ExtendtionUItableViewCell.swift
//  QLDA_IOS
//
//  Created by Hoang The Anh on 22/02/2017.
//  Copyright © 2017 datlh. All rights reserved.
//

import Foundation
extension UITableViewCell {
    static var defaultReuseIdentifier : String {
        get {
            return String(describing: self)
        }
    }
}
