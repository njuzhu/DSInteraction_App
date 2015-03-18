//
//  Answer.swift
//  DSInteraction
//
//  Created by 王伟成 on 15/3/12.
//  Copyright (c) 2015年 Zhu. All rights reserved.
//

import Foundation
import CoreData

class Answer: NSManagedObject {

    @NSManaged var id: NSNumber
    @NSManaged var question_id: NSNumber
    @NSManaged var content: String
    @NSManaged var isRight: NSNumber

}
