//
//  DDSqlHelper.swift
//  dedao
//
//  Created by moka-iOS on 2018/11/9.
//  Copyright © 2018 zzd. All rights reserved.
//

import UIKit
import CoreData

class DDSqlHelper {
    
    static let share = DDSqlHelper()
    
    private init() {}
    
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
 
    // MARK: - Core Data stack
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "DDCourse")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}


extension DDSqlHelper {
    
    
    func insert(model: DDCourse) {
        
        
        //通过指定实体名 得到对象实例
        
        let Entity = NSEntityDescription.entity(forEntityName: "DDCourse", in: context)
        let model = DDCourse(entity: Entity!, insertInto: context)
        model.fileName = ""
        
        do {
            //保存实体对象
            try context.save()
        } catch  {
            let nserror = error as NSError
            fatalError("错误:\(nserror),\(nserror.userInfo)")
        }
    }
    
    func batchInsert() {
        saveContext()
    }
    
    //MARK: 查询数据信息
    func getDataList(fBlock: @escaping ([DDCourse])->()){
        
        let fetchRequest = NSFetchRequest<DDCourse>(entityName: "DDCourse")
        //let fetchRequest = DDCourse.fetchRequest()
        // 异步请求由两部分组成：普通的request和completion handler
        
        
        // 返回结果在finalResult中
        let asyncFetchRequest = NSAsynchronousFetchRequest(fetchRequest: fetchRequest) { (result : NSAsynchronousFetchResult!) in
            if let fetchObject = result.finalResult {
                fBlock(fetchObject)
            } else {
                fBlock([])
            }
        }
        
        // 执行异步请求调用execute
        do {
            try context.execute(asyncFetchRequest)
        } catch  {
            fBlock([])
            print("error=\(error)")
        }
    }
    
    //MARK:    修改班级信息
    func modify(model: DDCourse) {
        //获取委托
        //声明数据的请求，声明一个实体结构
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "DDCourse")
        //查询条件
        fetchRequest.predicate = NSPredicate(format: "title = %@", model.title ?? "")
        // 异步请求由两部分组成：普通的request和completion handler
        // 返回结果在finalResult中
        let asyncFecthRequest = NSAsynchronousFetchRequest(fetchRequest: fetchRequest) { (result: NSAsynchronousFetchResult!) in
            //对返回的数据做处理。
//            let fetchObject  = result.finalResult! as! [Class]
//
//            for c in fetchObject{
//
//                c.name = "qazwertdfxcvg"
//
//                app.saveContext()
//
//            }
            
        }
        // 执行异步请求调用execute
        do {
            try context.execute(asyncFecthRequest)
        } catch  {
            print("error")
        }
    }
    
    
    
    //MARK:    删除班级信息
    func deleteClass() {
        
        
        //声明数据的请求，声明一个实体结构
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "DDCourse")
        // 异步请求由两部分组成：普通的request和completion handler
        
        // 返回结果在finalResult中
        
        let asyncFetchRequest = NSAsynchronousFetchRequest(fetchRequest: fetchRequest) { (result:NSAsynchronousFetchResult) in
            
            
            
            //对返回的数据做处理。
            
//            let fetchObject = result.finalResult! as! [AnyClass]
//
//            for c in fetchObject{
//                //所有删除信息
//                context.delete(c)
//            }
            self.saveContext()
            
        }
        
        
        
        // 执行异步请求调用execute
        
        do {
            
            try context.execute(asyncFetchRequest)
            
        } catch  {
            
            print("error")
            
        }
        
    }
    
    
    
    //MARK:    统计信息
    
    func countClass() {
        
        //声明数据的请求，声明一个实体结构
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Class")
        
        
        
        //请求的描述，按classNo 从小到大排序
        
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "classNo", ascending: true)]
        
        
        
        //请求的结果类型
        
        //        NSManagedObjectResultType：返回一个managed object（默认值）
        
        //        NSCountResultType：返回满足fetch request的object数量
        
        //        NSDictionaryResultType：返回字典结果类型
        
        //        NSManagedObjectIDResultType：返回唯一的标示符而不是managed object
        
        fetchRequest.resultType = .dictionaryResultType
        
        
        
        // 创建NSExpressionDescription来请求进行平均值计算，取名为AverageNo，通过这个名字，从fetch请求返回的字典中找到平均值
        
        let description = NSExpressionDescription()
        
        description.name = "AverageNo"
        
        
        
        
        
        //指定要进行平均值计算的字段名classNo并设置返回值类型
        
        let args  = [NSExpression(forKeyPath: "classNo")]
        
        
        
        // forFunction参数有sum:求和 count:计算个数 min:最小值 max:最大值 average:平均值等等
        
        description.expression = NSExpression(forFunction: "average:", arguments: args)
        
        description.expressionResultType = .floatAttributeType
        
        
        
        // 设置请求的propertiesToFetch属性为description告诉fetchRequest，我们需要对数据进行求平均值
        
        fetchRequest.propertiesToFetch = [description]
        
        
        
        do {
            
            let entries =  try context.fetch(fetchRequest)
            
            let result = entries.first! as! NSDictionary
            
            let averageNo = result["AverageNo"]!
            
            print("\(averageNo)")
            
            
            
        } catch  {
            
            print("failed")
            
        }
        
    }
    
    
    
    
    
    //MARK:批量更新
    
    func batchUpdate() {
        let batchUpdate = NSBatchUpdateRequest(entityName: "Class")
        
        //所要更新的属性 和 更新的值
        
        batchUpdate.propertiesToUpdate = ["name": 55555]
        
        //被影响的Stores
        
        batchUpdate.affectedStores = context.persistentStoreCoordinator!.persistentStores
        
        //配置返回数据的类型
        
        batchUpdate.resultType = .updatedObjectsCountResultType
        
        
        
        //执行批量更新
        
        do {
            
            let batchResult = try context.execute(batchUpdate) as! NSBatchUpdateResult
            
            //批量更新的结果，上面resultType类型指定为updatedObjectsCountResultType，所以result显示的为 更新的个数
            
            print("\(batchResult.result!)")
            
        } catch   {
            
            print("error")
            
        }
        
    }
}
