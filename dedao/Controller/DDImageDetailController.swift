//
//  DDImageDetailController.swift
//  dedao
//
//  Created by moka-iOS on 2018/11/9.
//  Copyright © 2018 zzd. All rights reserved.
//

import UIKit

/// 图片查看..
class DDImageDetailController: BaseViewController {

    var course: DDCourse?
    @IBOutlet private weak var scrollView: UIScrollView!

    override func viewDidLoad() {
        title = "图片信息"
        
        showImageView()
    }
    
    
    override static func storyBoardName() -> StoryBoardName {
        return .main
    }
    
    func showImageView() {
        
        guard let course = course else {
            return
        }
        
        
        var y:CGFloat = 0
        var imgsArr = course.imgList
        imgsArr.sort { (str01, str02) -> Bool in
            return str01.localizedCompare(str02) == .orderedAscending
        }
        
        imgsArr.forEach { (imageName) in
            let imagePath = rootPath + "/" + course.superPath! + "/" + imageName
            let url = URL(fileURLWithPath: imagePath)
            do {
                let data = try Data(contentsOf: url)
                let img = UIImage(data: data, scale: UIScreen.main.scale)
                if let image = img {
                    let imageViewH = ScreenW/image.size.width*image.size.height
                    let imageView = UIImageView(image: image)
                    
                    imageView.frame = CGRect(x: 0, y: y, width: ScreenW, height: imageViewH)
                    imageView.contentMode = .scaleAspectFit
                    scrollView.addSubview(imageView)
                    y += imageView.bounds.size.height
                    scrollView.contentSize = CGSize(width: ScreenW, height: y)
                }
            }
            catch  {
                print("error=\(error)")
            }
        }
    }
}
