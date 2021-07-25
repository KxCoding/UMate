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
    let colors = ["red", "orange", "green", "blue", "purple", "darkGray"]
    var startTime: String = "09:00"
    var endTime: String = "09:00"
    var weekdayInt = 1
    var weekdayList: [Bool] = [false, false, false, false, false]
    var colorString = "red"
    
    @IBOutlet weak var courseIdField: UITextField!
    @IBOutlet weak var courseNameField: UITextField!
    @IBOutlet weak var roomNameField: UITextField!
    @IBOutlet weak var professorField: UITextField!
    
    @IBOutlet weak var colorPicker: UIPickerView!
    
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
    
    
    @IBAction func selectDay(_ sender: UIButton) {
        if sender.tag == 100 {
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
        } else if sender.tag == 101 {
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
        } else if sender.tag == 102 {
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
        } else if sender.tag == 103 {
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
        } else if sender.tag == 104 {
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
        
        mondayContainerView.layer.cornerRadius = mondayContainerView.frame.width / 2
        tuesdayContainerView.layer.cornerRadius = tuesdayContainerView.frame.width / 2
        wednesdayContainerView.layer.cornerRadius = wednesdayContainerView.frame.width / 2
        thursdayContainerView.layer.cornerRadius = thursdayContainerView.frame.width / 2
        fridayContainerView.layer.cornerRadius = fridayContainerView.frame.width / 2
        
        
        mondayContainerView.backgroundColor = .clear
        tuesdayContainerView.backgroundColor = .clear
        wednesdayContainerView.backgroundColor = .clear
        thursdayContainerView.backgroundColor = .clear
        fridayContainerView.backgroundColor = .clear
        
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
                var elliotday: ElliotDay = ElliotDay(rawValue: i + 1)!
                
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



extension AddLectureTableViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0:
            return colors.count
        default:
            return 0
        }
        
    }
    
    
}



extension AddLectureTableViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch component {
        case 0:
            return colors[row]
        default:
            return nil
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch component {
        case 0:
            colorString = colors[row]
        default:
            break
        }
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
