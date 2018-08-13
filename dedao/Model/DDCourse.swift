//
//  DDCourse.swift
//  dedao
//
//  Created by  赵志丹 on 2018/7/14.
//  Copyright © 2018年 zzd. All rights reserved.
//

import UIKit

class DDCourse: NSObject {
    
    /// mp3文件名
    var filename: String = ""
    /// rootPath
    var rootPath: String = ""
    /// 父路径
    var superPath: String = ""
    /// 文章标题
    var title: String = ""
    /// 文章子标题
    var subTitle: String = ""
    /// 封面图片名
    var icon: String = ""
    var author: String = ""
    /// 图片数组
    var imgList = [String]()
    
    var listenTime: TimeInterval = 0.0
    var isListen: Bool = false
    
    
    override init() {
        super.init()
    }
    
    init(dict : [String : Any]) {
        super.init()
        
        setValuesForKeys(dict)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
}
