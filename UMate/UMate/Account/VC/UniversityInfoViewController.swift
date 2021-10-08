//
//  RegisterViewController.swift
//  RegisterViewController
//
//  Created by 황신택 on 2021/07/24.
//

import UIKit
import DropDown

/// 학번과 학교 이름 선택 화면
/// Author: 황신택 (sinadsl1457@gmail.com)
class UniversityInfoViewController: CommonViewController {
    /// 입학년도 뷰
    @IBOutlet weak var enterenceYearContainerView: UIView!
    
    /// 학교 이름 뷰
    @IBOutlet weak var universityContainerView: UIView!
    
    /// 다음 화면 버튼
    @IBOutlet weak var nextButton: UIButton!
    
    /// 입학년도 필드
    @IBOutlet weak var enterenceYearLabel: UILabel!
    
    /// 키보드가 내려가는 뷰
    @IBOutlet weak var dismissZone: UIView!
    
    /// 학교 이름 레이블
    @IBOutlet weak var universityNameField: UILabel!
    
    /// 학교 이름 저장
    /// 노티피케이션 포스팅으로 전달된 학교이름을 저장합니다.
    var universityNameText = ""
    
    /// 메뉴를 최근 14개년 학번 목록으로 초기화 합니다.
    /// Author: 황신택 (sinadsl1457@gmail.com)
    let menu: DropDown? = {
        let menu = DropDown()
        let current = Calendar.current.component(.year, from: Date())
        
        for n in 0 ... 14 {
            let interval = current - n
            menu.dataSource.append("\(interval)학번")
        }
        return menu
    }()
    
    
    /// 이전 화면으로 이동합니다.
    /// - Parameter sender: cancelButton
    /// Author: 황신택 (sinadsl1457@gmail.com)
    @IBAction func cancel(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    
    /// 버튼을 탭하면 선택 메뉴를 표시합니다.
    /// 선택된 항목을 유저디폴츠에 저장합니다.
    /// - Parameter sender: makeEnterenceOfYearDataButton
    /// 황신택 (sinadsl1457@gmail.com)
    @IBAction func makeEnterenceOfYearData(_ sender: UIButton) {
        // 높이가 적절하다면 드롭다운 합니다.
        menu?.show()
        
        // 사용자가 셀을 선택시 enterenceYearLabel에 선택한 셀의 item을 표시합니다.
        menu?.selectionAction = { [weak self] index, item in
            self?.enterenceYearLabel.text = item
            UserDefaults.standard.set(item, forKey: "enterenceYearKey")
        }
    }
    
    
    /// 입혁년도와 학교 이름이 입력되어있는지 확인합니다.
    /// 조건에 맞는 경우 다음 화면으로 이동합니다.
    /// - Parameter sender: checkToConditionsButton
    /// Author: 황신택 (sinadsl1457@gmail.com)
    @IBAction func checkToConditions(_ sender: Any) {
        guard let enterenceYearText = enterenceYearLabel.text,
              enterenceYearText.count == 6,
              let universityNameText = universityNameField.text,
              universityNameText == universityNameText else {
                  alert(title: "알림", message: "입학년도 혹은 학교이름을 선택하세요.")
                  return
              }
    }
    
    
    
    /// 초기화 작업을 진행합니다.
    /// Author: 황신택 (sinadsl1457@gmail.com)
    override func viewDidLoad() {
        super.viewDidLoad()
        [enterenceYearContainerView, universityContainerView].forEach {
            $0?.layer.cornerRadius = 10
            $0?.clipsToBounds = true
        }
        
        nextButton.setToEnabledButtonTheme()
        
        enterenceYearLabel.text = "2021학번"
        
        navigationItem.leftBarButtonItem?.tintColor = UIColor.dynamicColor(light: .darkGray, dark: .lightGray)
        
        // 메뉴 anchorView를 아울렛 enterenceYearView로 저장합니다.
        // 메뉴의 여러 속성을 초기화합니다.
        menu?.anchorView = enterenceYearContainerView
        guard let height = menu?.anchorView?.plainView.bounds.height else { return }
        menu?.bottomOffset = CGPoint(x: 0, y: height)
        menu?.width = 150
        menu?.backgroundColor = UIColor.dynamicColor(light: .white, dark: .darkGray)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        dismissZone.addGestureRecognizer(tap)
        
        
        // 유저인포에서 학교 이름을 받은 뒤 유저디폴츠에 저장합니다.
        let token = NotificationCenter.default.addObserver(forName: .didTapSendUniversityName, object: nil, queue: .main, using: { [weak self] noti in
            guard let strongSelf = self else { return }
            guard let universityName = noti.userInfo?[SearchListUniversityViewController.universityNameTransitionKey] as? String else { return }
            
            strongSelf.universityNameField.text = universityName
            strongSelf.universityNameText = universityName
            UserDefaults.standard.set(universityName, forKey: "universityNameKey")
        })
        
        tokens.append(token)
    }
    
    
    /// 뷰를 탭하면 키보드를 내립니다.
    /// 탭을 인식하는 영역은 입학년도 뷰 입니다.
    /// Author: 황신택 (sinadsl1457@gmail.com)
    @objc func dismissKeyboard() {
        dismissZone.endEditing(true)
    }
    
}
