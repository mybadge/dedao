//
//  DDInfoViewController.swift
//  dedao
//
//  Created by  赵志丹 on 2018/7/14.
//  Copyright © 2018年 zzd. All rights reserved.
//

import UIKit
import AVFoundation
import MediaPlayer



class DDInfoViewController: BaseViewController {

    var index: Int = 0
    /// 播放列表
    var musicList: [DDCourse] = []
    
    fileprivate var progressTimer : Timer?
    
    // MARK: - 控件属性
    @IBOutlet weak var progressSlider: UISlider!
    @IBOutlet weak var lbCurrentTime: UILabel!
    @IBOutlet weak var lbTotalTime: UILabel!
    
    @IBOutlet weak var btnPlayPause: UIButton!
    
    
    @IBOutlet private weak var lbRadioName: UILabel!
    
    @IBOutlet private weak var lbImageName: UILabel!

    
    @IBOutlet private weak var btnCat: UIButton!
    
    /// 是否暂停
    private var isPause = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "详情"
        setupUI()
        
        updateUI()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        DDSqlHelper.share.saveContext()
    }
    
    override static func storyBoardName() -> StoryBoardName {
        return .main
    }
    
    private func setupUI() {
        btnCat.layer.cornerRadius = 6
        btnCat.layer.masksToBounds = true
        
        
        startPlayingMusic()
        progressSlider.addTarget(self, action: #selector(removeProgressTimer), for: .touchDragEnter)
        progressSlider.addTarget(self, action: #selector(sdChangeProgress(sender:)), for: .touchUpInside)
    }

    
    private func updateUI() {
        let course = musicList[index]
        lbRadioName.text = course.fileName
        let imgsArr = musicList[index].imgList
        lbImageName.text = ""
        imgsArr.forEach({ (name) in
            if lbImageName.text!.count == 0 {
                lbImageName.text = name
            } else {
                lbImageName.text = lbImageName.text! + "\n" + name
            }
        })
    }
    
    @objc private func sdChangeProgress(sender: UISlider) {
        removeProgressTimer()
        let vue = TimeInterval(floatLiteral: Double(sender.value))
        let totleTime = MusicTools.getDuration()
        MusicTools.setCurrentTime(totleTime*vue)
        addProgressTimer()
    }
    
    
    @IBAction func btnPlayAction(_ sender: UIButton) {
        
        let course = musicList[index]
        let p = course.superPath!
        
        if course.fileName == "****" {
            return
        }
        
        if isPause {
            isPause = false
            MusicTools.pauseMusic()
        } else {
            isPause = true
            MusicTools.stopMusic()
        }
        let url = rootPath + "/" + p + "/" + course.fileName!
        MusicTools.playMusic(url)
    }
    
    @IBAction func btnCatAction(_ sender: UIButton) {
        
        let vc = DDImageDetailController.initVC()
        vc.course = musicList[index]
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    deinit {
        print("你释放了吗")
    }
}


// MARK: - 操作定时器
extension DDInfoViewController {
    
    fileprivate func startPlayingMusic(){
        let course = musicList[index]
        guard let fileName = course.fileName else {
            course.selected = false
            index += 1
            startPlayingMusic()
            return
        }
        course.selected = true
        let path = rootPath+"/"+course.superPath!+"/"+fileName
        updateUI()
        
        MusicTools.playMusic(path)
        MusicTools.setCurrentTime(TimeInterval(course.listenTime))
        MusicTools.setPlayerDelegate(self)
        
        //2改变界面内容
        progressSlider.value = 0
        
        //3修改显示的时间
        lbCurrentTime.text = "00:00"
        lbTotalTime.text = MusicTools.getDuration().songsTime
        
        //4添加更新进度的定时器
        removeProgressTimer()
        addProgressTimer()
        setupLockInfo()
        DDSqlHelper.share.saveContext()
    }

    
    /// 添加歌曲进度定时器
    fileprivate func addProgressTimer(){
        progressTimer = Timer(timeInterval: 0.5, target: self, selector: #selector(updateProgress), userInfo: nil, repeats: true)
        RunLoop.main.add(progressTimer!, forMode: RunLoop.Mode.common)
    }
    
    /// 实时更新界面上的进度的方法
    @objc fileprivate func updateProgress(){
        let current = MusicTools.getCurrentTime()
        let total = MusicTools.getDuration()
        lbCurrentTime.text = current.songsTime
        if MusicTools.isPlaying() && current > 0 {
            let course = musicList[index]
            course.listenTime = current
            course.totalTime = total
            if Int(current) == Int(total) {
                course.listened = true
            }
        }
        progressSlider.value = Float(current / total)
    }
    
    /// 移除歌曲进度定时器
    @objc fileprivate func removeProgressTimer(){
        progressTimer?.invalidate()
        progressTimer = nil
    }

}

// MARK: - 更新歌曲(上一首/下一首/暂停/播放)
extension DDInfoViewController {
    
    /// 下一首
    @IBAction func nextMusicBtnClick(sender: UIButton) {
        switchMusic(isNext : true)
    }
    
    /// 上一首
    @IBAction func previousMusicBtnClick(sender: UIButton) {
        switchMusic(isNext: false)
    }
    
    /// 切换歌曲(向下/向上)
    private func switchMusic(isNext : Bool){
    
        let course = musicList[index]
        
        course.selected = false
        if isNext {
            index += 1
            index = index > musicList.count - 1 ? 0 : index
        } else {
            index -= 1
            index = index < 0 ? musicList.count - 1 : index
        }
        
        startPlayingMusic()
        
        //切歌的时候,若按钮为暂停状态,恢复为播放,恢复动画
        if !btnPlayPause.isSelected {
            btnPlayPause.isSelected = !btnPlayPause.isSelected
        }
        DDSqlHelper.share.saveContext()
    }
    
    /// 播放/暂停(暂停时移除动画, 恢复播放时重新添加)
    @IBAction func playOrPauseBtnClick(sender: UIButton) {
        sender.isSelected = !sender.isSelected
        let course = musicList[index]
        if sender.isSelected {
            let path = course.superPath!
            let name = rootPath + "/" + path + "/" + course.fileName!
            MusicTools.playMusic(name)
            
        } else {
            MusicTools.pauseMusic()
            course.listenTime = MusicTools.getCurrentTime()
            DDSqlHelper.share.saveContext()
        }
    }
    
}


// MARK: - 监听歌曲播放完成
extension DDInfoViewController : AVAudioPlayerDelegate{
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        if flag { nextMusicBtnClick(sender: btnPlayPause) }
    }
}



// MARK: - 设置锁屏界面信息
extension DDInfoViewController{
    
    /// 设置锁屏信息
    func setupLockInfo() {
        let course = musicList[index]
        let path = course.superPath
        //1获取锁屏中心
        let centerInfo = MPNowPlayingInfoCenter.default()
        
        //2设置信息
        var infoDict = [String : Any]()
        infoDict[MPMediaItemPropertyAlbumTitle] = course.imgList.first ?? ""
        infoDict[MPMediaItemPropertyArtist] = path
        let img = #imageLiteral(resourceName: "lk")
        infoDict[MPMediaItemPropertyArtwork] = MPMediaItemArtwork.init(boundsSize: img.size, requestHandler: { (size) -> UIImage in
            return img
        })
        infoDict[MPMediaItemPropertyPlaybackDuration] = MusicTools.getDuration()
        centerInfo.nowPlayingInfo = infoDict
        
        //3让应用程序成为第一响应者
        UIApplication.shared.becomeFirstResponder()
        UIApplication.shared.beginReceivingRemoteControlEvents()
    }
    
    override func remoteControlReceived(with event: UIEvent?) {
        //校验远程事件是否有值
        guard let event = event else { return }
        //处理远程事件
        switch event.subtype {
        case .remoteControlPlay, .remoteControlPause:
            playOrPauseBtnClick(sender: self.btnPlayPause)
        case .remoteControlNextTrack:
            nextMusicBtnClick(sender: self.btnPlayPause)
        case .remoteControlPreviousTrack:
            previousMusicBtnClick(sender: self.btnPlayPause)
        default:
            print("????")
        }
    }
}








