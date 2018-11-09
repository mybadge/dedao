//
//  NotificationCenter.swift
//  MagicCard
//
//  Created by moka-iOS on 2018/11/2.
//  Copyright © 2018 mokajinfu. All rights reserved.
//

import Foundation

extension NotificationCenter {
    /// 封装优化...调用方便
    static func post(customeNotification name: MKNotification, object: Any? = nil){
        NotificationCenter.default.post(name: name.notificationName, object: object)
        
    }
    
    static func addObserver(_ observer: Any, selector aSelector: Selector, name aName: MKNotification, object anObject: Any?) {
        NotificationCenter.default.addObserver(observer, selector: aSelector, name: aName.notificationName, object: anObject)
    }
}


enum MKNotification: String {
    case userLogout
    case userLogin
    case gesturePwdVerifySucc
    /// 启动广告页加载完
    case comleteShowAdView
    /// 分享成功
    case shareSucc
    case appDidReceiveRemoteControl
    
    
    var stringValue: String {
        return "MK" + rawValue
    }
    var notificationName: NSNotification.Name {
        return NSNotification.Name(stringValue)
    }
}

