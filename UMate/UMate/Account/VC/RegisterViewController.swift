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
    

    
    /// To save notification data
    var saveText = ""
    
    /// notificationCenter를 저장하기위한 속성
    var token: NSObjectProtocol?
    
    /// To make intialize year of interval as String Array 
    let menu: DropDown? = {
        let menu = DropDown()
      
        func intervalDates(from startingDate:Date, to endDate:Date, with interval:TimeInterval) -> [Date] {
            guard interval > 0 else { return [] }
            
            var dates:[Date] = []
            var currentDate = startingDate
            
            while currentDate <= endDate {
                currentDate = currentDate.addingTimeInterval(interval)
                dates.append(currentDate)
                
            }
            
            return dates
        }

        
        let minimumOfYear = Date(timeIntervalSinceNow: -(60 * 60 * 24 * 365 * 15))
        print(minimumOfYear)
        let maxOfYear = Date()
        let intervalBetweenDates: TimeInterval = 60 * 60 * 24 * 365

        let dates: [Date] = intervalDates(from: minimumOfYear, to: maxOfYear, with: intervalBetweenDates)

        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "yyyy"
        
        var dateStrings = dates.map{ dateformatter.string(from: $0)}
        dateStrings.removeLast()
        print(dateStrings)
        
        for year in dateStrings {
            menu.dataSource.append("\(year)학번")
        }
        
        
        return menu
    }()
    
    /// 취소 메소드
    @IBAction func cancel(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    
    /// 학번 선택하는 메소드
    @IBAction func enterenceYearButton(_ sender: UIButton) {
        menu?.show()
        menu?.selectionAction = { [weak self] index, item in
            self?.enterenceYearLabel.text = item
            
            UserDefaults.standard.set(item, forKey: "enterenceYearKey")
        }
    }
    
    
    /// check the conditions
    /// - Parameter sender: nextButton
    @IBAction func nextButton(_ sender: Any) {
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
        ///두 view를 살짝 깎는 클로저
        [enterenceYearView, universityView].forEach {
            $0?.layer.cornerRadius = 10
            $0?.clipsToBounds = true
        }
        
        nextButton.setButtonTheme()
        enterenceYearLabel.text = "2021학번"
        navigationItem.leftBarButtonItem?.tintColor = UIColor.dynamicColor(light: .darkGray, dark: .lightGray)
        
        /// 학번 메뉴 width, height 조정
        menu?.anchorView = enterenceYearView
        guard let height = menu?.anchorView?.plainView.bounds.height else { return }
        menu?.bottomOffset = CGPoint(x: 0, y: height)
        menu?.width = 150
        
        /// 백그라운드 탭하면 키보드 내려감
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        dismissZone.addGestureRecognizer(tap)
        dismissZone2.addGestureRecognizer(tap)
        
        /// 대학교이름을 받아오는 노티피케이션 + 유저디폴트에 저장
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
