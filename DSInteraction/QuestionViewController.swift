
//
//  ChooseEntranceController.swift
//  DSInteraction
//  
//  Created by 王伟成 on 15/3/8.
//  Copyright (c) 2015年 Zhu. All rights reserved.
//


import Foundation
import UIKit

class QuestionViewController: UIViewController {
    
    var currentLevel = 0
    var currentQuestion = 0;
    var allQuestions = [["a"]]
    var rightAnswer = [0]
    var durations = [0]
    
    var buttonA = UIButton()
    var buttonB = UIButton()
    var buttonC = UIButton()
    var buttonD = UIButton()
    var buttonALabel = UILabel()
    var buttonBLabel = UILabel()
    var buttonCLabel = UILabel()
    var buttonDLabel = UILabel()
    var questionLabel = UILabel()
    
    var questionUpdateTimer:NSTimer?
    var countDownTimer:NSTimer?
    var timeNum = 0
    var timeLabel = UILabel()
    
    var userChoice = 0
    
    //传输到Result页面，需要显示这两个结果
    var rightNum = 0
    
    override func viewDidLoad() {
        loadQuestions()
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        println("AnswerViewController->viewDidLoad")
    }
    
    //初始化题目
    func loadQuestions(){
        request(.GET, "http://localhost:8080/DSInteraction/mobile/loadQuestions.action")
            .responseJSON { (request, response, data, error) -> Void in
                //println(data)
                if !(data is NSDictionary) {
                    let alert = UIAlertView()
                    alert.title = "网络连接错误！"
                    alert.message = "您的网络连接错误，请稍候重试"
                    alert.addButtonWithTitle("OK")
                    alert.show()
                    return
                }
                var dicData = data! as NSDictionary
                if let durations: AnyObject = dicData["durations"] {
                    self.durations = durations as [Int]
                    //println(self.durations)
                }
                if let rightAnswers: AnyObject = dicData["rightAnswers"] {
                    self.rightAnswer = rightAnswers as [Int]
                    //println(self.rightAnswer)
                }
                if let questions: AnyObject = dicData["questions"] {
                    self.allQuestions = questions as [[String]]
                    //println(self.allQuestions)
                }
                self.loadQuestionView()
        }
    }
    
