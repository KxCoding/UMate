//
//  SchoolAuthTableViewController.swift
//  UMate
//
//  Created by 안상희 on 2021/08/02.
//

import UIKit

class SchoolAuthTableViewController: UITableViewController {

    @IBOutlet weak var authContainerView1: UIView!
    @IBOutlet weak var authContainerView2: UIView!
    @IBOutlet weak var authContainerView3: UIView!
    
    @IBAction func authButton1(_ sender: Any) {
        print("1")
    }
    @IBAction func authButton2(_ sender: Any) {
        print("2")
    }
    @IBAction func authButton3(_ sender: Any) {
        print("3")
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.separatorStyle = .none
        
        [authContainerView1, authContainerView2, authContainerView3].forEach {
            $0?.setViewTheme()
        }
    }
}
