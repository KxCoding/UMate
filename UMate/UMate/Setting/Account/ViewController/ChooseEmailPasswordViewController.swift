//
//  ChooseEmailPasswordViewController.swift
//  ChooseEmailPasswordViewController
//
//  Created by 안상희 on 2021/08/08.
//

import UIKit


/// 사용자 계정 설정의 이메일 변경 / 비밀번호 변경을 선택하는 화면 ViewController 클래스
///
/// 이메일 변경을 할 것인지, 비밀번호 변경을 할 것인지 선택합니다.
/// - Author: 안상희
class ChooseEmailPasswordViewController: UIViewController {
    /// 이메일 변경 버튼
    @IBOutlet weak var emailButton: UIButton!
    
    /// 비밀번호 변경 버튼
    @IBOutlet weak var passwordButton: UIButton!
    
    
    /// ViewController가 메모리에 로드되면 호출됩니다.
    /// 
    /// View의 초기화 작업을 진행합니다.
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailButton.setToEnabledButtonTheme()
        passwordButton.setToEnabledButtonTheme()
    }
}
