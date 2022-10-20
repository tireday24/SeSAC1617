//
//  ViewController.swift
//  SeSAC1617
//
//  Created by 권민서 on 2022/10/18.
//

import UIKit

class SimpleTableViewController: UITableViewController {

    let list = ["슈비버거", "프랭크", "자갈치", "고래밥"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell()
        
        var content = cell.defaultContentConfiguration()
        content.text = list[indexPath.row] //textLable의 대체
        content.secondaryText = "안녕하세요" //detailTextLable
        cell.contentConfiguration = content
        
        return cell
        
    }


}

