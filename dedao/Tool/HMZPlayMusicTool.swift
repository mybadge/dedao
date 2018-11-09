//
//  HMZPlayMusicTool.swift
//  QQMusic
//
//  Created by 赵志丹 on 16/1/4.
//  Copyright © 2016年 赵志丹. All rights reserved.
//

import UIKit
import AVFoundation

//class HMZPlayMusicTool: NSObject {
//    static var players:[String: AVAudioPlayer] = [String: AVAudioPlayer]()
//    
//    class func playMusic(name: String) ->AVAudioPlayer? {
//        var player = players[name]
//        if player == nil {
//            
//            if !FileManager.default.fileExists(atPath: name) {
//                print("url=\(name)\n路径不存在")
//                return nil
//            }
//            let url = self.getUrl(path: name)
//            player = try! AVAudioPlayer(contentsOf: url)
//            players[name] = player
//            player?.prepareToPlay()
//        }
//        player?.play()
//        return player
//    }
//    
//    class func getUrl(path: String) -> URL{
//        let url = URL(fileURLWithPath: path)
//        return url
//    }
//    
//    class func pauseMusic(name: String) {
//        let player = players[name]
//        player?.pause()
//    }
//    
//    class func stopMusic(name: String) {
//        let palyer = players[name]
//        palyer?.stop()
//        players.removeValue(forKey: name)
//    }
//}
