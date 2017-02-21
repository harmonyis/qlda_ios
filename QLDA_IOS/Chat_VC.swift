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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lblChat.text = pictureUrl
        
        //if let checkedUrl = URL(string: pictureUrl) {
            //imgData.contentMode = .scaleAspectFit
            //downloadImage(url: checkedUrl)
        //}
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func getDataFromUrl(url: URL, completion: @escaping (_ data: Data?, _  response: URLResponse?, _ error: Error?) -> Void) {
        URLSession.shared.dataTask(with: url) {
            (data, response, error) in
            completion(data, response, error)
            }.resume()
    }

    func downloadImage(url: URL) {
        print("Download Started")
        getDataFromUrl(url: url) { (data, response, error)  in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            print("Download Finished")
            DispatchQueue.main.async() { () -> Void in
                self.imgData.image = UIImage(data: data)
            }
        }
    }
}
