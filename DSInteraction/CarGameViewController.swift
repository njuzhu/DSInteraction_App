//
//  CarGameViewController.swift
//  DSInteraction
//
//  Created by Zhu on 15/3/15.
//  Copyright (c) 2015年 Zhu. All rights reserved.
//
import UIKit
import CoreMotion

class CarGameViewController: UIViewController {
    
    var startTime: String = String()
    
    @IBAction func backBtn(sender: AnyObject) {
    }
    @IBOutlet weak var tipsLB: UITextView!
    @IBOutlet weak var waitlabel: UILabel!
    @IBOutlet weak var reactLB: UILabel!
    @IBOutlet weak var waittimelabel: UILabel!
    @IBOutlet weak var point: UILabel!
    @IBOutlet weak var startLB: UIButton!
    
    @IBAction func startBtn(sender: AnyObject) {
        var btn: UIButton = sender as UIButton
        //btn.hidden = true
        
        var nowtime = NSDate()
        
        if (nowtime.earlierDate(time2) == nowtime)&&(nowtime.laterDate(time1) == nowtime){
            
            btn.hidden = true
            waitlabel.hidden = true
            waittimelabel.hidden = true
            tipsLB.hidden = false
            reactLB.hidden = false
            
            cmm=CMMotionManager()
            cmm.accelerometerUpdateInterval=1
            if cmm.accelerometerAvailable{
                var counter=0
                var content:String=" "
                cmm.startAccelerometerUpdatesToQueue(NSOperationQueue(), withHandler: {
                    (data:CMAccelerometerData!,err:NSError!) in
                    var y=NSString(format: "%f",data.acceleration.y)
                    var date = NSDate()
                    var formatter:NSDateFormatter = NSDateFormatter()
                    formatter.dateFormat = "hh:mm:ss"
                    var dateString = formatter.stringFromDate(date)
                    // println("<real>\(y)</real>")
                    dispatch_sync(dispatch_get_main_queue(), { () -> Void in
                        self.changepoint(counter, y: data.acceleration.y)
                        counter++
                        
                    })
                    
                })
            }else{
                println("unavailable")
            }
            
        }
    }
    
    var cmm:CMMotionManager!
    var points = 0
    var arr=NSArray(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("data", ofType:"plist")!)!)!
    var time1 : NSDate!
    var time2 : NSDate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        println("carGame-startTime:\(startTime)")
        // Do any additional setup after loading the view, typically from a nib.
        var format = NSDateFormatter()
        format.dateFormat = "yyyy-MM-dd HH:mm:ss"
        //
        time1 = format.dateFromString("2015-03-05 21:20:00")!
        time2 = NSDate(timeInterval: 64000000,sinceDate: time1)
        
        tipsLB.hidden = true
        reactLB.hidden = true
        
        
        
    }
    
    override func shouldAutorotate() -> Bool {
        return false
    }
    
    override func supportedInterfaceOrientations() -> Int {
        return UIInterfaceOrientationMask.Landscape.rawValue.hashValue
    }
    
    func changepoint(counter:Int,y:Double){
        if(counter<64){
            var principle=arr[counter] as Double
            println(principle)
            println(y)
            println(counter)
            println("--------------")
            
            if(fabs(principle-y)<0.1){
                points+=100
                point.text="我的得分"+String(self.points)
                reactLB.text = "干得漂亮"
            } else {
                reactLB.text = "偏了偏了！！"
            }
            
        } else{
            cmm.stopAccelerometerUpdates()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(animated: Bool) {
        if cmm.accelerometerActive {
            cmm.stopAccelerometerUpdates()
            startLB.setTitle("继续", forState: UIControlState())
            startLB.hidden = false
        }
    }
}

