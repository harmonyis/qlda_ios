//
//  QLHA_VC.swift
//  QLDA_IOS
//
//  Created by datlh on 2/20/17.
//  Copyright © 2017 datlh. All rights reserved.
//

import UIKit

class QLHinhAnh_VC: Base_VC ,UICollectionViewDataSource, UICollectionViewDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate{
    
    @IBOutlet weak var clv: UICollectionView!
    var imagePicker = UIImagePickerController()
    
    let reuseIdentifier = "cell" // also enter this string as the cell identifier in the storyboard
    var items : [ImageEntity] = []
    
    let ApiUrl : String = "\(UrlPreFix.Camera.rawValue)/GetAllFileUpload"
    
    var idDuAn : Int = 0
    var listName : String = ""
    var userName : String = ""
    var password : String = ""
    
    
    
    @IBAction func btnGallery(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.savedPhotosAlbum){
            imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary;
            imagePicker.allowsEditing = false
            
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            let newImg = resizeImage(image: image, newWidth: 540)
            //imageView.image = image
            let data = UIImageJPEGRepresentation(newImg, 1.0)
            let array = [UInt8](data!)
            
            //let jsonResult = JSONSerializer.toJson(dataImage)
            
            let uuid = UUID().uuidString
            
            let jsonResult = "{\"ImageName\":\"\(uuid).jpg\",\"ListName\":\"\(listName)\",\"IDItem\":\(idDuAn),\"ImageData\":\(array)}"
            
            let params : String = "{\"userName\" : \"\(userName)\", \"password\": \"\(password)\", \"data\":\(jsonResult)}"
            
            
            //print(params)
            
            
            let ApiUrl : String = "\(UrlPreFix.Camera.rawValue)/UploadImage"
            
            ApiService.Post(url: ApiUrl, params: params, callback: PostImageSuccess, errorCallBack: { (error) in
                print("error")
                print(error.localizedDescription)
            })
            
            
        } else{
            print("Something went wrong")
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func PostImageSuccess(data:Data) {
        let json = try? JSONSerialization.jsonObject(with: data, options: [])
        if let methodResult = json as? [String:Any] {
            if let uploadImageResult = methodResult["UploadImageResult"] as? [String: Any] {
                if let dataResult = uploadImageResult["DataResult"] as? [String : Any] {
                    //print(dataResult)
                    DispatchQueue.global(qos: .userInitiated).async {
                        // Bounce back to the main thread to update the UI
                        DispatchQueue.main.async {
                            let imgEntity = ImageEntity()
                            imgEntity.ImageName = dataResult["ImageName"] as! String
                            imgEntity.ItemId = String(self.idDuAn)
                            imgEntity.ListName = self.listName
                            self.items.insert(imgEntity, at: 0)
                            //self.items.append(imgEntity)
                            
                            self.clv.reloadData()
                        }
                        
                    }
                }
            }
        }
        
    }
    
    func resizeImage(image: UIImage, newWidth: CGFloat) -> UIImage {
        
        let scale = newWidth / image.size.width
        let newHeight = image.size.height * scale
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
        image.draw(in: CGRect( x: 0, y : 0,width: newWidth,height: newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: { () -> Void in
            
        })
        
    }
    
    
    func GetDSHASuccess(data : Data) {
        //let result = String(data: data, encoding: String.Encoding.utf8)
        
        
        //print(result)
        let json = try? JSONSerialization.jsonObject(with: data, options: [])
        
        if let dic = json as? [String:Any] {
            if let dataResult = dic["GetAllFileUploadResult"] as? [String:Any] {
                if let array = dataResult["DataResult"] as? [[String:Any]] {
                    var image : ImageEntity
                    for obj in array {
                        
                        image = ImageEntity()
                        image.ImageName = obj["ImageName"] as! String
                        image.ItemId = obj["Item"] as! String
                        image.ListName = obj["ListName"] as! String
                        
                        items.append(image)
                    }
                    
                    DispatchQueue.global(qos: .userInitiated).async {
                        // Bounce back to the main thread to update the UI
                        DispatchQueue.main.async {
                            
                            self.clv.reloadData()
                        }
                    }
                }
            }
        }
        
        
        //print(json)
    }
    
    
    func GetDSHAError(error : Error) {
        let message = error.localizedDescription
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    // tell the collection view how many cells to make
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.items.count
    }
    
    // make a cell for each cell index path
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // get a reference to our storyboard cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath) as! MyCollectionViewCell
        
        let imageName = items[indexPath.row].ImageName.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        
        let url = "http://harmonysoft.vn:8089/UploadFile/DuAn/\(items[indexPath.row].ItemId)/Icon/\(imageName!)"
        //print(url)
        cell.imgHinhAnh.downloadImage(url: url)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize
    {
        
        return CGSize(width: collectionView.frame.size.width/4.08, height: collectionView.frame.size.width/4.08)
        
    }
    
    
    func getDataFromUrl(url: URL, completion: @escaping (_ data: Data?, _  response: URLResponse?, _ error: Error?, _ imageView : UIImageView) -> Void, _ imageView : UIImageView) {
        URLSession.shared.dataTask(with: url) {
            (data, response, error) in
            completion(data, response, error, imageView)
            }.resume()
    }
    
    
    // MARK: - UICollectionViewDelegate protocol
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        //let myVC = storyboard?.instantiateViewController(withIdentifier: "ViewImageDetailViewController") as! ViewImageDetailViewController
        //let myVC = storyboard?.instantiateViewController(withIdentifier: "DemoViewController") as! DemoViewController
        
       // let imageName = items[indexPath.row].ImageName.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        
        //let url = "http://harmonysoft.vn:8089/UploadFile/DuAn/\(items[indexPath.row].ItemId)/Image/\(imageName!)"
        //print(url)
        
        //myVC.imageView.downloadImage(url: url)
       // myVC.imageUrl = url
        //navigationController?.pushViewController(myVC, animated: true)
        //self.presentImageGallery()
        // handle tap events
        print("You selected cell #\(indexPath.item)!")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Danh sách hình ảnh"
        self.idDuAn = 142
        self.listName = "DuAn"
        self.userName = "administrator"
        self.password = "abc@123"
        
        let params : String = "{\"userName\" : \"\(userName)\", \"password\": \"\(password)\"}"
        ApiService.Post(url: ApiUrl, params: params, callback: GetDSHASuccess, errorCallBack: GetDSHAError)
        imagePicker.delegate = self
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        // Dispose of any resources that can be recreated.
    }
    
}
