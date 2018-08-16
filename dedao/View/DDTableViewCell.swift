//
//  DDTableViewCell.swift
//  dedao
//
//  Created by 赵志丹 on 2018/8/16.
//  Copyright © 2018年 zzd. All rights reserved.
//

import UIKit

class DDTableViewCell: UITableViewCell {

    var course: DDCourse? {
        didSet {
            updateUI()
        }
    }
    
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var lbSubTitle: UILabel!
    @IBOutlet weak var lbDetail: UILabel!
    @IBOutlet weak var lbSubDetail: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func updateUI() {
        guard let course = course else {
            return
        }
        lbTitle.text = course.title
        lbSubTitle.text = course.imgList.first ?? ""
        lbDetail.text = String(format: "时长: %.1f", course.listenTime)
        if course.isListen {
            lbSubDetail.text = "已听完"
        } else {
            lbSubDetail.text = "咱未听"
        }
    }
}
