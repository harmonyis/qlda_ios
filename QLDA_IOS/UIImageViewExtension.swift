//
//  UIImageViewExtension.swift
//  QLDA_IOS
//
//  Created by dungnn on 3/2/17.
//  Copyright © 2017 datlh. All rights reserved.
//

import Foundation
import UIKit

extension UIImageView {
    
    func downloadImage(url:String){
        getDataFromUrl(url: url) { data in
            guard let data = data else {return}
            //print(data)
            DispatchQueue.main.async {
                self.contentMode = UIViewContentMode.scaleAspectFill
                self.image = UIImage(data: data as Data)
            }
        }
    }
    
    
    func downloadAsync(url:String) {
        let url = URL(string: url)
        
        DispatchQueue.global().async {
            let data = try? Data(contentsOf: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
            DispatchQueue.main.async {
                self.image = UIImage(data: data!)
            }
        }
    }
    
    func download(url:String) {
        let url = URL(string: url)
        let data = try? Data(contentsOf: url!)
        self.image = UIImage(data: data!)
    }
    
}

func getDataFromUrl(url:String, completion: @escaping ((_ data: NSData?) -> Void)) {
    URLSession.shared.dataTask(with: NSURL(string: url)! as URL) { (data, response, error) in
        completion(NSData(data: data!))
        }.resume()
}

