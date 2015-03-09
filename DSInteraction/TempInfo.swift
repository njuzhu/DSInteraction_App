//
//  TempInfo.swift
//  DSInteraction
//
//  Created by Zhu on 15/3/9.
//  Copyright (c) 2015年 Zhu. All rights reserved.
//

import Foundation
import CoreData

@objc(TempInfo)
class TempInfo: NSManagedObject {

    @NSManaged var cinema: String
    @NSManaged var hall: String
    @NSManaged var seat: String

}
