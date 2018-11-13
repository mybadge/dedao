//
//  DDListController.swift
//  dedao
//
//  Created by  赵志丹 on 2018/7/14.
//  Copyright © 2018年 zzd. All rights reserved.
//

import UIKit
import PullToRefresh

class DDListController: BaseViewController {
    
    var selectedIndex: Int = 0
    
    @IBOutlet private weak var tableView: UITableView!
    
    private var modelList = [DDCourse]() {
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
        
        tableView.addPullToRefresh(PullToRefresh()) { [weak self] in
            DispatchQueue.main.asyncAfter(deadline: .now()+0.25, execute: {
                self?.tableView.endAllRefreshing()
                self?.tableView.reloadData()
            })
        }
        
        setupData()
    }
    
    

    
    func setupData() {
        DDSqlHelper.share.getDataList { (list) in
            if list.count == 0 {
                self.getData()
            } else {
                list.forEach({
                    $0.imgList = $0.imgArrStr?.components(separatedBy: arrJoinSepector).compactMap({$0}) ?? []
                })
                let sortList = list.sorted { (mod1, mod2) -> Bool in
                    return mod1.superPath!.localizedStandardCompare(mod2.superPath!) == .orderedAscending
                }
                self.selectedIndex = sortList.firstIndex(where: { $0.selected }) ?? 0
                self.modelList = sortList
            }
        }
    }
    
    func getData() {
        handleData()
        DDSqlHelper.share.batchInsert()
        print("modelList=\(modelList)")
    }
    
    func handleData() {
        do {
            var array = try FileManager.default.contentsOfDirectory(atPath: rootPath)
            array.sort { (str01, str02) -> Bool in
                return str01.localizedStandardCompare(str02) == .orderedAscending
            }
            
            modelList = array.map { DDCourse.generyCourseModel(superPath: $0) }
            
        } catch let error as NSError {
            print("get file path error: \(error)")
        }
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
        let _ = self.tableView(tableView, cellForRowAt: IndexPath(row: selectedIndex, section: 0))
        modelList[selectedIndex].selected = false
        selectedIndex = indexPath.row
        modelList[selectedIndex].selected = true
        
        var vc = self.children.first as? DDInfoViewController
        if vc == nil {
            vc = DDInfoViewController.initVC()
            vc!.index = indexPath.row
            vc!.musicList = modelList
            self.addChild(vc!)
        } else {
            vc!.index = indexPath.row
        }
        navigationController?.pushViewController(vc!, animated: true)
    }
}

