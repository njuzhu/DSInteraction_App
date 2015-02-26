//
//  MobileUserDB.swift
//  DSInteraction
//
//  Created by Zhu on 15/2/11.
//  Copyright (c) 2015年 Zhu. All rights reserved.
//－

import UIKit
import CoreData

class MobileUserDB: NSObject {
    class func DBAppDelegateObject() -> AppDelegate {
        return UIApplication.sharedApplication().delegate as AppDelegate
    }
    
    // get all MobileUser data
    // e.g.
    // controlListArray = DataBaseClass.DBGoodsInfoReadAllData()
    class func getAllMobileUsers() -> Array<AnyObject> {
        let app = DBAppDelegateObject()
        let request = NSFetchRequest()
        let entity = NSEntityDescription.entityForName("MobileUser", inManagedObjectContext: app.managedObjectContext!)
        request.entity = entity
        var error: NSError? = nil
        var array =  app.managedObjectContext?.executeFetchRequest(request, error: &error)
        return array!
    }
    
    // insert a new line
    // e.g.
    // DataBaseClass.DBGoodsInfoInsert(
    //   ["title":wordTextField!.text,"price":dateTextField!.text])
    class func insertMobileUser(dataDict: Dictionary<String, AnyObject>) -> Bool {
        let app = DBAppDelegateObject()
        var mobileUser = NSEntityDescription.insertNewObjectForEntityForName("MobileUser", inManagedObjectContext: app.managedObjectContext!) as MobileUser
        mobileUser.setValue(dataDict["uid"], forKey: "uid")
        mobileUser.setValue(dataDict["email"], forKey: "email")
        mobileUser.setValue(dataDict["password"], forKey: "password")
        mobileUser.setValue(dataDict["name"], forKey: "name")
        if let image: AnyObject = dataDict["image"] {
            mobileUser.setValue(dataDict["image"], forKey: "image")
        } else {
            mobileUser.setValue("", forKey: "image")
        }
        mobileUser.setValue(dataDict["point"], forKey: "point")
        
        var error: NSError? = nil
        var result = app.managedObjectContext?.save(&error)
        return result!
    }
    
    // update one row
    // e.g.
    // DataBaseClass.DBGoodsInfoUpdate(
    //   ["title":wordTextField!.text,"price":dateTextField!.text],obj:dataDetail!)
    class func updateMobileUser(dataDict: Dictionary<String, AnyObject>, obj: NSManagedObject) -> Bool {
        let app = DBAppDelegateObject()
        let request = NSFetchRequest()
        let entity = NSEntityDescription.entityForName("MobileUser", inManagedObjectContext: app.managedObjectContext!)
        request.entity = entity
        
        var error: NSError? = nil
        var listArray: NSArray = (app.managedObjectContext?.executeFetchRequest(request, error: &error))!
        
        let index = listArray.indexOfObject(obj)
        var mobileUser = listArray[index] as MobileUser
        if let uid: AnyObject = dataDict["uid"] {
            mobileUser.setValue(dataDict["uid"], forKey: "uid")
        }
        if let email: AnyObject = dataDict["email"] {
            mobileUser.setValue(dataDict["email"], forKey: "email")
        }
        if let password: AnyObject = dataDict["password"] {
            mobileUser.setValue(dataDict["password"], forKey: "password")
        }
        if let name: AnyObject = dataDict["name"] {
            mobileUser.setValue(dataDict["name"], forKey: "name")
        }
        if let image: AnyObject = dataDict["image"] {
            mobileUser.setValue(dataDict["image"], forKey: "image")
        } else {
            mobileUser.setValue("", forKey: "image")
        }
        if let point: AnyObject = dataDict["point"] {
            mobileUser.setValue(dataDict["point"], forKey: "point")
        }
        var result = app.managedObjectContext?.save(&error)
        return result!
    }
    
    // delete one row
    // e.g.
    // DataBaseClass.DBGoodsInfoDeleteObject(indexPath.row)
    class func deleteMobileUser(deleteIndex: Int) -> Bool {
        let app = DBAppDelegateObject()
        let object = getAllMobileUsers()[deleteIndex] as MobileUser
        app.managedObjectContext?.deleteObject(object)
        var error: NSError? = nil
        var result = app.managedObjectContext?.save(&error)
        return result!
    }
    
    // delete some rows
    class func deleteMobileUsers(beginIndex: Int, endIndex: Int) -> Bool {
        let app = DBAppDelegateObject()
        for var index = endIndex; index > beginIndex-1; index-- {
            let object = getAllMobileUsers()[index] as MobileUser
            app.managedObjectContext?.deleteObject(object)
        }
        var error: NSError? = nil
        var result = app.managedObjectContext?.save(&error)
        return result!
    }
    
    // delete all rows
    class func deleteAllMobileUsers() -> Bool {
        var endIndex = getAllMobileUsers().count-1
        var result = true
        if endIndex >= 0 {
            result = deleteMobileUsers(0, endIndex: endIndex)
        }
        return result
    }
}
