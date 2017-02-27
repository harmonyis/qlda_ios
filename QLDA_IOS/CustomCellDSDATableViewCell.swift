//
//  CustomCellDSDATableViewCell.swift
//  QLDA_IOS
//
//  Created by Hoang The Anh on 22/02/2017.
//  Copyright © 2017 datlh. All rights reserved.
//

import UIKit

class CustomCellDSDATableViewCell: UITableViewCell {

   
    @IBOutlet weak var UIViewTieuDe: UIView!
    @IBOutlet weak var UiViewThongTinChiTiet: UIView!{
        didSet {
            UiViewThongTinChiTiet.isHidden = false
        }
    }

    @IBOutlet weak var UiViewTenDuAn: UIView!
    @IBOutlet weak var UiViewGroup: UIView!
    @IBOutlet weak var UiViewDetail: UIView!
     @IBOutlet weak var lblThoiGianThucHien: UILabel!
    @IBOutlet weak var UiViewBDThongTin: UIView!
    @IBOutlet weak var UiViewBDThongTinCT: UIView!
    @IBOutlet weak var lblGiaTriGiaiNgan: UILabel!
    @IBOutlet weak var lblTongDauTu: UILabel!
    @IBOutlet weak var lblGiaiDoan: UILabel!
    @IBOutlet weak var lblNhomDuAn: UILabel!
    @IBOutlet weak var lblTenDuAn: UILabel!
    @IBOutlet weak var imgDetail: UIImageView!
    @IBOutlet weak var imgGroup: UIImageView!{
        didSet {
            imgGroup.isHidden = false
        }
    }

    @IBOutlet weak var UiViewContent: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
