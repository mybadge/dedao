//
//  DDCourse+CoreDataClass.swift
//  dedao
//
//  Created by moka-iOS on 2018/11/9.
//  Copyright © 2018 zzd. All rights reserved.
//
//

import Foundation
import CoreData

@objc(DDCourse)
public class DDCourse: NSManagedObject {
    var imgList: [String] = []
    
    
    public override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }
    
    class func creat() -> DDCourse {
        let context = DDSqlHelper.share.context
        let Entity = NSEntityDescription.entity(forEntityName: "DDCourse", in: context)
        let model = DDCourse(entity: Entity!, insertInto: context)
        return model
    }
}
