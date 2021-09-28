//
//  ChooseEmailPasswordViewController.swift
//  ChooseEmailPasswordViewController
//
//  Created by 안상희 on 2021/08/08.
//

import UIKit

/// 사용자 계정 화면에서 이메일 변경을 할 것인지, 비밀번호 변경을 할 것인지의 화면을 보여주는 ViewController 클래스
/// - Author: 안상희
class ChooseEmailPasswordViewController: UIViewController {
    // MARK: Outlet
    /// 이메일 변경 UIButton 버튼입니다.
    @IBOutlet weak var emailButton: UIButton!
    
    /// 비밀번호 변경 UIButton 버튼입니다.
    @IBOutlet weak var passwordButton: UIButton!
    
    
    /// ViewController가 메모리에 로드되면 호출됩니다.
    /// 
    /// View의 초기화 작업을 진행합니다.
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailButton.setButtonTheme()
        passwordButton.setButtonTheme()
    }
}
