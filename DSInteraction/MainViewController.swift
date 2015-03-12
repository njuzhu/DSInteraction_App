//
//  MainView
//
//  MainViewController.swift
//  DSInteraction
//
//  Created by Zhu on 15/2/9.
//  Copyright (c) 2015年 Zhu. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    var visitor: String = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func personalInfoClicked(sender: AnyObject) {
        if(!visitor.isEmpty) {
            var alertView = UIAlertView()
            alertView.delegate=self
            alertView.title = "未登录用户"
            alertView.message = "请先登录，游客无个人信息"
            alertView.addButtonWithTitle("确认")
            alertView.show()
            
            let mainStoryboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
            let viewController : ViewController = mainStoryboard.instantiateViewControllerWithIdentifier("ViewController") as ViewController
            self.navigationController?.pushViewController(viewController, animated: true)
        } else {
            let mainStoryboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
            let myInfoTableViewController : MyInfoTableViewController = mainStoryboard.instantiateViewControllerWithIdentifier("MyInfoTableViewController") as MyInfoTableViewController
            self.navigationController?.pushViewController(myInfoTableViewController, animated: true)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let identifier = segue.identifier {
            if identifier == "scan" {
                var twoDViewController: TwoDViewController = segue.destinationViewController as TwoDViewController
                twoDViewController.scan = "scan"
            }
        }
    }

}
