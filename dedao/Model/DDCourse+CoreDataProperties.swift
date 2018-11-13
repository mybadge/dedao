//
//  DDCourse+CoreDataProperties.swift
//  dedao
//
//  Created by moka-iOS on 2018/11/9.
//  Copyright © 2018 zzd. All rights reserved.
//
//

import Foundation
import CoreData


extension DDCourse {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DDCourse> {
        return NSFetchRequest<DDCourse>(entityName: "DDCourse")
    }

    @NSManaged public var fileName: String?
    @NSManaged public var title: String?
    @NSManaged public var subTitle: String?
    @NSManaged public var listenTime: Double
    @NSManaged public var totalTime: Double
    @NSManaged public var listened: Bool
    @NSManaged public var selected: Bool
    @NSManaged public var imgArrStr: String?
    @NSManaged public var superPath: String?
    @NSManaged public var author: String?

}
