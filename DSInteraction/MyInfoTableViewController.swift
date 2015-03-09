//
//  MyInfoTableViewController.swift
//  DSInteraction
//
//  Created by Zhu on 15/2/21.
//  Copyright (c) 2015年 Zhu. All rights reserved.
//

import UIKit

class MyInfoTableViewController: UITableViewController, UIImagePickerControllerDelegate {

    var mobileUsers:Array<AnyObject> = MobileUserDB.getAllMobileUsers()

    var picker:UIImagePickerController?=UIImagePickerController()
//    var popover:UIPopoverController?=nil
    var mainViewSegue: String = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
                iconImage.image = UIImage(named: value)
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
        var alert:UIAlertController = UIAlertController(title: "Choose Image", message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
        var cameraAction = UIAlertAction(title: "Camera", style: UIAlertActionStyle.Default, handler: {UIAlertAction in self.openCamera()})
        var gallaryAction = UIAlertAction(title: "Gallary", style: UIAlertActionStyle.Default, handler: {UIAlertAction in self.openGallary()})
        var cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: {UIAlertAction in self.imagePickerControllerDidCancel(self.picker!)})
        
        alert.addAction(cameraAction)
        alert.addAction(gallaryAction)
        alert.addAction(cancelAction)
        
        // Present the actionsheet
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            self.presentViewController(alert, animated: true, completion: nil)
        } else {
//            popover=UIPopoverController(contentViewController: alert)
//            popover!.presentPopoverFromRect(btnClickMe.frame, inView: self.view, permittedArrowDirections: UIPopoverArrowDirection.Any, animated: true)
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
        } else {
//            popover=UIPopoverController(contentViewController: picker)
//            popover!.presentPopoverFromRect(btnClickMe.frame, inView: self.view, permittedArrowDirections: UIPopoverArrowDirection.Any, animated: true)
        }
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        picker.dismissViewControllerAnimated(true, completion: nil)
        if(mobileUsers.count > 0) {
            var mobileUser = mobileUsers[0] as MobileUser
            var dataDict = Dictionary<String, AnyObject>()
            dataDict["image"] = "icon_1.png"
            MobileUserDB.updateMobileUser(dataDict, obj: mobileUser)
        }
//        imageView.image=info[UIImagePickerControllerOriginalImage] as UIImage
        println("finish picking")
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        println("picker cancel")
        
    }
    
    
    
    @IBAction func logoutClicked(sender: UIButton) {
        MobileUserDB.deleteAllMobileUsers()
        let mainStoryboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        let viewController : ViewController = mainStoryboard.instantiateViewControllerWithIdentifier("ViewController") as ViewController
        self.presentViewController(viewController, animated: true, completion: nil)
    }

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
