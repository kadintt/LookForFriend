//
//  NearPeopleViewController.swift
//  LookingFriend
//
//  Created by 曲超 on 2021/10/14.
//

import UIKit

class NearPeopleViewController: BaseTableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.reloadData()
    }

}
extension NearPeopleViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        5
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = NearPeopleCell(tableView: tableView, xib: false)!
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        gScale(93)
    }
}
