//
//  NicknameEditViewController.swift
//  DSInteraction
//
//  Created by Zhu on 15/2/25.
//  Copyright (c) 2015年 Zhu. All rights reserved.
//

import UIKit
import Alamofire

class NicknameEditViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet var nicknameField: UITextField!
    var mobileUser: MobileUser!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        nicknameField.delegate = self
        nicknameField.becomeFirstResponder()
        
        var mobileUsers: Array<AnyObject> = MobileUserDB.getAllMobileUsers()
        if(mobileUsers.count > 0) {
            mobileUser = mobileUsers[0] as MobileUser
            nicknameField.text = mobileUser.name
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func saveClicked(sender: UIBarButtonItem) {
        if (nicknameField.text == "") {
            let alert = UIAlertView()
            alert.title = "请输入内容！"
            alert.message = "昵称不可为空"
            alert.addButtonWithTitle("OK")
            alert.show()
            nicknameField.text = mobileUser.name
            return
        }
        Alamofire.request(.GET, "http://localhost:8080/DSInteraction/mobile/updateByName.action", parameters: ["id": "\(mobileUser.uid)",
            "name":"\(nicknameField.text)"])
            .responseJSON { (request, response, data, error) -> Void in
                if !(data is NSDictionary) {
                    let alert = UIAlertView()
                    alert.title = "网络连接错误！"
                    alert.message = "您的网络连接错误，请稍候重试"
                    alert.addButtonWithTitle("OK")
                    alert.show()
                    return
                }
                var dicData = data! as NSDictionary
                var result = dicData["result"] as NSString
                if(result == "success") {
                    var dataDict = Dictionary<String, AnyObject>()
                    dataDict["name"] = self.nicknameField.text as AnyObject
                    MobileUserDB.updateMobileUser(dataDict, obj: self.mobileUser)
                    
                    let mainStoryboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
                    let mainViewNavigationController : MyInfoTableViewController = mainStoryboard.instantiateViewControllerWithIdentifier("MyInfoTableViewController") as MyInfoTableViewController
                    self.navigationController?.pushViewController(mainViewNavigationController, animated: true)
                    println("finish revise nickname")
                } else {
                    let alert = UIAlertView()
                    alert.title = "修改错误！"
                    alert.message = "修改有误，请稍候重试"
                    alert.addButtonWithTitle("OK")
                    alert.show()
                    return
                }
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
