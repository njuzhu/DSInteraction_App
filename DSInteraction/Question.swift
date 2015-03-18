//
//  Question.swift
//  DSInteraction
//
//  Created by 王伟成 on 15/3/12.
//  Copyright (c) 2015年 Zhu. All rights reserved.
//

import Foundation
import CoreData

class Question: NSManagedObject {

    @NSManaged var id: NSNumber
    @NSManaged var content: String
    @NSManaged var keyword: String
    @NSManaged var duration: NSNumber

}
