//
//  DSDA.swift
//  QLDA_IOS
//
//  Created by datlh on 2/20/17.
//  Copyright © 2017 datlh. All rights reserved.
//

import UIKit

class DSDA_View: UIView {

    @IBOutlet var viewDSDA: UIView!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        UINib(nibName: "DSDA_View", bundle: nil).instantiate(withOwner: self, options: nil)
        addSubview(viewDSDA)
        viewDSDA.frame = self.bounds
    }
    @IBAction func backToLogin(_ sender: Any) {
        //self.navigationController!.popToRootViewController(animated: true)
        
    }
}
