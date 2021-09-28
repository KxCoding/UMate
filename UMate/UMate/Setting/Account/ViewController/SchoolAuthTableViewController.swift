//
//  SchoolAuthTableViewController.swift
//  UMate
//
//  Created by 안상희 on 2021/08/02.
//

import UIKit


/// 사용자 계정 화면에서 학교 인증 선택 방법 화면을 보여주는 ViewController 클래스
/// - Author: 안상희
class SchoolAuthTableViewController: UITableViewController {
    // MARK: Outlet
    /// 합격자 인증 UIView입니다.
    @IBOutlet weak var authContainerView1: UIView!
    
    /// 재학생 인증 UIView입니다.
    @IBOutlet weak var authContainerView2: UIView!
    
    /// 졸업생 인증 UIView입니다.
    @IBOutlet weak var authContainerView3: UIView!
    
    
    // MARK: Action
    /// 합격자 인증을 위한 작업을 수행할 수 있습니다.
    /// - Parameter sender: UIButton
    @IBAction func authButton1(_ sender: UIButton) {
    }
    
    
    /// 재학생 인증을 위한 작업을 수행할 수 있습니다.
    /// - Parameter sender: UIButton
    @IBAction func authButton2(_ sender: UIButton) {
    }
    
    
    /// 졸업생 인증을 위한 작업을 수행할 수 있습니다.
    /// - Parameter sender: UIButton
    @IBAction func authButton3(_ sender: UIButton) {
    }
    
    
    /// ViewController가 메모리에 로드되면 호출됩니다.
    ///
    /// View의 초기화 작업을 진행합니다.
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.separatorStyle = .none
        
        [authContainerView1, authContainerView2, authContainerView3].forEach {
            $0?.setViewTheme()
        }
    }
}
