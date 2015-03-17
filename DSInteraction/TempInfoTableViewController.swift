//
//  TempInfoTableViewController.swift
//  DSInteraction
//
//  Created by Zhu on 15/3/9.
//  Copyright (c) 2015年 Zhu. All rights reserved.
//

import UIKit

class TempInfoTableViewController: UITableViewController {
    
    var tempInfos:Array<AnyObject> = TempInfoDB.getAllTempInfos()
    
    var gameType: String = String()
    var startTime: String = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        println("gameType: \(gameType)")
//        println("startTime: \(startTime)")
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
        return 3
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var tempInfo: TempInfo!
        if tempInfos.count > 0 {
            tempInfo = tempInfos[0] as TempInfo
        }
        var identifier: NSString
        var value = ""
        switch indexPath.row {
        case 0:
            identifier = "cinemaCell"
            value = tempInfo.cinema
            break;
        case 1:
            identifier = "hallCell"
            value = tempInfo.hall
            break;
        case 2:
            identifier = "seatCell"
            value = tempInfo.seat
            break;
        default:
            identifier = ""
        }
        let cell = tableView.dequeueReusableCellWithIdentifier(identifier, forIndexPath: indexPath) as UITableViewCell

        // Configure the cell...
        cell.detailTextLabel?.text = value
        
        return cell
    }
    
    @IBAction func enterGame(sender: AnyObject) {
//        println("enterGame")
        if self.gameType == "赛车" {
            let mainStoryboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
            let carGameViewController : CarGameViewController = mainStoryboard.instantiateViewControllerWithIdentifier("CarGameViewController") as CarGameViewController
            carGameViewController.startTime = self.startTime
            self.presentViewController(carGameViewController, animated: true, completion: nil)
        }
        
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
