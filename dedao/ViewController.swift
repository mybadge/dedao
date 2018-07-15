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
            
        } catch let error as NSError {
            print("get file path error: \(error)")
        }
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
        cell.textLabel?.text = dataList[indexPath.row]
        cell.detailTextLabel?.text = "薛兆丰"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let turePath = dataList[indexPath.row]
        
        performSegue(withIdentifier: "list-detail", sender: turePath)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "list-detail" {
            let vc = segue.destination as! DDInfoViewController
            vc.path = sender as? String
            vc.musicList = musicList
        }
        
    }
    
}

