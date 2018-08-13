//
//  ViewController.swift
//  dedao
//
//  Created by  赵志丹 on 2018/7/14.
//  Copyright © 2018年 zzd. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!    
    
    let path = Bundle.main.path(forResource: "data", ofType: "bundle")!
    var dataList = [String]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    var modelList = [DDCourse]()
    
    var musicList = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        do {
            var array = try FileManager.default.contentsOfDirectory(atPath: path)
            array.sort { (str01, str02) -> Bool in
                return str01.localizedStandardCompare(str02) == .orderedAscending
            }
            dataList = array
            
            let allFiles = FileManager.default.subpaths(atPath: path)
            
            if let list = allFiles?.filter({ (str) -> Bool in
                return str.hasSuffix(".mp3")
            }) {
                musicList = list
            }
            
            musicList.sort { (str01, str02) -> Bool in
                return str01.localizedStandardCompare(str02) == .orderedAscending
            }
            handleData()
            print("modelList=\(modelList)")
        } catch let error as NSError {
            print("get file path error: \(error)")
        }
    }
    
    func handleData() {
        dataList.forEach { (rootFile) in
            let course = generyCourseModel(rootFile: rootFile)
            modelList.append(course)
        }
    }
    
    func generyCourseModel(rootFile: String) -> DDCourse {
        let fileM = FileManager.default
        let arr = fileM.subpaths(atPath: rootPath+"/"+rootFile)
        let course = DDCourse()
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
            if course.title.contains("薛兆丰的北大经济学课") {
                course.title = course.title.replacingOccurrences(of: "薛兆丰的北大经济学课", with: "")
            }
        }
        if let mp3Name = arr?.filter({ $0.hasSuffix(".mp3") }).first {
            course.filename = mp3Name
        }
        course.author = "薛兆丰"
        
        return course
    }
    
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataList.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath)
        let course = modelList[indexPath.row]
        cell.textLabel?.text = course.title
        //cell.detailTextLabel?.text = "薛兆丰"
        cell.detailTextLabel?.text = course.subTitle
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let course = modelList[indexPath.row]
        let path = dataList[indexPath.row]
        course.superPath = path
        performSegue(withIdentifier: "list-detail", sender: course)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "list-detail" {
            let vc = segue.destination as! DDInfoViewController
            vc.course = sender as? DDCourse
            vc.musicList = musicList
        }
        
    }
    
}

