//
//  AppDelegate.swift
//  dedao
//
//  Created by  赵志丹 on 2018/7/14.
//  Copyright © 2018年 zzd. All rights reserved.
//

import UIKit
import AVFoundation
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    /// 后台播放任务Id
    var bgTaskId: UIBackgroundTaskIdentifier?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
    
        NotificationCenter.default.addObserver(self, selector: #selector(interruptionNotificationHandler(notification:)), name: AVAudioSession.interruptionNotification, object: nil)

        //开启后台播放功能
        let session = AVAudioSession.sharedInstance()
        
        do{
            //设置音频可以后台播放
            try session.setCategory(.playback, mode: .default, options: .allowBluetooth)
            //激活会话
            try session.setActive(true)
        } catch {
            print(error)
        }
        
        application.beginReceivingRemoteControlEvents()
        remoteControlEventHandler()
        
        return true
    }
    
    @objc func interruptionNotificationHandler(notification: Notification) {
        let dict = notification.userInfo
        
        print(dict ?? "")
        //let type = Int(dict[AVAudioSessionInterruptionTypeKey])
        //NSUInteger interuptionType = [type integerValue];
        //let type = AVAudioSession.InterruptionType.began
//        if (interuptionType == AVAudioSessionInterruptionTypeBegan) {
//            //获取中断前音乐是否在播放
//            _played = [MusicPlayViewController shareMusicPlay].isPlaying;
//            NSLog(@"AVAudioSessionInterruptionTypeBegan");
//        }else if (interuptionType == AVAudioSessionInterruptionTypeEnded) {
//            NSLog(@"AVAudioSessionInterruptionTypeEnded");
//        }
//
//        if(_played)
//        {
//            //停止播放的事件
//            [[MusicPlayTools shareMusicPlay] musicPause];
//            _played=NO;
//        }else {
//            //继续播放的事件
//            [[MusicPlayTools shareMusicPlay] musicPlay];
//            _played=YES;
//        }
        
    }

    func remoteControlEventHandler() {
        
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
//        //开启后台处理多媒体事件
//        [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
//        AVAudioSession *session=[AVAudioSession sharedInstance];
//        [session setActive:YES error:nil];
//        //后台播放
//        [session setCategory:AVAudioSessionCategoryPlayback error:nil];
//        //这样做，可以在按home键进入后台后 ，播放一段时间，几分钟吧。但是不能持续播放网络歌曲，若需要持续播放网络歌曲，还需要申请后台任务id，具体做法是：
//        _bgTaskId=[AppDelegate backgroundPlayerID:_bgTaskId];
//        //其中的_bgTaskId是后台任务UIBackgroundTaskIdentifier _bgTaskId;
        
        
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        DDSqlHelper.share.saveContext()
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        DDSqlHelper.share.saveContext()
    }

    override func remoteControlReceived(with event: UIEvent?) {
        
        guard let event = event else {
            return
        }
        
        NotificationCenter.post(customeNotification: .appDidReceiveRemoteControl, object: event.subtype)
    }
    
//    //实现一下backgroundPlayerID:这个方法:
//    +(UIBackgroundTaskIdentifier)backgroundPlayerID:(UIBackgroundTaskIdentifier)backTaskId
//    {
//    //设置并激活音频会话类别
//    AVAudioSession *session=[AVAudioSession sharedInstance];
//    [session setCategory:AVAudioSessionCategoryPlayback error:nil];
//    [session setActive:YES error:nil];
//    //允许应用程序接收远程控制
//    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
//    //设置后台任务ID
//    UIBackgroundTaskIdentifier newTaskId=UIBackgroundTaskInvalid;
//    newTaskId=[[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:nil];
//    if(newTaskId!=UIBackgroundTaskInvalid&&backTaskId!=UIBackgroundTaskInvalid)
//    {
//    [[UIApplication sharedApplication] endBackgroundTask:backTaskId];
//    }
//    return newTaskId;
//    }
}

/// 参考  https://blog.csdn.net/chenyong05314/article/details/79123727
