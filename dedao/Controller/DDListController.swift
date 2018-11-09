//
//  DDListController.swift
//  dedao
//
//  Created by  赵志丹 on 2018/7/14.
//  Copyright © 2018年 zzd. All rights reserved.
//

import UIKit
/// 数组连接分隔符
let arrJoinSepector = "^^"

class DDListController: BaseViewController {
    
    @IBOutlet weak var tableView: UITableView!    
    
    let path = Bundle.main.path(forResource: "data", ofType: "bundle")!
    
    var modelList = [DDCourse]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadData()
    }
    
    func setupData() {
        do {
            var array = try FileManager.default.contentsOfDirectory(atPath: path)
            array.sort { (str01, str02) -> Bool in
                return str01.localizedStandardCompare(str02) == .orderedAscending
            }
            handleData(array)
            
        } catch let error as NSError {
            print("get file path error: \(error)")
        }
    }

    
    func loadData() {
        DDSqlHelper.share.getDataList { (list) in
            if list.count == 0 {
                self.getData()
            } else {
                list.forEach({
                    $0.imgList = $0.imgArrStr?.components(separatedBy: arrJoinSepector).compactMap({$0}) ?? []
                })
                self.modelList = list.sorted { (mod1, mod2) -> Bool in
                    return mod1.superPath!.localizedStandardCompare(mod2.superPath!) == .orderedAscending
                }
            }
        }
    }
    
    func getData() {
        setupData()
        DDSqlHelper.share.batchInsert()
        print("modelList=\(modelList)")
    }
    
    
    func handleData(_ list: [String]) {
        modelList = list.map { generyCourseModel(superPath: $0) }
    }
    
    func generyCourseModel(superPath: String) -> DDCourse {
        let fileM = FileManager.default
        let arr = fileM.subpaths(atPath: rootPath+"/"+superPath)
        let course = DDCourse.creat()
        course.superPath = superPath
        if let imgsArr = (arr?.filter{ $0.hasSuffix(".jpg") || $0.hasSuffix(".png") }) {
            course.imgList = imgsArr
            
            let totalTitle = imgsArr.first ?? ""
            let arr = totalTitle.components(separatedBy: "丨")
            if arr.count > 1 {
                course.title = arr[0]
                course.subTitle = arr[1]
            } else {
                let arr = totalTitle.components(separatedBy: " ").filter { (str) -> Bool in
                    str != ""
                }
                
                if arr.count > 1 {
                    course.title = arr[0]
                    course.subTitle = arr[1]
                } else {
                    course.title = arr[0]
                }
            }
            if course.title?.contains("薛兆丰的北大经济学课") ?? false {
                course.title = course.title?.replacingOccurrences(of: "薛兆丰的北大经济学课", with: "")
            }
            course.imgArrStr = imgsArr.joined(separator: arrJoinSepector)
        }
        if let mp3Name = arr?.filter({ $0.hasSuffix(".mp3") }).first {
            course.fileName = mp3Name
        }
        course.author = "薛兆丰"
        
        return course
    }
    
}

extension DDListController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return modelList.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as! DDTableViewCell
        cell.course = modelList[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DDInfoViewController.initVC()
        vc.index = indexPath.row
        vc.musicList = modelList
        navigationController?.pushViewController(vc, animated: true)
    }
}

