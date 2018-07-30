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

let screenW = UIScreen.main.bounds.width
let screenH = UIScreen.main.bounds.height
let rootPath = Bundle.main.path(forResource: "data", ofType: "bundle")!

class DDInfoViewController: UIViewController {
    
    var path: String!
    /// 播放列表
    var musicList: [String] = []
    
    fileprivate var progressTimer : Timer?
    //fileprivate var lrcTimer : CADisplayLink?
    fileprivate var currentMusic : String!
    
    
    // MARK: - 控件属性
    @IBOutlet weak var progressSlider: UISlider!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var iconViewWidthCons: NSLayoutConstraint!
    @IBOutlet weak var lbCurrentTime: UILabel!
    @IBOutlet weak var lbTotalTime: UILabel!
    
    @IBOutlet weak var btnPlayPause: UIButton!
    
    
    @IBOutlet private weak var lbRadioName: UILabel!
    
    @IBOutlet private weak var lbImageName: UILabel!

    
    @IBOutlet private weak var btnCat: UIButton!
    
    /// 是否暂停
    private var isPause = false
    var player: AVAudioPlayer?
    var imgsArr: [String] = [String]()
    var scrollView: UIScrollView?
    var btnClose: UIButton?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "详情"
        setupUI()
        
        updateUI()
    }
    
    private func setupUI() {
        btnCat.layer.cornerRadius = 6
        btnCat.layer.masksToBounds = true
        
        let btnClose = UIButton(type: .custom)
        btnClose.setTitle("关闭", for: .normal)
        btnClose.setTitleColor(UIColor(white: 60/255, alpha: 1), for: .normal)
        btnClose.frame = CGRect(x: 0, y: 0, width: 60.0, height: 30.0)
        btnClose.addTarget(self, action: #selector(btnCloseAction), for: .touchUpInside)
        self.btnClose = btnClose
        let rightItem = UIBarButtonItem(customView: btnClose)
        self.navigationItem.rightBarButtonItem = rightItem
        self.btnClose?.isHidden = true
        
        startPlayingMusic()
        
        progressSlider.addTarget(self, action: #selector(sdChangeProgress(sender:)), for: .valueChanged)
    }
    
    private func updateUI() {
        guard let path = path else {
            return
        }
        
        let fileM = FileManager.default
        let arr = fileM.subpaths(atPath: rootPath+"/"+path)
        imgsArr = (arr?.filter{ $0.hasSuffix(".jpg") })!
        
        lbImageName.text = ""
        arr?.forEach({ (name) in
            if name.hasSuffix(".mp3") {
                lbRadioName.text = name
            } else if name.hasSuffix(".jpg") {
                if lbImageName.text!.count == 0 {
                    lbImageName.text = name
                } else {
                    lbImageName.text = lbImageName.text! + "\n" + name
                }
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
        
        guard let p = path, let name = lbRadioName.text else {
            return
        }
        
        if name == "****" {
            return
        }
        
        if isPause {
            isPause = false
            player?.pause()
        } else {
            isPause = true
            player?.stop()
        }
        if player == nil {
            let url = rootPath + "/" + p + "/" + name
            player = HMZPlayMusicTool.playMusic(name: url)
        }
    }
    
    @IBAction func btnCatAction(_ sender: UIButton) {
        
        self.btnClose?.isHidden = false
    
        
        //self.additionalSafeAreaInsets.top
        let scrollView = UIScrollView(frame: self.view.bounds)
        self.scrollView = scrollView
        scrollView.backgroundColor = .green
        view.addSubview(scrollView)
        
        self.btnClose?.isHidden = false
        
        
        //let imageName = imgsArr[0]
        var y:CGFloat = 0
        imgsArr.sort { (str01, str02) -> Bool in
            return str01.localizedCompare(str02) == .orderedAscending
        }
        imgsArr.forEach { (imageName) in
            let imagePath = rootPath + "/" + path + "/" + imageName
            let url = URL(fileURLWithPath: imagePath)
            do {
                let data = try Data(contentsOf: url)
                let img = UIImage(data: data, scale: UIScreen.main.scale)
                if let image = img {
                    let imageViewH = screenW/image.size.width*image.size.height
                    let imageView = UIImageView(image: image)
                    
                    imageView.frame = CGRect(x: 0, y: y, width: screenW, height: imageViewH)
                    imageView.backgroundColor = .red
                    imageView.contentMode = .scaleAspectFit
                    scrollView.addSubview(imageView)
                    y += imageView.bounds.size.height
                    scrollView.contentSize = CGSize(width: screenW, height: y)
                }
            }
            catch  {
                print("error=\(error)")
            }
        }
    }
    
    @objc private func btnCloseAction() {
        self.btnClose?.isHidden = true
        scrollView?.removeFromSuperview()
    }
    
}


// MARK: - 操作定时器
extension DDInfoViewController {
    
    fileprivate func startPlayingMusic(){
        var currentM = ""
        if currentMusic == nil {
            let filterArr = musicList.filter { (str) -> Bool in
                return str.hasPrefix(path)
            }
            if let m = filterArr.first {
                currentMusic = m
            } else {
                return
            }
        } else {
            if let nameData = currentMusic.components(separatedBy: "/").first {
                self.path = nameData
                updateUI()
            }
        }
        
        currentM = currentMusic!
        
        
        
        
        MusicTools.playMusic(rootPath+"/"+currentM)
        
        MusicTools.setPlayerDelegate(self)
        
        //2改变界面内容
        //backgroundImageView.image = UIImage(named: currentMusic.icon)
        //iconImageView.image = UIImage(named: currentMusic.icon)
        //songLabel.text = currentMusic.name
        //singerLabel.text = currentMusic.singer
        progressSlider.value = 0
        
        //3修改显示的时间
        lbCurrentTime.text = "00:00"
        lbTotalTime.text = stringWithTime(MusicTools.getDuration())
        
        //4添加更新进度的定时器
        removeProgressTimer()
        addProgressTimer()
        setupLockInfo()
    }
    
    
    fileprivate func stringWithTime(_ time : TimeInterval) -> String{
        let min = Int(time) / 60
        let sec = Int(time) % 60
        return String(format: "%02d:%02d", arguments: [min, sec])
    }
    
    /// 添加歌曲进度定时器
    fileprivate func addProgressTimer(){
        progressTimer = Timer(timeInterval: 1.0, target: self, selector: #selector(updateProgress), userInfo: nil, repeats: true)
        RunLoop.main.add(progressTimer!, forMode: .commonModes)
    }
    
    /// 实时更新界面上的进度的方法
    @objc fileprivate func updateProgress(){
        lbCurrentTime.text = stringWithTime(MusicTools.getCurrentTime())
        progressSlider.value = Float(MusicTools.getCurrentTime() / MusicTools.getDuration())
    }
    
    /// 移除歌曲进度定时器
    fileprivate func removeProgressTimer(){
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
        let currentIndex = musicList.index(of: currentMusic)!
        var index : Int = 0
        if isNext {
            index = currentIndex + 1
            index = index > musicList.count - 1 ? 0 : currentIndex + 1
        } else {
            index = currentIndex - 1
            index = index < 0 ? musicList.count - 1 : currentIndex - 1
        }
        currentMusic = musicList[index]
        startPlayingMusic()
        //切歌的时候,若按钮为暂停状态,恢复为播放,恢复动画
        if !btnPlayPause.isSelected {
            btnPlayPause.isSelected = !btnPlayPause.isSelected
            //iconImageView.layer.resumeAnim()
        }
    }
    
    /// 播放/暂停(暂停时移除动画, 恢复播放时重新添加)
    @IBAction func playOrPauseBtnClick(sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected {
            let filterArr = musicList.filter { (str) -> Bool in
                return str.hasPrefix(path)
            }
            if let currentM = filterArr.first {
                currentMusic = currentM
                let name = rootPath + "/" + currentMusic
                MusicTools.playMusic(name)
            }
            
            //iconImageView.layer.resumeAnim()
        } else {
            MusicTools.pauseMusic()
            //iconImageView.layer.pauseAnim()
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
        //1获取锁屏中心
        let centerInfo =  MPNowPlayingInfoCenter.default()
        
        //2设置信息
        var infoDict = [String : Any]()
        infoDict[MPMediaItemPropertyAlbumTitle] = path
        infoDict[MPMediaItemPropertyArtist] = "薛兆丰"
        //        infoDict[MPMediaItemPropertyArtwork] = MPMediaItemArtwork(image: UIImage(named: currentMusic.icon)!)
        let img = #imageLiteral(resourceName: "lk")
        infoDict[MPMediaItemPropertyArtwork] = MPMediaItemArtwork(image: img)
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








