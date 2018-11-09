//
//  UIViewController+Catrgory.swift
//  MagicCard
//
//  Created by moka-iOS on 2018/8/10.
//  Copyright © 2018年 mokajinfu. All rights reserved.
//

import UIKit

/// 这里可以把StoryBoard以模块划分,
enum StoryBoardName: String {
    case none = ""
    case main = "Main"
    case project = "Project"
    case login = "Login"
    case other = "Other"
    case mine = "Mine"
}

protocol StoryBoardProtocol {
    static func storyBoardName() -> StoryBoardName
}

protocol ClassNameProtocol {
    static func className() -> String
}


extension UIViewController: ClassNameProtocol {
    static func className() -> String {
        if let className = classForCoder().description().components(separatedBy: ".").last {
            return className
        } else {
            return classForCoder().description().components(separatedBy: ".").first!
        }
    }
}


extension BaseViewController {
    
    /// 通用创建VC方式
    class func initVC() -> Self {
        
        let type = self.storyBoardName()
        if type == .none {
            return self.init()
        } else {
            if let vc = UIStoryboard.initVC(classType: self) {
                return vc
            } else {
                debugPrint("className=\(className())创建失败")
                return self.init()
            }
        }
    }
}

extension UIStoryboard {
    /// 根据类名创建 由StoryBoard 创建的控制器.
    class func initVC<T>(classType: T.Type) -> T? where T: ClassNameProtocol, T: StoryBoardProtocol {
        let name = T.storyBoardName()
        let sb = UIStoryboard.init(name: name.rawValue, bundle: nil)
        let vc = sb.instantiateVC(classType: classType)
        return vc
    }
    
    func instantiateVC<T>(classType: T.Type) -> T? where T: ClassNameProtocol {
        let className = T.className()
        let vc = instantiateViewController(withIdentifier: className)
        return vc as? T
    }
}


extension UINavigationController {
    /// 生成导航栏右侧点击按钮.
    func generyRightBarBtnItem(title: String, target: UIViewController, action: Selector) -> UIBarButtonItem {
        let rightBt = UIButton(type: .custom)
        rightBt.setTitle(title, for: .normal)
        rightBt.setTitleColor(UIColor(white: 53/255.0, alpha: 1), for: .normal)
        rightBt.frame = CGRect(x: 0, y: 0, width: 60, height: 44)
        rightBt.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        rightBt.addTarget(target, action: action, for: .touchUpInside)
        return UIBarButtonItem(customView: rightBt)
    }
}
