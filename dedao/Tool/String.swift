//
//  String.swift
//  dedao
//
//  Created by moka-iOS on 2018/11/9.
//  Copyright © 2018 zzd. All rights reserved.
//

import Foundation


extension TimeInterval {
    var songsTime: String {
        let min = Int(self) / 60
        let sec = Int(self) % 60
        return String(format: "%02d:%02d", arguments: [min, sec])
    }
}
