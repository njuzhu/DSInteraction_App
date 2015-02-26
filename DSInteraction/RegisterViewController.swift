//
//  Register
//
//  RegisterViewController.swift
//  DSInteraction
//
//  Created by Zhu on 15/2/10.
//  Copyright (c) 2015年 Zhu. All rights reserved.
//

import UIKit
import Alamofire

class RegisterViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet var name: UITextField!
    @IBOutlet var email: UITextField!
    @IBOutlet var password: UITextField!
    @IBOutlet var passwordConfirm: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        name.delegate = self
        name.becomeFirstResponder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        name.becomeFirstResponder()
    }
    

    @IBAction func register(sender: AnyObject) {
        if (name.text == "" || email.text == "" || password.text == "" || passwordConfirm.text == "") {
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
        if (password.text != passwordConfirm.text) {
            let alert = UIAlertView()
            alert.title = "密码前后不一致！"
            alert.message = "请重新输入密码"
            alert.addButtonWithTitle("OK")
            password.text = ""
            passwordConfirm.text = ""
            alert.show()
        }
        Alamofire.request(.GET, "http://localhost:8080/DSInteraction/mobile/register.action", parameters: ["email": "\(email.text)", "password":"\(password.text)", "name":"\(name.text)"])
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
                    alert.title = "该email已存在！"
                    alert.message = "请重新输入email"
                    alert.addButtonWithTitle("OK")
                    self.email.text = ""
                    self.password.text = ""
                    self.passwordConfirm.text = ""
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
                    println("finish register")
                }
        }
    }
    
    
    
    // MARK: -Regex Match
    func regexMatch(pattern:String,matchString:String) -> Bool{
        var error:NSError?
        let expression = NSRegularExpression(pattern: pattern, options: .CaseInsensitive, error: &error)
        let matches = expression?.matchesInString(matchString, options: nil, range: NSMakeRange(0, countElements(matchString)))
        return matches?.count > 0
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
