//
//  MobileUser.swift
//  DSInteraction
//
//  Created by Zhu on 15/2/12.
//  Copyright (c) 2015年 Zhu. All rights reserved.
//

import Foundation
import CoreData

class MobileUser: NSManagedObject {

    @NSManaged var uid: NSNumber
    @NSManaged var email: String
    @NSManaged var password: String
    @NSManaged var name: String
    @NSManaged var image: String
    @NSManaged var point: NSNumber

}
