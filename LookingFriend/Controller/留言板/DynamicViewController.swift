//
//  DynamicViewController.swift
//  LookingFriend
//
//  Created by 曲超 on 2021/10/12.
//

import UIKit

class DynamicViewController: BaseTableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        print("留言板")
        self.isHiddenNavigationBar = true
        view.backgroundColor = .dyt_nav_title
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
