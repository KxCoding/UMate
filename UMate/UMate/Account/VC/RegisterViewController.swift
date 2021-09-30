//
//  RegisterViewController.swift
//  RegisterViewController
//
//  Created by 황신택 on 2021/07/24.
//

import UIKit
import DropDown

/// 학번과 학교이름을 선택하는 클래스.
/// Author: 황신택
class RegisterViewController: UIViewController {
    /// 입학년도  뷰
    @IBOutlet weak var enterenceYearView: UIView!
    
    /// 학교이름  뷰
    @IBOutlet weak var universityView: UIView!
    
    /// 다음화면 버튼
    @IBOutlet weak var nextButton: UIButton!
    
    /// 입학년도 텍스트 필드
    @IBOutlet weak var enterenceYearLabel: UILabel!
    
    /// 키보드가 내려가는 뷰
    @IBOutlet weak var dismissZone: UIView!
    
    /// 키보드가 내려가는 뷰
    @IBOutlet weak var dismissZone2: UIView!
    
    /// 학교이름을 표기할 레이블
    @IBOutlet weak var universityNameField: UILabel!
    
    /// 노티피케이션 데이타를 저장하기 위해서 빈 문자열 속성
    var saveText = ""
    
    /// 옵저버를 제거할 변수.
    var token: NSObjectProtocol?
    
    /// 메뉴 인스턴스를 클로저로 초기화
    /// 실제 Date에 맞춰서 14년 간격으로  학번을 문자열 배열로 리턴
    let menu: DropDown? = {
        let menu = DropDown()
        let current = Calendar.current.component(.year, from: Date())
        
        for n in 0 ... 14 {
            let interval = current - n
            menu.dataSource.append("\(interval)학번")
        }
        return menu
    }()
    
    
    /// 화면을 Dismiss 합니다.
    /// - Parameter sender: UIButton
    @IBAction func cancel(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    
    /// 입학년도를 탭하면 선택 메뉴를 표시합니다.
    /// - Parameter sender: UIButton
    @IBAction func makeEnterenceOfYearData(_ sender: UIButton) {
        /// 높이가 적절 하다면 드롭다운을 show 합니다.
        menu?.show()
        /// 사용자가 셀을 선택시 enterenceYearLabel에 선택한 셀의 item을 전달한다.
        menu?.selectionAction = { [weak self] index, item in
            self?.enterenceYearLabel.text = item
            UserDefaults.standard.set(item, forKey: "enterenceYearKey")
        }
    }
    
    
    /// 입혁년도와 학교이름이 입력되어있는지 확인
    /// 검증되면 다음화면으로 이동
    /// - Parameter sender: nextButton
    @IBAction func checkToConditions(_ sender: Any) {
        guard let enterenceYearText = enterenceYearLabel.text,
              enterenceYearText.count == 6,
              let universityNameText = universityNameField.text,
              universityNameText == saveText else {
                  alert(title: "알림", message: "입학년도 혹은 학교이름을 선택하세요.")
                  return
              }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        [enterenceYearView, universityView].forEach {
            $0?.layer.cornerRadius = 10
            $0?.clipsToBounds = true
        }
        
        /// 버튼에 공통 스타일 적용
        nextButton.setButtonTheme()
        
        /// 입학년도 텍스트필드를 초기화
        enterenceYearLabel.text = "2021학번"
        
        /// 네비게이션 back button을 다크모드 라이트모드를 지원
        navigationItem.leftBarButtonItem?.tintColor = UIColor.dynamicColor(light: .darkGray, dark: .lightGray)
        
        /// 메뉴 anchorView를 아울렛 enterenceYearView 로 저장
        menu?.anchorView = enterenceYearView
        
        /// 메뉴의 앵커뷰 높이를 바인딩
        guard let height = menu?.anchorView?.plainView.bounds.height else { return }
        
        /// 메뉴의 bottomOffset을 초기화
        menu?.bottomOffset = CGPoint(x: 0, y: height)
        
        /// 메뉴의 width 를 초기화
        menu?.width = 150
        
        /// 메뉴의 백그라운드 컬러를 다크모드 라이트모드를 지원
        menu?.backgroundColor = UIColor.dynamicColor(light: .white, dark: .darkGray)
        
        /// 사용자가 view를 탭할시 키보드가 내려감
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        dismissZone.addGestureRecognizer(tap)
        dismissZone2.addGestureRecognizer(tap)
        
        
        /// 노티피케이션 포스트를 받아서 userInfo 데이타를 받은뒤 유저 디폴트에 저장
        token = NotificationCenter.default.addObserver(forName: .didTapSendUniversityName, object: nil, queue: .main, using: { [weak self] noti in
            guard let strongSelf = self else { return }
            guard let universityName = noti.userInfo?[SearchLIstUniversityViewController.universityNameTransitionKey] as? String else { return }
            
            strongSelf.universityNameField.text = universityName
            strongSelf.saveText = universityName
            UserDefaults.standard.set(universityName, forKey: "universityNameKey")
        })
        
        
    }
    
    /// 노티피케이션 옵저버를 제거합니다.
    deinit {
        if let token = token {
            NotificationCenter.default.removeObserver(token)
        }
    }
    
    
    /// 키보드를 내려가게 함
    @objc func dismissKeyboard() {
        dismissZone2.endEditing(true)
    }
    
}
