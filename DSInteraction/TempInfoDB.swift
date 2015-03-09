//
//  TempInfoDB.swift
//  DSInteraction
//
//  Created by Zhu on 15/3/9.
//  Copyright (c) 2015年 Zhu. All rights reserved.
//

import UIKit
import CoreData

class TempInfoDB: NSObject {
    class func DBAppDelegateObject() -> AppDelegate {
        return UIApplication.sharedApplication().delegate as AppDelegate
    }
    
    // Get all tempInfo data
    class func getAllTempInfos() -> Array<AnyObject> {
        let app = DBAppDelegateObject()
        let request = NSFetchRequest()
        let entity = NSEntityDescription.entityForName("TempInfo", inManagedObjectContext: app.managedObjectContext!)
        request.entity = entity
        var error: NSError? = nil
        var array =  app.managedObjectContext?.executeFetchRequest(request, error: &error)
        return array!
    }
    
    // insert a new line
    class func insertTempInfo(dataDict: Dictionary<String, AnyObject>) -> Bool {
        let app = DBAppDelegateObject()
        var tempInfo = NSEntityDescription.insertNewObjectForEntityForName("TempInfo", inManagedObjectContext: app.managedObjectContext!) as TempInfo
        tempInfo.setValue(dataDict["cinema"], forKey: "cinema")
        tempInfo.setValue(dataDict["hall"], forKey: "hall")
        tempInfo.setValue(dataDict["seat"], forKey: "seat")
        var error: NSError? = nil
        var result = app.managedObjectContext?.save(&error)
        return result!
    }
    
    // update one row
    class func updateTempInfo(dataDict: Dictionary<String, AnyObject>, obj: NSManagedObject) -> Bool {
        let app = DBAppDelegateObject()
        let request = NSFetchRequest()
        let entity = NSEntityDescription.entityForName("TempInfo", inManagedObjectContext: app.managedObjectContext!)
        request.entity = entity
        
        var error: NSError? = nil
        var listArray: NSArray = (app.managedObjectContext?.executeFetchRequest(request, error: &error))!
        
        let index = listArray.indexOfObject(obj)
        var tempInfo = listArray[index] as TempInfo
        if let cinema: AnyObject = dataDict["cinema"] {
            tempInfo.setValue(dataDict["cinema"], forKey: "cinema")
        }
        if let hall: AnyObject = dataDict["hall"] {
            tempInfo.setValue(dataDict["hall"], forKey: "hall")
        }
        if let seat: AnyObject = dataDict["seat"] {
            tempInfo.setValue(dataDict["seat"], forKey: "seat")
        }
        var result = app.managedObjectContext?.save(&error)
        return result!
    }
    
    // delete one row
    class func deleteTempInfo(deleteIndex: Int) -> Bool {
        let app = DBAppDelegateObject()
        let object = getAllTempInfos()[deleteIndex] as TempInfo
        app.managedObjectContext?.deleteObject(object)
        var error: NSError? = nil
        var result = app.managedObjectContext?.save(&error)
        return result!
    }
    
    // delete some rows
    class func deleteTempInfos(beginIndex: Int, endIndex: Int) -> Bool {
        let app = DBAppDelegateObject()
        for var index = endIndex; index > beginIndex-1; index-- {
            let object = getAllTempInfos()[index] as TempInfo
            app.managedObjectContext?.deleteObject(object)
        }
        var error: NSError? = nil
        var result = app.managedObjectContext?.save(&error)
        return result!
    }
    
    // delete all rows
    class func deleteAllTempInfos() -> Bool {
        var endIndex = getAllTempInfos().count - 1
        var result = true
        if endIndex >= 0 {
            result = deleteTempInfos(0, endIndex: endIndex)
        }
        return result
    }
    
}
