//
//  AddLectureTableViewController.swift
//  UMate
//
//  Created by 안상희 on 2021/07/21.
//

import UIKit
import Elliotable

protocol SendDataDelegate {
    func sendData(data: [ElliottEvent])
}

class AddLectureTableViewController: UITableViewController {
    
    var delegate: SendDataDelegate?
    let weekdays = ["월", "화", "수", "목", "금"]
    let colors = ["lightRed", "red", "pink", "orange", "yellow", "lightGreen", "green", "skyblue", "blue", "lightPurple", "purple", "darkGray"]
    var startTime: String = "09:00"
    var endTime: String = "09:00"
    var weekdayInt = 1
    var weekdayList: [Bool] = [false, false, false, false, false]
    var colorString = "lightRed"
    let buttonImage = UIImage(named: "check")
    
    @IBOutlet weak var courseIdField: UITextField!
    @IBOutlet weak var courseNameField: UITextField!
    @IBOutlet weak var roomNameField: UITextField!
    @IBOutlet weak var professorField: UITextField!
    
    @IBOutlet weak var mondayContainerView: UIView!
    @IBOutlet weak var tuesdayContainerView: UIView!
    @IBOutlet weak var wednesdayContainerView: UIView!
    @IBOutlet weak var thursdayContainerView: UIView!
    @IBOutlet weak var fridayContainerView: UIView!
    
    @IBOutlet weak var mondayLabel: UILabel!
    @IBOutlet weak var tuesdayLabel: UILabel!
    @IBOutlet weak var wednesdayLabel: UILabel!
    @IBOutlet weak var thursdayLabel: UILabel!
    @IBOutlet weak var fridayLabel: UILabel!
    
    
    @IBOutlet weak var lightRedView: UIView!
    @IBOutlet weak var redView: UIView!
    @IBOutlet weak var pinkView: UIView!
    @IBOutlet weak var orangeView: UIView!
    @IBOutlet weak var yellowView: UIView!
    @IBOutlet weak var lightGreenView: UIView!
    @IBOutlet weak var greenView: UIView!
    @IBOutlet weak var skyblueView: UIView!
    @IBOutlet weak var blueView: UIView!
    @IBOutlet weak var lightPurpleView: UIView!
    @IBOutlet weak var purpleView: UIView!
    @IBOutlet weak var darkGrayView: UIView!
    
    @IBOutlet weak var lightRedButton: UIButton!
    @IBOutlet weak var redButton: UIButton!
    @IBOutlet weak var pinkButton: UIButton!
    @IBOutlet weak var orangeButton: UIButton!
    @IBOutlet weak var yellowButton: UIButton!
    @IBOutlet weak var lightGreenButton: UIButton!
    @IBOutlet weak var greenButton: UIButton!
    @IBOutlet weak var skyblueButton: UIButton!
    @IBOutlet weak var blueButton: UIButton!
    @IBOutlet weak var lightPurpleButton: UIButton!
    @IBOutlet weak var purpleButton: UIButton!
    @IBOutlet weak var darkGrayButton: UIButton!
    
    
    
    
    
    @IBAction func selectDay(_ sender: UIButton) {
        if sender.tag == 101 {
            if mondayContainerView.backgroundColor == .clear {
                mondayContainerView.backgroundColor = UIColor.systemPink
                mondayLabel.textColor = UIColor.white
                weekdayInt = 1
                weekdayList[0] = true
            } else {
                mondayContainerView.backgroundColor = .clear
                mondayLabel.textColor = UIColor.black
                weekdayList[0] = false
            }
        } else if sender.tag == 102 {
            if tuesdayContainerView.backgroundColor == .clear {
                tuesdayContainerView.backgroundColor = UIColor.systemPink
                tuesdayLabel.textColor = UIColor.white
                weekdayInt = 2
                weekdayList[1] = true
            } else {
                tuesdayContainerView.backgroundColor = .clear
                tuesdayLabel.textColor = UIColor.black
                weekdayList[1] = false
            }
        } else if sender.tag == 103 {
            if wednesdayContainerView.backgroundColor == .clear {
                wednesdayContainerView.backgroundColor = UIColor.systemPink
                wednesdayLabel.textColor = UIColor.white
                weekdayInt = 3
                weekdayList[2] = true
            } else {
                wednesdayContainerView.backgroundColor = .clear
                wednesdayLabel.textColor = UIColor.black
                weekdayList[2] = false
            }
        } else if sender.tag == 104 {
            if thursdayContainerView.backgroundColor == .clear {
                thursdayContainerView.backgroundColor = UIColor.systemPink
                thursdayLabel.textColor = UIColor.white
                weekdayInt = 4
                weekdayList[3] = true
            } else {
                thursdayContainerView.backgroundColor = .clear
                thursdayLabel.textColor = UIColor.black
                weekdayList[3] = false
            }
        } else if sender.tag == 105 {
            if fridayContainerView.backgroundColor == .clear {
                fridayContainerView.backgroundColor = UIColor.systemPink
                fridayLabel.textColor = UIColor.white
                weekdayInt = 5
                weekdayList[4] = true
            } else {
                fridayContainerView.backgroundColor = .clear
                fridayLabel.textColor = UIColor.black
                weekdayList[4] = false
            }
        }
    }
    
