//
//  RegisterViewController.swift
//  RegisterViewController
//
//  Created by 황신택 on 2021/07/24.
//

import UIKit
import DropDown

class RegisterViewController: UIViewController {
    
    // MARK: Outlet
    @IBOutlet weak var enterenceYearView: UIView!
    @IBOutlet weak var universityView: UIView!
    @IBOutlet weak var nextButton: UIView!
    @IBOutlet weak var enterenceTextField: UITextField!
    
    @IBOutlet weak var dismissZone: UIView!
    @IBOutlet weak var dismissZone2: UIView!
    
    @IBOutlet weak var universityNameField: UILabel!
    
    var saveText = ""
    
    // notificationCenter를 저장하기위한 속성
    var token: NSObjectProtocol?
    
    // DropDown타입 배열을 클로저로 초기화한 속성
    let menu: DropDown = {
        let menu = DropDown()
        menu.dataSource = [
            "2021학번",
            "2020학번",
            "2019학번",
            "2018학번",
            "2017학번",
            "2016학번",
            "2015학번",
            "2013학번",
            "2012학번",
            "2011학번",
            "2010학번",
            "2009학번",
            "2008학번",
            "2007학번"
        ]
        
        return menu
    }()
    
    // 취소 메소드
    @IBAction func cancel(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    
    // 학번 선택하는 메소드
    @IBAction func enterenceYearButton(_ sender: UIButton) {
        menu.show()
        menu.selectionAction = { [weak self] index, item in
            self?.enterenceTextField.text = item
            
            UserDefaults.standard.set(item, forKey: "enterenceYearKey")
        }
    }
    
    
    @IBAction func nextButton(_ sender: Any) {
        guard let enterenceYearText = enterenceTextField.text,
              enterenceYearText.count == 6,
        let universityNameText = universityNameField.text,
        universityNameText == saveText else {
            alert(title: "알림", message: "입학년도 혹은 학교이름을 선택하세요.")
            
            return
        }
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ///두 view를 살짝 깎는 클로저
        [enterenceYearView, nextButton].forEach { $0?.layer.cornerRadius = 10
            $0?.clipsToBounds = true
        }
        
        /// 학번 메뉴 width, height 조정
        menu.anchorView = enterenceYearView
        guard let height = menu.anchorView?.plainView.bounds.height else { return }
        menu.bottomOffset = CGPoint(x: 0, y: height)
        menu.width = 150
        
        /// 백그라운드 탭하면 키보드 내려감
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        dismissZone.addGestureRecognizer(tap)
        dismissZone2.addGestureRecognizer(tap)
        
        ///대학교이름을 받아오는 노티피케이션 + 유저디폴트에 저장
        token = NotificationCenter.default.addObserver(forName: .didTapSendUniversityName, object: nil, queue: .main, using: { [weak self] noti in
            guard let strongSelf = self else { return }
            guard let universityName = noti.userInfo?[SearchLIstUniversityViewController.universityNameTransitionKey] as? String else { return }
            
            strongSelf.universityNameField.text = universityName
            strongSelf.saveText = universityName
            UserDefaults.standard.set(universityName, forKey: "universityNameKey")
        })
        
        
    }
    
    // 키보드 내리는 메소드
    @objc func dismissKeyboard() {
        dismissZone2.endEditing(true)
    }
    
}



