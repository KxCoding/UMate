//
//  RegisterViewController.swift
//  RegisterViewController
//
//  Created by 황신택 on 2021/07/24.
//

import DropDown
import UIKit
import RxSwift
import RxCocoa
import NSObject_Rx
import RxDataSources


/// 학번과 학교 이름 선택 화면
/// - Author: 황신택 (sinadsl1457@gmail.com), 장현우(heoun3089@gmail.com)
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
    @IBOutlet weak var dismissView: UIView!
    
    /// 학교 이름 레이블
    @IBOutlet weak var universityNameField: UILabel!
    
    /// 학번 드롭다운 버튼
    @IBOutlet weak var UniversityYearButton: UIButton!
    
    
    /// 학교 이름 저장
    /// 노티피케이션 포스팅으로 전달된 학교이름을 저장합니다.
    var universityNameText = ""
    
    /// 메뉴를 최근 14개년 학번 목록으로 초기화 합니다.
    /// - Author: 황신택 (sinadsl1457@gmail.com)
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
    /// - Author: 황신택 (sinadsl1457@gmail.com)
    @IBAction func cancel(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    
    /// 입학 연도와 학교 이름이 입력되어있는지 확인합니다.
    /// 조건에 맞는 경우 다음 화면으로 이동합니다.
    /// - Parameter sender: checkToConditionsButton
    /// - Author: 황신택 (sinadsl1457@gmail.com)
    @IBAction func checkToConditions(_ sender: Any) {
        guard let enterenceYearText = enterenceYearLabel.text,
              enterenceYearText.count == 6,
              let universityNameText = universityNameField.text,
              universityNameText == universityNameText else {
                  alert(title: "알림", message: "입학년도 혹은 학교이름을 선택하세요.")
                  return
              }
    }
    
    
    /// 다음 화면으로 넘어가기 전에 호출됩니다.
    /// - Parameters:
    ///   - segue: 다음 화면 뷰컨트롤러에 대한 정보를 가지고 있는 segue 객체
    ///   - sender: segue를 연결한 객체
    /// - Author: 장현우(heoun3089@gmail.com)
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? TermsOfConditionsTableViewController {
            vc.universityName = universityNameField.text
            
            if let enterenceYear = enterenceYearLabel.text {
                let startIndex = enterenceYear.index(enterenceYear.startIndex, offsetBy: 2)
                
                vc.entranceYear = String(enterenceYear[startIndex...])
            }
        }
    }
    
    
    /// 초기화 작업을 진행합니다.
    /// - Author: 황신택 (sinadsl1457@gmail.com)
    override func viewDidLoad() {
        super.viewDidLoad()
        // 학번 버튼을 탭하면 학번이 드롭다운 됩니다.
        // 학번을 레이블에 표기하고 UserDefaults에 저장합니다.
        UniversityYearButton.rx.tap
            .map { self.menu ?? DropDown() }
            .subscribe(onNext: {
                $0.show()
                $0.selectionAction = { [weak self] index, item in
                    self?.enterenceYearLabel.text = item
                    UserDefaults.standard.set(item, forKey: "enterenceYearKey")
                }
            })
            .disposed(by: rx.disposeBag)
        
        
        [enterenceYearContainerView, universityContainerView].forEach {
            $0?.layer.cornerRadius = 10
            $0?.clipsToBounds = true
        }
        
        nextButton.setToEnabledButtonTheme()
        
        enterenceYearLabel.text = "2021학번"
        
        navigationItem.leftBarButtonItem?.tintColor = UIColor.dynamicColor(light: .darkGray, dark: .lightGray)
        
        menu?.anchorView = enterenceYearContainerView
        guard let height = menu?.anchorView?.plainView.bounds.height else { return }
        menu?.bottomOffset = CGPoint(x: 0, y: height)
        menu?.width = 150
        menu?.backgroundColor = UIColor.dynamicColor(light: .white, dark: .darkGray)
       
     
        // userInfo에서 학교 이름을 받은 뒤 UserDefaults에 저장합니다.
        NotificationCenter.default.rx.notification(.didTapSendUniversityName)
            .compactMap { $0.userInfo?[SearchListUniversityViewController.universityNameTransitionKey] as? String }
            .subscribe(onNext: { [unowned self] in
                self.universityNameText = $0
                self.universityNameField.text = $0
                UserDefaults.standard.set($0, forKey: "universityNameKey")
            })
            .disposed(by: rx.disposeBag)
     
        makeChangeNavigationItemColor()
    }
    
}