    @IBAction func selectColor(_ sender: UIButton) {
        if sender.tag == 200 {
            if sender.image(for: .normal) == nil {
                sender.setImage(buttonImage, for: .normal)
                colorString = "lightRed"
                
                [redButton, pinkButton, orangeButton, yellowButton, lightGreenButton, greenButton, skyblueButton, blueButton, lightPurpleButton, purpleButton, darkGrayButton].forEach {
                    $0?.setImage(nil, for: .normal)
                }
            } else {
                sender.setImage(nil, for: .normal)
            }
        } else if sender.tag == 201 {
            if sender.image(for: .normal) == nil {
                sender.setImage(buttonImage, for: .normal)
                colorString = "red"
                
                [lightRedButton, pinkButton, orangeButton, yellowButton, lightGreenButton, greenButton, skyblueButton, blueButton, lightPurpleButton, purpleButton, darkGrayButton].forEach {
                    $0?.setImage(nil, for: .normal)
                }
            } else {
                sender.setImage(nil, for: .normal)
            }
        } else if sender.tag == 202 {
            if sender.image(for: .normal) == nil {
                sender.setImage(buttonImage, for: .normal)
                colorString = "pink"
                
                [lightRedButton, redButton, orangeButton, yellowButton, lightGreenButton, greenButton, skyblueButton, blueButton, lightPurpleButton, purpleButton, darkGrayButton].forEach {
                    $0?.setImage(nil, for: .normal)
                }
            } else {
                sender.setImage(nil, for: .normal)
            }
        } else if sender.tag == 203 {
            if sender.image(for: .normal) == nil {
                sender.setImage(buttonImage, for: .normal)
                colorString = "orange"
                
                [lightRedButton, redButton, pinkButton, yellowButton, lightGreenButton, greenButton, skyblueButton, blueButton, lightPurpleButton, purpleButton, darkGrayButton].forEach {
                    $0?.setImage(nil, for: .normal)
                }
            } else {
                sender.setImage(nil, for: .normal)
            }
        } else if sender.tag == 204 {
            if sender.image(for: .normal) == nil {
                sender.setImage(buttonImage, for: .normal)
                colorString = "yellow"
                
                [lightRedButton, redButton, pinkButton, orangeButton, lightGreenButton, greenButton, skyblueButton, blueButton, lightPurpleButton, purpleButton, darkGrayButton].forEach {
                    $0?.setImage(nil, for: .normal)
                }
            } else {
                sender.setImage(nil, for: .normal)
            }
        } else if sender.tag == 205 {
            if sender.image(for: .normal) == nil {
                sender.setImage(buttonImage, for: .normal)
                colorString = "lightGreen"
                
                [lightRedButton, redButton, pinkButton, orangeButton, yellowButton, greenButton, skyblueButton, blueButton, lightPurpleButton, purpleButton, darkGrayButton].forEach {
                    $0?.setImage(nil, for: .normal)
                }
            } else {
                sender.setImage(nil, for: .normal)
            }
        } else if sender.tag == 206 {
            if sender.image(for: .normal) == nil {
                sender.setImage(buttonImage, for: .normal)
                colorString = "green"
                
                [lightRedButton, redButton, pinkButton, orangeButton, yellowButton, lightGreenButton, skyblueButton, blueButton, lightPurpleButton, purpleButton, darkGrayButton].forEach {
                    $0?.setImage(nil, for: .normal)
                }
            } else {
                sender.setImage(nil, for: .normal)
            }
        } else if sender.tag == 207 {
            if sender.image(for: .normal) == nil {
                sender.setImage(buttonImage, for: .normal)
                colorString = "skyblue"
                
                [lightRedButton, redButton, pinkButton, orangeButton, yellowButton, lightGreenButton, greenButton, blueButton, lightPurpleButton, purpleButton, darkGrayButton].forEach {
                    $0?.setImage(nil, for: .normal)
                }
            } else {
                sender.setImage(nil, for: .normal)
            }
        } else if sender.tag == 208 {
            if sender.image(for: .normal) == nil {
                sender.setImage(buttonImage, for: .normal)
                colorString = "blue"
                
                [lightRedButton, redButton, pinkButton, orangeButton, yellowButton, lightGreenButton, greenButton, skyblueButton, lightPurpleButton, purpleButton, darkGrayButton].forEach {
                    $0?.setImage(nil, for: .normal)
                }
            } else {
                sender.setImage(nil, for: .normal)
            }
        } else if sender.tag == 209 {
            if sender.image(for: .normal) == nil {
                sender.setImage(buttonImage, for: .normal)
                colorString = "lightPurple"
                
                [lightRedButton, redButton, pinkButton, orangeButton, yellowButton, lightGreenButton, greenButton, skyblueButton, blueButton, purpleButton, darkGrayButton].forEach {
                    $0?.setImage(nil, for: .normal)
                }
            } else {
                sender.setImage(nil, for: .normal)
            }
        } else if sender.tag == 210 {
            if sender.image(for: .normal) == nil {
                sender.setImage(buttonImage, for: .normal)
                colorString = "purple"
                
                [lightRedButton, redButton, pinkButton, orangeButton, yellowButton, lightGreenButton, greenButton, skyblueButton, blueButton, lightPurpleButton, darkGrayButton].forEach {
                    $0?.setImage(nil, for: .normal)
                }
            } else {
                sender.setImage(nil, for: .normal)
            }
        } else if sender.tag == 211 {
            if sender.image(for: .normal) == nil {
                sender.setImage(buttonImage, for: .normal)
                colorString = "darkGray"
                
                [lightRedButton, redButton, pinkButton, orangeButton, yellowButton, lightGreenButton, greenButton, skyblueButton, blueButton, lightPurpleButton, purpleButton].forEach {
                    $0?.setImage(nil, for: .normal)
                }
            } else {
                sender.setImage(nil, for: .normal)
            }
        }
        
    }
    
    
    @IBAction func startTimeDidSelected(_ sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        startTime = dateFormatter.string(from: sender.date)
    }
    
