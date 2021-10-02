//
//  RegisterViewController.swift
//  RegisterViewController
//
//  Created by 황신택 on 2021/07/24.
//

import UIKit
import DropDown

class RegisterViewController: UIViewController {
    
    @IBOutlet weak var enterenceYearView: UIView!
    @IBOutlet weak var universityView: UIView!
    @IBOutlet weak var nextView: UIView!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var enterenceYearLabel: UILabel!
    @IBOutlet weak var dismissZone: UIView!
    @IBOutlet weak var dismissZone2: UIView!
    @IBOutlet weak var universityNameField: UILabel!
    
    /// 노티피케이션 데이타를 저장하기 위해서 빈 문자열 속성 선언
    var saveText = ""
    
    /// 노티피케이션을 저장하고 deinit 하기위한 속성
    var token: NSObjectProtocol?
    
    /// 메뉴 인스턴스를 클로저로 초기화.
    /// 실제 연도에 맞춰서 14년 인터벌의  학번을 문자열 배열로 리턴함
    let menu: DropDown? = {
        let menu = DropDown()
        let current = Calendar.current.component(.year, from: Date())
        
        for n in 0 ... 14 {
            let interval = current - n
            menu.dataSource.append("\(interval)학번")
        }
        return menu
    }()
    
    /// 화면을 dismiss함.
    @IBAction func cancel(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    
    
    /// 입학년도를 고를수있는 버튼 메소드
    @IBAction func makeEnterenceOfYearData(_ sender: UIButton) {
        menu?.show()
        menu?.selectionAction = { [weak self] index, item in
            self?.enterenceYearLabel.text = item
            
            UserDefaults.standard.set(item, forKey: "enterenceYearKey")
        }
    }
    
    
    /// 입혁년도와 학교이름이 입력되어있는지 확인함.
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
        /// 뷰 바운드를 깎음.
        [enterenceYearView, universityView].forEach {
            $0?.layer.cornerRadius = 10
            $0?.clipsToBounds = true
        }
        
        /// 규격화된 버튼모양으로 만듬.
        nextButton.setToEnabledButtonTheme()
        
        /// 입학년도 텍스트필드를 초기화합니다
        enterenceYearLabel.text = "2021학번"
        navigationItem.leftBarButtonItem?.tintColor = UIColor.dynamicColor(light: .darkGray, dark: .lightGray)
        
        /// 메뉴인스턴스의 height, width, color, bottomoffset을 초기화.
        menu?.anchorView = enterenceYearView
        guard let height = menu?.anchorView?.plainView.bounds.height else { return }
        menu?.bottomOffset = CGPoint(x: 0, y: height)
        menu?.width = 150
        menu?.backgroundColor = UIColor.dynamicColor(light: .white, dark: .darkGray)
        
        /// 사용자가 view를 탭할시 키보드가 내려감.
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        dismissZone.addGestureRecognizer(tap)
        dismissZone2.addGestureRecognizer(tap)
        
        
        /// 노티피케이션 포스트를 받아서 유저인포 데이타를 받은뒤 유저 디폴트에 저장.
        token = NotificationCenter.default.addObserver(forName: .didTapSendUniversityName, object: nil, queue: .main, using: { [weak self] noti in
            guard let strongSelf = self else { return }
            guard let universityName = noti.userInfo?[SearchLIstUniversityViewController.universityNameTransitionKey] as? String else { return }
            
            strongSelf.universityNameField.text = universityName
            strongSelf.saveText = universityName
            UserDefaults.standard.set(universityName, forKey: "universityNameKey")
        })
        
        
    }
    
    /// 키보드를 내려가게 한다.
    @objc func dismissKeyboard() {
        dismissZone2.endEditing(true)
    }
    
}
