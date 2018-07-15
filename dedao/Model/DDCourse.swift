//
//  DDCourse.swift
//  dedao
//
//  Created by  赵志丹 on 2018/7/14.
//  Copyright © 2018年 zzd. All rights reserved.
//

import UIKit

class DDCourse: NSObject {
    //曲名
    var name: String = ""
    //mp3文件名
    var filename: String = ""
    //歌词文件名
    var lrcname: String = ""
    //歌手名
    var singer: String = ""
    //封面图片名
    var icon: String = ""
    var author: String = ""
    
    var listenTime: Double = 0.0
    var isListen: Bool = false
    
    
    init(dict : [String : Any]) {
        super.init()
        
        setValuesForKeys(dict)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
}
