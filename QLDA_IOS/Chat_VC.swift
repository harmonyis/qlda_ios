//
//  Chat_VC.swift
//  QLDA_IOS
//
//  Created by datlh on 2/17/17.
//  Copyright © 2017 datlh. All rights reserved.
//

import UIKit

class Chat_VC: UIViewController {
    @IBOutlet weak var imgData: UIImageView!
    @IBOutlet weak var lblChat: UILabel!
    
    var passData : String!
    var pictureUrl : String!
    var service = ApiService()
    override func viewDidLoad() {
        super.viewDidLoad()
        lblChat.text = pictureUrl
        
        if(pictureUrl == nil){
            return
        }
        /*
        if let checkedUrl = URL(string: pictureUrl) {
            imgData.contentMode = .scaleAspectFit
            downloadImage(url: checkedUrl)
        }*/
        
        //service.Get(url: pictureUrl, callback: alert, errorCallBack: alertError)
        setImageFromURl(stringImageUrl: pictureUrl)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func alert(data : Data) {
        DispatchQueue.main.async() { () -> Void in
            self.imgData.image = UIImage(data: data)
        }
    }
    
    func alertError(error : Error) {

    }
    
    func getDataFromUrl(url: URL, completion: @escaping (_ data: Data?, _  response: URLResponse?, _ error: Error?) -> Void) {
        URLSession.shared.dataTask(with: url) {
            (data, response, error) in
            completion(data, response, error)
            }.resume()
    }

    func downloadImage(url: URL) {
        getDataFromUrl(url: url) { (data, response, error)  in
            guard let data = data, error == nil else {
                DispatchQueue.main.async() { () -> Void in
                     self.imgData.image = nil
                }
                return
            }
            DispatchQueue.main.async() { () -> Void in
                //self.imgData.image = UIImage(data: data)
                let uiImg : UIImage = UIImage(data: data)!
                self.imgData.image = uiImg
            }
        }
    }
    
    func setImageFromURl(stringImageUrl url: String){
        
        if let url = NSURL(string: url) {
            if let data = NSData(contentsOf: url as URL) {
                self.imgData.image = UIImage(data: data as Data)
            }
        }
    }
}
