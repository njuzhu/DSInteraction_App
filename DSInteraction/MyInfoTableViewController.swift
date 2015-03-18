//
//  MyInfoTableViewController.swift
//  DSInteraction
//
//  Created by Zhu on 15/2/21.
//  Copyright (c) 2015年 Zhu. All rights reserved.
//

import UIKit

class MyInfoTableViewController: UITableViewController, UIImagePickerControllerDelegate, UIActionSheetDelegate, UINavigationControllerDelegate {

    var mobileUsers:Array<AnyObject> = MobileUserDB.getAllMobileUsers()

    var picker:UIImagePickerController?=UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        picker?.delegate = self
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
//        
//        // visitor
//        if(mobileUsers.count == 0) {
//            
//        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return 4
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var mobileuser: MobileUser!
        var exist = false
        if(mobileUsers.count > 0) {
            mobileuser = mobileUsers[0] as MobileUser
            exist = true
        }
        var identifier: NSString
        var value: NSString = ""
        var isDiy = false
        switch indexPath.row {
        case 0:
            if(exist && mobileuser.image != "") {
                value =  mobileuser.image
                isDiy = true
            }
            identifier = "iconCell"
            break
        case 1:
            if(exist && mobileuser.name != "") {
                value = mobileuser.name
            }
            identifier = "nicknameCell"
            break
        case 2:
            if(exist && mobileuser.email != "") {
                value = mobileuser.email
            }
            identifier = "emailCell"
            break
        case 3:
            if(exist && mobileuser.point != "") {
                value = mobileuser.point.stringValue
            } else {
                value = "0"
            }
            identifier = "pointCell"
            break
        default:
            identifier = ""
        }
        
        let cell = tableView.dequeueReusableCellWithIdentifier(identifier, forIndexPath: indexPath) as UITableViewCell