    //初始化界面
    func loadQuestionView(){
        var backImageview = UIImageView()
        backImageview.frame = CGRectMake(0,0,320,568)
        var image = UIImage(named:"choices.png")
        backImageview.image = image
        self.view.addSubview(backImageview)
        
        questionLabel.frame = CGRectMake(80,100,320,80)
        questionLabel.text = allQuestions[0][0]
        questionLabel.textAlignment = .Left
        self.view.addSubview(questionLabel)
        
        buttonA.frame = CGRectMake(30,210,220,40)
        buttonA.setImage(UIImage(named:"平时状态@2x.png"),forState:.Normal)
        self.view.addSubview(buttonA)
        buttonA.addTarget(self, action:"judgeResult:",forControlEvents:.TouchUpInside)
        buttonA.tag = 1
        
        buttonALabel.frame = CGRectMake(30,210,220,40)
        buttonALabel.text = allQuestions[0][1]
        buttonALabel.textColor = UIColor.whiteColor()
        buttonALabel.textAlignment = .Center
        self.view.addSubview(buttonALabel)
        
        buttonB.frame = CGRectMake(30,260,220,40)
        buttonB.setImage(UIImage(named:"平时状态@2x.png"),forState:.Normal)
        self.view.addSubview(buttonB)
        buttonB.tag = 2
        buttonB.addTarget(self, action:"judgeResult:",forControlEvents:.TouchUpInside)
        
        buttonBLabel.frame = CGRectMake(30,260,220,40)
        buttonBLabel.text = allQuestions[0][2]
        buttonBLabel.textColor = UIColor.whiteColor()
        buttonBLabel.textAlignment = .Center
        self.view.addSubview(buttonBLabel)
        
        buttonC.frame = CGRectMake(30,310,220,40)
        buttonC.setImage(UIImage(named:"平时状态@2x.png"),forState:.Normal)
        self.view.addSubview(buttonC)
        buttonC.tag = 3
        buttonC.addTarget(self, action:"judgeResult:",forControlEvents:.TouchUpInside)
        
        buttonCLabel.frame = CGRectMake(30,310,220,40)
        buttonCLabel.text = allQuestions[0][3]
        buttonCLabel.textColor = UIColor.whiteColor()
        buttonCLabel.textAlignment = .Center
        self.view.addSubview(buttonCLabel)
        
        buttonD.frame = CGRectMake(30,360,220,40)
        buttonD.setImage(UIImage(named:"平时状态@2x.png"),forState:.Normal)
        buttonD.tag = 4
        self.view.addSubview(buttonD)
        buttonD.addTarget(self, action:"judgeResult:",forControlEvents:.TouchUpInside)
        
        buttonDLabel.frame = CGRectMake(30,360,220,40)
        buttonDLabel.text = allQuestions[0][4]
        buttonDLabel.textColor = UIColor.whiteColor()
        buttonDLabel.textAlignment = .Center
        self.view.addSubview(buttonDLabel)
        
        
        timeLabel.frame = CGRectMake(50,30,400,30)
        timeLabel.text = "还有00:\(timeNum)秒显示正确答案！"
        timeLabel.textColor = UIColor.redColor()
        timeLabel.textAlignment = .Left
        self.view.addSubview(timeLabel)
        
        timeNum = durations[0]
        
        countDownTimer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector:"updateTimer", userInfo: nil, repeats: true)
    }
    
    //在返回答题页面时，将选项设为可点击，之后可能完全不需要
    func setOriginState() {
        timeNum = 20
        currentQuestion = 0
        rightNum = 0
        buttonA.setImage(UIImage(named:"平时状态@2x.png"),forState:.Normal)
        buttonB.setImage(UIImage(named:"平时状态@2x.png"),forState:.Normal)
        buttonC.setImage(UIImage(named:"平时状态@2x.png"),forState:.Normal)
        buttonD.setImage(UIImage(named:"平时状态@2x.png"),forState:.Normal)
        
        buttonA.enabled = true
        buttonB.enabled = true
        buttonC.enabled = true
        buttonD.enabled = true
        
        questionLabel.text = allQuestions[currentQuestion][0]
        buttonALabel.text = allQuestions[currentQuestion][1]
        buttonBLabel.text = allQuestions[currentQuestion][2]
        buttonCLabel.text = allQuestions[currentQuestion][3]
        buttonDLabel.text = allQuestions[currentQuestion][4]
        
    }

    
    func judgeResult(sender:UIButton){
        
        userChoice = sender.tag

        buttonA.enabled = false
        buttonB.enabled = false
        buttonC.enabled = false
        buttonD.enabled = false
        
    }
    
    func showResult(){
        if userChoice == 1 {
            if userChoice == rightAnswer[currentQuestion] {
                buttonA.setImage(UIImage(named:"答对@2x.png"),forState:.Normal)
                rightNum++
            }
            else {
                buttonA.setImage(UIImage(named:"答错@2x.png"),forState:.Normal)
            }
        }
        
        if userChoice == 2 {
            if userChoice == rightAnswer[currentQuestion] {
                buttonB.setImage(UIImage(named:"答对@2x.png"),forState:.Normal)
                rightNum++
            }
            else {
                buttonB.setImage(UIImage(named:"答错@2x.png"),forState:.Normal)
            }
        }
        
        if userChoice == 3 {
            if userChoice == rightAnswer[currentQuestion] {
                buttonC.setImage(UIImage(named:"答对@2x.png"),forState:.Normal)
                rightNum++
            }
            else {
                buttonC.setImage(UIImage(named:"答错@2x.png"),forState:.Normal)
            }
        }
        
        if userChoice == 4 {
            if userChoice == rightAnswer[currentQuestion] {
                buttonD.setImage(UIImage(named:"答对@2x.png"),forState:.Normal)
                rightNum++
            }
            else {
                buttonD.setImage(UIImage(named:"答错@2x.png"),forState:.Normal)
            }
        }
        
    }
    
    func updateQuestion() {
        
        currentQuestion++
        
        if currentQuestion >= allQuestions.count {
            //跳到结果界面
            var rvc = ResultViewController()
            rvc.totalNum = self.allQuestions.count
            rvc.rightNum = self.rightNum
            rvc.wrongNum = self.allQuestions.count - self.rightNum
            
            self.presentViewController(rvc, animated: true, completion: nil)
            return
        }
        
        buttonA.enabled = true
        buttonB.enabled = true
        buttonC.enabled = true
        buttonD.enabled = true
        
        questionLabel.text = allQuestions[currentQuestion][0]
        buttonALabel.text = allQuestions[currentQuestion][1]
        buttonBLabel.text = allQuestions[currentQuestion][2]
        buttonCLabel.text = allQuestions[currentQuestion][3]
        buttonDLabel.text = allQuestions[currentQuestion][4]
        
        //var sender = questionUpdateTimer?.userInfo as UIButton
        //sender.setImage(UIImage(named:"平时状态@2x.png"),forState:.Normal)
        
        renewButton()
        resetCountDownTimer()
    }
    
    func renewButton(){
        buttonA.setImage(UIImage(named:"平时状态@2x.png"),forState:.Normal)
        buttonB.setImage(UIImage(named:"平时状态@2x.png"),forState:.Normal)
        buttonC.setImage(UIImage(named:"平时状态@2x.png"),forState:.Normal)
        buttonD.setImage(UIImage(named:"平时状态@2x.png"),forState:.Normal)
    }
    
    func updateTimer() {
        timeNum--;
        
        if timeNum <= 0 {
            countDownTimer?.invalidate()
            
            //显示正确答案
            showResult()
            
            //过1秒钟，去更新题目和选项,重启定时器
            questionUpdateTimer?.invalidate()
            questionUpdateTimer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector:"updateQuestion", userInfo: nil, repeats: false)
            
            //定时器设为下一题需要的时间
            
            //var alert = UIAlertController(title: "提示", message: "亲，时间已到！", preferredStyle: .Alert)
            //self.presentViewController(alert, animated: true, completion: nil)
        }
        
        if timeNum < 10 {
            timeLabel.text = "还有00:0\(timeNum)秒显示正确答案！"
        }
        else {
            timeLabel.text = "还有00:\(timeNum)秒显示正确答案！"
        }
        
    }
    
    //重启计时器
    func resetCountDownTimer(){
        timeNum = durations[currentQuestion]
        countDownTimer?.invalidate()
        countDownTimer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector:"updateTimer", userInfo: nil, repeats: true)
        updateTimer()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool){
        //countDownTimer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector:"updateTimer", userInfo: nil, repeats: true)
        //setOriginState()
    }
    
    override func viewDidAppear(animated: Bool){

    }
    
    //页面消失时，更新定时器，之后改为跳转到下一题时更新
    override func viewWillDisappear(animated: Bool){
        countDownTimer?.invalidate()
    }
    
    override func viewDidDisappear(animated: Bool){

    }
    
}
