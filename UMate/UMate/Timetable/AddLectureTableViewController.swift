//
//  AddLectureTableViewController.swift
//  UMate
//
//  Created by 안상희 on 2021/07/21.
//

import UIKit

class AddLectureTableViewController: UITableViewController {
    
    let weekdays = ["월", "화", "수", "목", "금"]
    let colors = ["red", "orange", "green", "blue", "purple", "darkGray"]
    var startTime: String = "09:00"
    var endTime: String = "09:00"
    
    @IBOutlet weak var courseIdField: UITextField!
    @IBOutlet weak var courseNameField: UITextField!
    @IBOutlet weak var roomNameField: UITextField!
    @IBOutlet weak var professorField: UITextField!
    
    @IBOutlet weak var weekdayPicker: UIPickerView!
    @IBOutlet weak var colorPicker: UIPickerView!
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
        
        alert(title: "알림", message: "저장되었습니다.")
    }
}





extension AddLectureTableViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        
        let newLength = text.count + string.count - range.length
        
        print(newLength)
        return newLength <= 20
    }
    
}



extension AddLectureTableViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == weekdayPicker {
            switch component {
            case 0:
                return weekdays.count
            default:
                return 0
            }
        } else {
            switch component {
            case 0:
                return colors.count
            default:
                return 0
            }
        }
        
    }
    
    
}



extension AddLectureTableViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == weekdayPicker {
            switch component {
            case 0:
                return weekdays[row]
            default:
                return nil
            }
        } else {
            switch component {
            case 0:
                return colors[row]
            default:
                return nil
            }
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == weekdayPicker {
            switch component {
            case 0:
                print(weekdays[row])
            default:
                break
            }
        } else {
            switch component {
            case 0:
                print(colors[row])
            default:
                break
            }
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