        // Configure the cell...
        if(indexPath.row == 0) {
            var iconImage = cell.viewWithTag(4) as UIImageView
            if(isDiy) {
                iconImage.image = UIImage(contentsOfFile: value)
            } else {
                iconImage.image = UIImage(named: "icon_default.png")
            }
        } else {
            cell.detailTextLabel?.text = value
        }

        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch(indexPath.row) {
        case 0:
            self.imageCellClicked()
            break;
        default:
            return
        }
    }
    
    func imageCellClicked() {
        if objc_getClass("UIAlertController") != nil {
            // use UIAlertController
            var alert:UIAlertController=UIAlertController(title: "头像选择", message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
            var cameraAction = UIAlertAction(title: "相机", style: UIAlertActionStyle.Default, handler: {UIAlertAction in self.openCamera()})
            var gallaryAction = UIAlertAction(title: "相册", style: UIAlertActionStyle.Default, handler: {UIAlertAction in self.openGallary()})
            var cancelAction = UIAlertAction(title: "取消", style: UIAlertActionStyle.Cancel, handler: {UIAlertAction in self.imagePickerControllerDidCancel(self.picker!)})
            
            alert.addAction(cameraAction)
            alert.addAction(gallaryAction)
            alert.addAction(cancelAction)
            
            // Present the actionsheet
            if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
                self.presentViewController(alert, animated: true, completion: nil)
            }
        } else {
            // user UIActionSheet
            var alert = UIActionSheet(title: "头像选择", delegate: self, cancelButtonTitle: nil, destructiveButtonTitle: nil)
            alert.addButtonWithTitle("相机")
            alert.addButtonWithTitle("相册")
            alert.addButtonWithTitle("取消")
            alert.cancelButtonIndex = 2
            // Present the actionsheet
            if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
                alert.showFromRect(self.view.bounds, inView: self.view, animated: true)
            }
        }
    }
    
    func actionSheet(actionSheet: UIActionSheet, clickedButtonAtIndex buttonIndex: Int) {
        if (buttonIndex == actionSheet.cancelButtonIndex) {
            return
        }
        switch(buttonIndex) {
        case 0:
            self.openCamera()
            break
        case 1:
            self.openGallary()
            break
        default:
            return
        }
    }
    
    func openCamera() {
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)) {
            println("camera")
            picker?.sourceType = UIImagePickerControllerSourceType.Camera
            self.presentViewController(picker!, animated: true, completion: nil)
            
        } else {
            openGallary()
        }
    }
    
    func openGallary() {
        println("gallary")
        picker?.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            self.presentViewController(picker!, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        picker.dismissViewControllerAnimated(true, completion: nil)
        
        var filenamePrefix: String = String()
        var fileManager: NSFileManager = NSFileManager.defaultManager()
        if(mobileUsers.count > 0) {
            var mobileUser = mobileUsers[0] as MobileUser
            filenamePrefix = mobileUser.email.stringByAppendingString(".")
            let pathOrigin: String = mobileUser.image
            if fileManager.fileExistsAtPath(pathOrigin) {
//            println("removeFile")
                fileManager.removeItemAtPath(pathOrigin, error: nil)
            }
        }
        
        var image: UIImage = info[UIImagePickerControllerOriginalImage] as UIImage
        var resizeImage: UIImage = self.resizeImage(image, toSize: CGSizeMake(50, 50))
//        println(resizeImage.description)
        var description: String = resizeImage.description
        var range = description.rangeOfString("<")?.startIndex
        var fromIndex: Int = distance(description.startIndex, range!)
        fromIndex += 10
        range = description.rangeOfString(">")?.startIndex
        var endIndex: Int = distance(description.startIndex, range!)
        var filename: String = description.substringWithRange(Range<String.Index>(start: advance(description.startIndex, fromIndex), end: advance(description.startIndex, endIndex))).stringByAppendingString(".png")
        filename = filenamePrefix.stringByAppendingString(filename)
        var path: String = self.documentsDirectory().stringByAppendingPathComponent(filename)
        
        UIImagePNGRepresentation(resizeImage).writeToFile(path, atomically: true)
        println("path:\(path)")
        
        if(mobileUsers.count > 0) {
            var mobileUser = mobileUsers[0] as MobileUser
            var dataDict = Dictionary<String, AnyObject>()
            dataDict["image"] = path
            MobileUserDB.updateMobileUser(dataDict, obj: mobileUser)
//            var user = MobileUserDB.getAllMobileUsers()[0] as MobileUser
//            println("user.image:\(user.image)")
        }
        self.tableView.reloadData()
        
//        self.uploadImage(UIImagePNGRepresentation(resizeImage))
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        picker.dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func logoutClicked(sender: UIButton) {
        MobileUserDB.deleteAllMobileUsers()
        let mainStoryboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        let viewController : ViewController = mainStoryboard.instantiateViewControllerWithIdentifier("ViewController") as ViewController
        self.presentViewController(viewController, animated: true, completion: nil)
    }

    // Get the documents Directory
    func documentsDirectory() -> String {
        let documentsFolderPathArray = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)
        var documentsFolderPath = ""
        if documentsFolderPathArray.count > 0 {
            documentsFolderPath = documentsFolderPathArray[0] as String
        }
//        println(documentsFolderPath)
        return documentsFolderPath
    }
    // Get path for a file in the directory
    func fileInDocumentsDirectory(filename: String) -> String {
        return documentsDirectory().stringByAppendingPathComponent(filename)
    }
    
    // Resize image
    func resizeImage(image: UIImage, toSize: CGSize) -> UIImage {
        UIGraphicsBeginImageContext(CGSizeMake(toSize.width, toSize.height))
        image.drawInRect(CGRectMake(0, 0, toSize.width, toSize.height))
        var resizeImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return resizeImage
    }
    
    func uploadImage(data: NSData) {
//        let data=UIImagePNGRepresentation(img)//把图片转成data
        
        let uploadurl:String="http://localhost:8080/DSInteraction/mobile/uploadImage.action"//设置服务器接收地址
        let request=NSMutableURLRequest(URL:NSURL(string:uploadurl)!)
        
        request.HTTPMethod="POST"//设置请求方式
        var boundary:String="-------------------21212222222222222222222"
        var contentType:String="multipart/form-data;boundary="+boundary
        request.addValue(contentType, forHTTPHeaderField:"Content-Type")
        var body=NSMutableData()
        body.appendData(NSString(format:"\r\n--\(boundary)\r\n").dataUsingEncoding(NSUTF8StringEncoding)!)
        body.appendData(NSString(format:"Content-Disposition:form-data;name=\"userfile\";filename=\"dd.jpg\"\r\n").dataUsingEncoding(NSUTF8StringEncoding)!)
        body.appendData(NSString(format:"Content-Type:application/octet-stream\r\n\r\n").dataUsingEncoding(NSUTF8StringEncoding)!)
//        body.appendData(data)
        body.appendData(NSString(format:"\r\n--\(boundary)").dataUsingEncoding(NSUTF8StringEncoding)!)
        println("body:\(body)")
        request.HTTPBody=body
        
        let que=NSOperationQueue()
        
//        println("request:\(request.HTTPBody)")
        NSURLConnection.sendAsynchronousRequest(request, queue: que, completionHandler: {
            (response, data, error) ->Void in
            
            if (error != nil){
                println(error)
            }else{
                //Handle data in NSData type
                var tr:String=NSString(data:data,encoding:NSUTF8StringEncoding)!
                println(tr)
                
            }
        })
    }
    
//    
//    func uploadImage(imageData: NSData) {
//        // init paramters Dictionary
//        var parameters = [
//            "task": "task",
//            "variable1": "var"
//        ]
//        
//        // add addtionial parameters
//        parameters["userId"] = "27"
//        parameters["body"] = "This is the body text."
//        
//        // example image data
////        let image = UIImage(named: "177143.jpg")
////        let imageData = UIImagePNGRepresentation(image)
//        
//        // CREATE AND SEND REQUEST ----------
//        let urlRequest = urlRequestWithComponents("http://localhost:8080/DSInteraction/mobile/uploadImage.action", parameters: parameters, imageData: imageData)
//        
//        
//        println("urlRequest.1:\(urlRequest.1)")
//        
//        upload(urlRequest.0, urlRequest.1)
//            .progress { (bytesWritten, totalBytesWritten, totalBytesExpectedToWrite) in
//                println("\(totalBytesWritten) / \(totalBytesExpectedToWrite)")
//            }
//            .responseJSON { (request, response, JSON, error) in
//                println("REQUEST \(request)")
//                println("RESPONSE \(response)")
//                println("JSON \(JSON)")
//                println("ERROR \(error)")
//        }
//    }
//    
//    // this function creates the required URLRequestConvertible and NSData we need to use Alamofire.upload
//    func urlRequestWithComponents(urlString:String, parameters:Dictionary<String, String>, imageData:NSData) -> (URLRequestConvertible, NSData) {
//        
//        // create url request to send
//        var mutableURLRequest = NSMutableURLRequest(URL: NSURL(string: urlString)!)
//        mutableURLRequest.HTTPMethod = Method.POST.rawValue
//        let boundaryConstant = "myRandomBoundary12345";
//        let contentType = "multipart/form-data;boundary="+boundaryConstant
//        mutableURLRequest.setValue(contentType, forHTTPHeaderField: "Content-Type")
//        
//        // create upload data to send
//        let uploadData = NSMutableData()
//        
//        // add image
//        uploadData.appendData("\r\n--\(boundaryConstant)\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
//        uploadData.appendData("Content-Disposition: form-data; name=\"file\"; filename=\"file.png\"\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
//        uploadData.appendData("Content-Type: image/png\r\n\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
//        uploadData.appendData(imageData)
//        
//        // add parameters
//        for (key, value) in parameters {
//            uploadData.appendData("\r\n--\(boundaryConstant)\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
//            uploadData.appendData("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n\(value)".dataUsingEncoding(NSUTF8StringEncoding)!)
//        }
//        uploadData.appendData("\r\n--\(boundaryConstant)--\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
//        
//        // return URLRequestConvertible and NSData
//        return (ParameterEncoding.URL.encode(mutableURLRequest, parameters: nil).0, uploadData)
//    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