    @IBAction func endTimeDidSelected(_ sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        endTime = dateFormatter.string(from: sender.date)
    }
    
    func checkMaxLength(textField: UITextField!, maxLength: Int) {
        if (textField.text?.count ?? 0 > maxLength) {
            textField.deleteBackward()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        courseIdField.delegate = self
        courseNameField.delegate = self
        roomNameField.delegate = self
        professorField.delegate = self
        
        [mondayContainerView, tuesdayContainerView, wednesdayContainerView, thursdayContainerView, fridayContainerView].forEach {
            $0?.layer.cornerRadius = ($0?.frame.width)! / 2
            $0?.backgroundColor = .clear
        }
        
        [lightRedView, redView, pinkView, orangeView, yellowView, lightGreenView, greenView, skyblueView, blueView, lightPurpleView, purpleView, darkGrayView
        ].forEach {
            $0?.layer.cornerRadius = ($0?.frame.width)! / 2
        }
        
        self.courseIdField.becomeFirstResponder()
    }
    
    
    @IBAction func cancel(_ sender: Any) {
        alertWithTwoButton(title: "경고", message: "정말 취소하시겠습니까?")
    }
    
    
    @IBAction func save(_ sender: Any) {
        // 시간표에 데이터 전달하기 위한 값
        guard let courseId = courseIdField.text, courseId.count > 0, let courseName = courseNameField.text, courseName.count > 0, let roomName = roomNameField.text, roomName.count > 0, let professor = professorField.text, professor.count > 0 else {
            alertWithNoAction(title: "경고", message: "시간표 정보를 모두 입력해주세요.")
            return
        }
        
        if weekdayList[0] == false, weekdayList[1] == false, weekdayList[2] == false, weekdayList[3] == false, weekdayList[4] == false {
            alertWithNoAction(title: "경고", message: "요일 정보를 입력해주세요.")
            return
        }
        
        if startTime == endTime {
            alertWithNoAction(title: "경고", message: "강의 시작 시간과 종료 시간이 같습니다.")
            return
        }
        
        if startTime > endTime {
            alertWithNoAction(title: "경고", message: "강의 시작 시간이 종료 시간보다 늦습니다.")
            return
        }
        
        let backgroundColor: UIColor = UIColor(named: "\(colorString)") ?? .black
        
        
        var lectureList: [ElliottEvent] = []
        
        for i in 0...4 {
            if weekdayList[i] == true {
                let elliotday: ElliotDay = ElliotDay(rawValue: i + 1)!
                
                let lectureInfo = ElliottEvent(courseId: courseId, courseName: courseName, roomName: roomName, professor: professor, courseDay: elliotday, startTime: startTime, endTime: endTime, backgroundColor: backgroundColor)
                
                lectureList.append(lectureInfo)
                
            }
        }
        delegate?.sendData(data: lectureList)
        
        alert(title: "알림", message: "저장되었습니다.")
    }
}





extension AddLectureTableViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        
        let newLength = text.count + string.count - range.length

        return newLength <= 20
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == courseIdField {
            courseNameField.becomeFirstResponder()
        } else if textField == courseNameField {
            roomNameField.becomeFirstResponder()
        } else if textField == roomNameField {
            professorField.becomeFirstResponder()
        }
        
        return true
    }
}


extension UITableViewController {
    func alertWithTwoButton(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "이어서", style: .default) { action in
        }
        alert.addAction(okAction)
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel) { action in
            self.dismiss(animated: true, completion: nil)
        }
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
}
