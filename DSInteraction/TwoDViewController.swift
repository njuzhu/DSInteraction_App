//
//  TwoDViewController.swift
//  DSInteraction
//
//  Created by Zhu on 15/2/27.
//  Copyright (c) 2015年 Zhu. All rights reserved.
//

import UIKit
import Foundation
import AVFoundation

class TwoDViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate, UIImagePickerControllerDelegate {

    let device = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
    let session = AVCaptureSession()
    var layer: AVCaptureVideoPreviewLayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.grayColor()
        let labIntroduction = UILabel(frame: CGRectMake(15, 80, 290, 50))
        labIntroduction.backgroundColor = UIColor.clearColor()
        labIntroduction.numberOfLines = 2
        labIntroduction.textColor = UIColor.whiteColor()
        labIntroduction.text = "将二维码图像置于矩形方框内，离手机摄像头10CM左右，系统会自动识别。"
        self.view.addSubview(labIntroduction)
        let imageView = UIImageView(frame: CGRectMake(10, 140, 300, 300))
        imageView.image = UIImage(named: "pick_bg")
        self.view.addSubview(imageView)
        
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.Default
        let item2 = UIBarButtonItem(image:(UIImage(named:"ocr_albums.png")), style:(UIBarButtonItemStyle.Bordered), target:self, action:(Selector("pickPicture")))
        let flexibleSpaceItem = UIBarButtonItem(barButtonSystemItem : (UIBarButtonSystemItem.FlexibleSpace), target: self, action: nil)
        toolBar.items = [flexibleSpaceItem,item2,flexibleSpaceItem]
        toolBar.frame = CGRectMake(0, UIScreen.mainScreen().bounds.size.height-44, 320, 44)
        self.view.addSubview(toolBar)
    }
    
    func pickPicture(){
        println("pickPicture")
        var picker:UIImagePickerController?=UIImagePickerController()
        picker?.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            self.presentViewController(picker!, animated: true, completion: nil)
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.setupCamera()
        self.session.startRunning()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupCamera() {
        self.session.sessionPreset = AVCaptureSessionPresetHigh
        var error: NSError?
        let input = AVCaptureDeviceInput(device: device, error: &error)
        if(error != nil) {
            println(error?.description)
            return
        }
        if(session.canAddInput(input)) {
            session.addInput(input)
        }
        layer = AVCaptureVideoPreviewLayer(session: session)
        layer?.videoGravity = AVLayerVideoGravityResizeAspectFill
        layer?.frame = CGRectMake(20, 150, 200, 200)
        self.view.layer.insertSublayer(self.layer, atIndex: 0)
        let output = AVCaptureMetadataOutput()
        output.setMetadataObjectsDelegate(self, queue: dispatch_get_main_queue())
        if session.canAddOutput(output) {
            session.addOutput(output)
            output.metadataObjectTypes = [AVMetadataObjectTypeQRCode];
        }
        session.startRunning()
    }
    
    func captureOutput(captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [AnyObject]!, fromConnection connection: AVCaptureConnection!) {
        var stringValue: String?
        if metadataObjects.count > 0 {
            var metadataObject = metadataObjects[0] as AVMetadataMachineReadableCodeObject
            stringValue = metadataObject.stringValue
        }
        self.session.stopRunning()
        println("code is \(stringValue)")
        var alertView = UIAlertView()
        alertView.delegate=self
        alertView.title = "二维码"
        alertView.message = "扫到的二维码内容为:\(stringValue)"
        alertView.addButtonWithTitle("确认")
        alertView.show()
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
