//
//  BaseViewController.swift
//  dedao
//
//  Created by moka-iOS on 2018/11/9.
//  Copyright © 2018 zzd. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController, StoryBoardProtocol {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    class func storyBoardName() -> StoryBoardName {
        return .main
    }
    
    
    @IBAction func backAction(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
}
