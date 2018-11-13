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


extension DDCourse {
    /// 生成 模型
    class func generyCourseModel(superPath: String) -> DDCourse {
        let fileM = FileManager.default
        let arr = fileM.subpaths(atPath: rootPath+"/"+superPath)
        let course = DDCourse.creat()
        course.superPath = superPath
        if let imgsArr = (arr?.filter{ $0.hasSuffix(".jpg") || $0.hasSuffix(".png") }) {
            course.imgList = imgsArr
            
            let totalTitle = imgsArr.first ?? ""
            let arr = totalTitle.components(separatedBy: "丨")
            if arr.count > 1 {
                course.title = arr[0]
                course.subTitle = arr[1]
            } else {
                let arr = totalTitle.components(separatedBy: " ").filter { (str) -> Bool in
                    str != ""
                }
                
                if arr.count > 1 {
                    course.title = arr[0]
                    course.subTitle = arr[1]
                } else {
                    course.title = arr[0]
                }
            }
            if course.title?.contains("薛兆丰的北大经济学课") ?? false {
                course.title = course.title?.replacingOccurrences(of: "薛兆丰的北大经济学课", with: "")
            }
            course.imgArrStr = imgsArr.joined(separator: arrJoinSepector)
        }
        if let mp3Name = arr?.filter({ $0.hasSuffix(".mp3") }).first {
            course.fileName = mp3Name
        }
        course.author = "薛兆丰"
        
        return course
    }
}
