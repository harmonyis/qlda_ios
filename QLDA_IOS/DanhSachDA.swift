//
//  NhomDA.swift
//  QLDA_IOS
//
//  Created by Hoang The Anh on 21/02/2017.
//  Copyright © 2017 datlh. All rights reserved.
//

import Foundation
class DanhSachDA{
    
    init() {
        IdDA=""
        TenDA = ""
        NhomDA = ""
        GiaTriGiaiNgan = ""
        TongMucDauTu = ""
        ThoiGianThucHien = ""
        GiaiDoan = ""
        Status=false
        DuAnCon=[DuAn]()
    }
    var IdDA : String?
    var TenDA : String?
    var NhomDA : String?
    var TongMucDauTu : String?
    var GiaTriGiaiNgan : String?
    var ThoiGianThucHien : String?
    var GiaiDoan : String?
    var Status : Bool?

    var DuAnCon : [DuAn]?
}
