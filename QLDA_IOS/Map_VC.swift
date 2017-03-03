//
//  Map_VC.swift
//  QLDA_IOS
//
//  Created by MinhHieu on 3/2/17.
//  Copyright © 2017 datlh. All rights reserved.
//

import UIKit
import GoogleMaps

class Map_VC: UIViewController {

    @IBOutlet weak var  UiMapView: GMSMapView!
    
    var mapView : GMSMapView? = nil
    static var mapItems : [MapItem]? = nil
    var makers : [GMSMarker]? = nil
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let camera: GMSCameraPosition = GMSCameraPosition.camera(withLatitude: 21.101884872388879, longitude: 105.72625648970795, zoom: 6.0)
         UiMapView.camera = camera

        getData()
       
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getData()
    {
        
        //let apiUrl : String = "\(UrlPreFix.Map.rawValue)/Map_getThongTinDuAn"
        
         let apiUrl : String = "\(UrlPreFix.Map.rawValue)/Map_getThongTinDuAn?szUsername=demo1&szPassword=abc@123"
        
        //let params : String = "{\"szUsername\" : \""+"demo1"+"\", \"szPassword\": \""+"abc@123"+"\"}"
        ApiService.Get(url: apiUrl, callback: callbackLoadDuAn, errorCallBack: errorLoaDuAn)
        
        
       
    }
    
    func callbackLoadDuAn(data : Data) {
        let json = try? JSONSerialization.jsonObject(with: data, options: [])
        if let dic = json as? [[String:Any]] {
            
            
            Map_VC.mapItems = [MapItem]()
            for item in dic {
                let mapItem = MapItem()
                let KinhDoTemp = Double((item["KinhDo"] as? String)!)
                let ViDoTemp = Double((item["ViDo"] as? String)!)
                let sTenDuAn = item["TenDuAn"] as? String
                let sDiaDiemXayDung = item["DiaDiemXayDung"] as? String
                
                mapItem.DiaDiemXayDung = sDiaDiemXayDung
                mapItem.DuAnChaID = item["DuAnChaID"]  as? Int
                mapItem.DuAnID = item["DuAnID"] as? Int
                mapItem.isDuAnCon = item["isDuAnCon"] as? Bool
                mapItem.KinhDo = KinhDoTemp
                mapItem.ViDo = ViDoTemp
                mapItem.TenDuAn = sTenDuAn
                Map_VC.mapItems?.append(mapItem)
            }
            
           
            
        }
        
        DispatchQueue.global(qos: .userInitiated).async {
            DispatchQueue.main.async {
                self.createMarker()
            }
        }
        
    }
    
    // Tạo marker trên bản đồ
    func createMarker(){
        var TotalKinhDo : Double = 0
        var TotalViDo : Double = 0
        var TotalDuAnCoViTri = 0;
        
       for item in Map_VC.mapItems!
        {
            let KinhDoTemp = item.KinhDo
            let ViDoTemp = item.ViDo
            if KinhDoTemp != nil && ViDoTemp != nil
            {
                TotalKinhDo += KinhDoTemp!
                TotalViDo += ViDoTemp!
                TotalDuAnCoViTri = TotalDuAnCoViTri + 1
                
                //Create marker
                let Position = CLLocationCoordinate2D(latitude: ViDoTemp!, longitude: KinhDoTemp!)
                let marker = GMSMarker(position: Position)
                marker.title = item.TenDuAn
                marker.snippet = item.DiaDiemXayDung
                marker.map = UiMapView

            }
        }
        
        
        if TotalDuAnCoViTri != 0
        {
            TotalKinhDo = TotalKinhDo / Double(TotalDuAnCoViTri)
            TotalViDo = TotalViDo / Double(TotalDuAnCoViTri)
            let camera = GMSCameraUpdate.setCamera(GMSCameraPosition.camera(withLatitude: TotalViDo, longitude: TotalKinhDo, zoom: 6.0))
            UiMapView.moveCamera(camera)

        }

    }
    
    
    func errorLoaDuAn(error : Error) {
        let message = error.localizedDescription
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    

}
