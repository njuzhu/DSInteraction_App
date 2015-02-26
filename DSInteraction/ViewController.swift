//
//  LogIn
//
//  ViewController.swift
//  DSInteraction
//
//  Created by Zhu on 15/1/31.
//  Copyright (c) 2015年 Zhu. All rights reserved.
//

import UIKit
import Alamofire
import CoreData

class ViewController: UIViewController, UITextFieldDelegate {
    
    var dataAttr:Array<AnyObject> = []
    
    @IBOutlet var email: UITextField!
    @IBOutlet var password: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        email.delegate = self
        email.becomeFirstResponder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func logIn(sender: AnyObject) {
        if (email.text == "" || password.text == "") {
            let alert = UIAlertView()
            alert.title = "请输入内容！"
            alert.message = "昵称/邮箱/密码不可为空"
            alert.addButtonWithTitle("OK")
            alert.show()
            return
        }
        if !regexMatch("[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}", matchString: email.text) {
            let alert = UIAlertView()
            alert.title = "请输入合法邮箱！"
            alert.message = "邮箱不合法"
            alert.addButtonWithTitle("OK")
            alert.show()
            return
        }
        Alamofire.request(.GET, "http://localhost:8080/DSInteraction/mobile/login.action", parameters: ["email": "\(email.text)", "password":"\(password.text)"])
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
                if let result: AnyObject = dicData["result"] {
                    let alert = UIAlertView()
                    alert.title = "请输入正确账号和密码"
                    alert.message = "账号和密码不匹配，请重新输入密码"
                    alert.addButtonWithTitle("OK")
                    self.password.text = ""
                    alert.show()
                } else {
                    let mainStoryboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
                    let mainViewNavigationController : UIViewController = mainStoryboard.instantiateViewControllerWithIdentifier("mainViewNavigation") as UIViewController
                    self.presentViewController(mainViewNavigationController, animated: true, completion: nil)
                    
                    var dictData = data! as NSDictionary
                    var dictParam = Dictionary<String, AnyObject>()
                    for (key, value) in dictData {
                        if key is String {
                            var k = key as String
                            if k == "id" {
                                dictParam["uid"] = value
                            } else {
                                dictParam[k] = value
                            }
                        }
                    }
                    MobileUserDB.insertMobileUser(dictParam)
                    println("finish login")
                }
        }
    }
    
    @IBAction func visit(sender: AnyObject) {
        println("visit")
    }
 
    // MARK: -Regex Match
    func regexMatch(pattern:String,matchString:String) -> Bool{
        var error:NSError?
        let expression = NSRegularExpression(pattern: pattern, options: .CaseInsensitive, error: &error)
        let matches = expression?.matchesInString(matchString, options: nil, range: NSMakeRange(0, countElements(matchString)))
        return matches?.count > 0
    }
}

