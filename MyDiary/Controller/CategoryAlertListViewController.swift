//
//  CategoryListViewController.swift
//  MyDiary
//
//  Created by Jisoo Woo on 2022/01/29.
//

import UIKit
import Foundation

class CategoryAlertListViewController: UITableViewController {
    
    var delegate: CategoryViewController?
    let categories: [String] = ["Diary","Memo","Todo"]

    override func viewDidLoad() {
        super.viewDidLoad()
        self.preferredContentSize.height = 135

        
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return 3
        }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        
        cell.textLabel!.text = "\(categories[indexPath.row])"
        
        cell.textLabel!.font = UIFont.systemFont(ofSize: 13)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.delegate?.didSelectRowAt(indexPath: indexPath)
    }

    
}
