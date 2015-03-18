
//
//  ChooseEntranceController.swift
//  DSInteraction
//
//  Created by 王伟成 on 15/3/8.
//  Copyright (c) 2015年 Zhu. All rights reserved.
//

import Foundation
import UIKit

class ResultViewController: UIViewController {
    
    var totalNum = 0
    var rightNum = 0
    var wrongNum = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        println("ResultViewController->viewDidLoad")
        
        var backImageview = UIImageView()
        backImageview.frame = CGRectMake(0,0,320,568)
        var image = UIImage(named:"background.png")
        backImageview.image = image
        self.view.addSubview(backImageview)
        
        var totalLabel = UILabel()
        totalLabel.frame = CGRectMake(100,140,320,40)
        totalLabel.text = "答题总数：\(totalNum)"
        totalLabel.textColor = UIColor.redColor()
        self.view.addSubview(totalLabel)
        
        var rightLabel = UILabel()
        rightLabel.frame = CGRectMake(100,180,320,40)
        rightLabel.text = "答对题数：\(rightNum)"
        rightLabel.textColor = UIColor.redColor()
        self.view.addSubview(rightLabel)
        
        var wrongLabel = UILabel()
        wrongLabel.frame = CGRectMake(100,220,320,40)
        wrongLabel.text = "答错题数：\(wrongNum)"
        wrongLabel.textColor = UIColor.redColor()
        self.view.addSubview(wrongLabel)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  
}
