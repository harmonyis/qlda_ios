
import UIKit

class Base_VC: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.addLeftBarButton()
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
        self.addRightBarButton()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func addLeftBarButton(){
        let btnShowMenu = UIButton(type: UIButtonType.system)
        btnShowMenu.setImage(self.defaultMenuImage(), for: UIControlState())
        btnShowMenu.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        //btnShowMenu.target = self.revealViewController()
        //btnShowMenu.action = Selector("revealToggle:")
        //btnShowMenu.addTarget(self, action: Selector("revealToggle:")), for: UIControlEvents.touchUpInside)
        
        btnShowMenu.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: UIControlEvents.touchUpInside)
        let customBarItem = UIBarButtonItem(customView: btnShowMenu)
        self.navigationItem.leftBarButtonItem = customBarItem;
    }
    
    func defaultMenuImage() -> UIImage {
        var defaultMenuImage = UIImage()
        
        UIGraphicsBeginImageContextWithOptions(CGSize(width: 30, height: 22), false, 0.0)
        
        UIColor.black.setFill()
        UIBezierPath(rect: CGRect(x: 0, y: 3, width: 30, height: 1)).fill()
        UIBezierPath(rect: CGRect(x: 0, y: 10, width: 30, height: 1)).fill()
        UIBezierPath(rect: CGRect(x: 0, y: 17, width: 30, height: 1)).fill()
        
        UIColor.white.setFill()
        UIBezierPath(rect: CGRect(x: 0, y: 4, width: 30, height: 1)).fill()
        UIBezierPath(rect: CGRect(x: 0, y: 11,  width: 30, height: 1)).fill()
        UIBezierPath(rect: CGRect(x: 0, y: 18, width: 30, height: 1)).fill()
        
        defaultMenuImage = UIGraphicsGetImageFromCurrentImageContext()!
        
        UIGraphicsEndImageContext()
        
        return defaultMenuImage;
    }
    
    func addRightBarButton(){
        let btnNotiMenu = UIButton(type: UIButtonType.system)
        btnNotiMenu.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        btnNotiMenu.setImage(UIImage(named: "ic_noti"), for: UIControlState())
        btnNotiMenu.imageEdgeInsets = UIEdgeInsets(top: 30, left: 30, bottom: 30, right: 30)
        let customNotiBarItem = UIBarButtonItem(customView: btnNotiMenu)
        
        let btnChatMenu = UIButton(type: UIButtonType.system)
        btnChatMenu.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        btnChatMenu.addTarget(self, action: #selector(Base_VC.onChatBarPressesd(_:)), for: UIControlEvents.touchUpInside)
        btnChatMenu.setImage(UIImage(named: "HomeIcon"), for: UIControlState())
        btnChatMenu.imageEdgeInsets = UIEdgeInsets(top: 30, left: 30, bottom: 30, right: 30)
        let frame = CGRect(x: 18, y: -4, width: 15, height: 15)
        createBadge(parent: btnChatMenu, tag: 200, number: 0, frame: frame)
        //btnChatMenu.createBadge(tag: 200, number: 0, frame: frame)
        let customChatBarItem = UIBarButtonItem(customView: btnChatMenu)
        
        let btnMapMenu = UIButton(type: UIButtonType.system)
        btnMapMenu.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        btnMapMenu.addTarget(self, action: #selector(Base_VC.onMapBarPressesd(_:)), for: UIControlEvents.touchUpInside)
        btnMapMenu.setImage(UIImage(named: "ic_map"), for: UIControlState())
        btnMapMenu.imageEdgeInsets = UIEdgeInsets(top: 30, left: 30, bottom: 30, right: 30)
        let customMapBarItem = UIBarButtonItem(customView: btnMapMenu)
        
        
        //self.navigationItem.rightBarButtonItems = [customNotiBarItem, customChatBarItem, customMapBarItem]
        self.navigationItem.setRightBarButtonItems([customNotiBarItem, customChatBarItem, customMapBarItem], animated: true)
        
        updateBadgeChat()
        initEnvent()
    }
    
    func onChatBarPressesd(_ sender : UIButton){
        Config.SelectMenuIndex = -1
        let vc = storyboard?.instantiateViewController(withIdentifier: "ChatMain") as! ChatMain_VC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func onMapBarPressesd(_ sender : UIButton){
        Config.SelectMenuIndex = -1
        let vc = storyboard?.instantiateViewController(withIdentifier: "Map") as! Map_VC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func initEnvent(){
        //ChatHub.addChatHub(hub:  ChatHub.chatHub)

        ChatHub.chatHub.on("receivePrivateMessage") {args in
            self.updateBadgeChat()
        }
        ChatHub.chatHub.on("receiveGroupMessage") {args in
            self.updateBadgeChat()
        }
        ChatHub.chatHub.on("receiveChatGroup") {args in
            self.updateBadgeChat()
        }
    }
    
    func updateBadgeChat(){
        let btn : UIBarButtonItem = (self.navigationItem.rightBarButtonItems?[1])! as UIBarButtonItem
    
        let label : UILabel = btn.customView?.viewWithTag(200) as! UILabel
        let count = getNumberBadgeChat()
        if(count > 0){
            label.text = String(count)
            label.isHidden = false
        }
        else{
            label.text = ""
            label.isHidden = true
        }
    }
    private func getNumberBadgeChat() -> Int{
        let list = ChatCommon.listContact.filter(){
            if $0.NumberOfNewMessage! > 0 {
                return true
            } else {
                return false
            }
        }
        return list.count
    }
    
    func createBadge(parent : UIView, tag : Int, number : Int, frame : CGRect){
        let label = UILabel(frame: frame)
        label.layer.borderColor = UIColor.clear.cgColor
        label.layer.borderWidth = 2
        label.layer.cornerRadius = label.bounds.size.height / 2
        label.textAlignment = .center
        label.layer.masksToBounds = true
        label.font = UIFont.systemFont(ofSize: 10)
        label.textColor = .white
        label.backgroundColor = .red
        label.tag = tag
        
        if(number > 0){
            label.text = String(number)
            label.isHidden = false
        }
        else{
            label.text = ""
            label.isHidden = true
        }
        parent.addSubview(label)
    }
}
