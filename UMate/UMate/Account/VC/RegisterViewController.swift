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
        /// To make dynamic enterence year menu depend on current year
        let calender = Calendar.current
        let compo = calender.dateComponents([.year], from: Date())
        var currentyear = DateComponents()
        currentyear.year = compo.year
        
        var previous = DateComponents()
        if let previousYear = compo.year {
            previous.year = previousYear - 14
        }
        guard let currentDate = calender.date(from: currentyear) else { return nil }
        guard let previousDate = calender.date(from: previous) else { return nil }
        
        func dates(from fromDate: Date, to toDate: Date) -> [Date] {
            var dates: [Date] = []
            var date = fromDate
            
            while date <= toDate {
                dates.append(date)
                guard let newDate = Calendar.current.date(byAdding: .year, value: 1, to: date) else { break }
                date = newDate
            }
            return dates
        }
        
        let datesBetweenArray = dates(from: previousDate, to: currentDate)
        for str in datesBetweenArray {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy"
            let getToStr = formatter.string(from: str)
            menu.dataSource.append("\(getToStr)학번")
        }

        return menu
    }()
    
    /// cancel method
    @IBAction func cancel(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    
    
    /// Can choose enterence year
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
        /// To make carve a view's bound.
        [enterenceYearView, universityView].forEach {
            $0?.layer.cornerRadius = 10
            $0?.clipsToBounds = true
        }
        
        nextButton.setButtonTheme()
        enterenceYearLabel.text = "2021학번"
        navigationItem.leftBarButtonItem?.tintColor = UIColor.dynamicColor(light: .darkGray, dark: .lightGray)
        
        /// To initilize enterence menu's view, width, height, color.
        menu?.anchorView = enterenceYearView
        guard let height = menu?.anchorView?.plainView.bounds.height else { return }
        menu?.bottomOffset = CGPoint(x: 0, y: height)
        menu?.width = 150
        menu?.backgroundColor = UIColor.dynamicColor(light: .white, dark: .darkGray)
        
        /// when user didtap background make lower the keyboard.
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        dismissZone.addGestureRecognizer(tap)
        dismissZone2.addGestureRecognizer(tap)
        
        
        ///To receive notification post and then userInfo's data save to userdefaults
        token = NotificationCenter.default.addObserver(forName: .didTapSendUniversityName, object: nil, queue: .main, using: { [weak self] noti in
            guard let strongSelf = self else { return }
            guard let universityName = noti.userInfo?[SearchLIstUniversityViewController.universityNameTransitionKey] as? String else { return }
            
            strongSelf.universityNameField.text = universityName
            strongSelf.saveText = universityName
            UserDefaults.standard.set(universityName, forKey: "universityNameKey")
        })
        
        
    }
    
    /// To make lower the keyboard
    @objc func dismissKeyboard() {
        dismissZone2.endEditing(true)
    }
    
}
