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
    var startTime: String = "09:00"
    var endTime: String = "09:00"
    var weekdayInt = 1
    var weekdayList: [Bool] = [false, false, false, false, false]
    var colorString = "lightRed"
    var textColorString = "black"
    var isWeekdayInfoEntered = false
    let buttonImage = UIImage(named: "check")
    
    
    // Outlet - 강의 ID, 강의명, 강의실, 교수님 이름을 입력하기 위한 TextField
    @IBOutlet weak var courseIdField: UITextField!
    @IBOutlet weak var courseNameField: UITextField!
    @IBOutlet weak var roomNameField: UITextField!
    @IBOutlet weak var professorField: UITextField!
    
    
    // Outlet - 요일을 나타내는 UIView
    @IBOutlet weak var mondayContainerView: UIView!
    @IBOutlet weak var tuesdayContainerView: UIView!
    @IBOutlet weak var wednesdayContainerView: UIView!
    @IBOutlet weak var thursdayContainerView: UIView!
    @IBOutlet weak var fridayContainerView: UIView!
    
    
    // Outlet - 요일을 나타내는 UILabel
    @IBOutlet weak var mondayLabel: UILabel!
    @IBOutlet weak var tuesdayLabel: UILabel!
    @IBOutlet weak var wednesdayLabel: UILabel!
    @IBOutlet weak var thursdayLabel: UILabel!
    @IBOutlet weak var fridayLabel: UILabel!
    
    
    // Outlet - 색상을 선택하기 위한 UIView
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
    
    
    // Outlet - 색상을 선택하기 위한 UIButton
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
    
    
    
    /// 요일 정보를 선택하는 메소드입니다. 요일 클릭 시, 선택 상태가 변경됩니다.
    /// - Parameters:
    ///   - view: 선택된 버튼에 해당하는 뷰
    ///   - label: 선택된 버튼에 해당하는 라벨
    func selectedWeekday(view: UIView, label: UILabel) {
        view.backgroundColor = UIColor.systemGray
        label.textColor = UIColor.white
    }
    
    
    /// 요일 정보를 선택해제 하는 메소드입니다. 요일 선택을 해제할 때 호출됩니다.
    /// - Parameters:
    ///   - view: 선택 해제된 버튼에 해당하는 뷰
    ///   - label: 선택 해제된 버튼에 해당하는 라벨
    func unselectedWeekDay(view: UIView, label: UILabel) {
        view.backgroundColor = .clear
        label.textColor = UIColor.black
    }
    
    
    /// 요일 정보를 선택하는 메소드입니다.
    /// - Parameter sender: 선택된 버튼
    @IBAction func selectDay(_ sender: UIButton) {
        
        switch sender.tag {
        case 101:
            if mondayContainerView.backgroundColor == .clear {
                selectedWeekday(view: mondayContainerView, label: mondayLabel)
                weekdayInt = 1
                weekdayList[0] = true
                break
            }
            
            unselectedWeekDay(view: mondayContainerView, label: mondayLabel)
            weekdayList[0] = false
            
        case 102:
            if tuesdayContainerView.backgroundColor == .clear {
                selectedWeekday(view: tuesdayContainerView, label: tuesdayLabel)
                weekdayInt = 2
                weekdayList[1] = true
                break
            }
            
            unselectedWeekDay(view: tuesdayContainerView, label: tuesdayLabel)
            weekdayList[1] = false
            
        case 103:
            if wednesdayContainerView.backgroundColor == .clear {
                selectedWeekday(view: wednesdayContainerView, label: wednesdayLabel)
                weekdayInt = 3
                weekdayList[2] = true
                break
            }
            
            unselectedWeekDay(view: wednesdayContainerView, label: wednesdayLabel)
            weekdayList[2] = false
            
        case 104:
            if thursdayContainerView.backgroundColor == .clear {
                selectedWeekday(view: thursdayContainerView, label: thursdayLabel)
                weekdayInt = 4
                weekdayList[3] = true
                break
            }
            
            unselectedWeekDay(view: thursdayContainerView, label: thursdayLabel)
            weekdayList[3] = false
            
        case 105:
            if fridayContainerView.backgroundColor == .clear {
                selectedWeekday(view: fridayContainerView, label: fridayLabel)
                weekdayInt = 5
                weekdayList[4] = true
                break
            }
            
            unselectedWeekDay(view: fridayContainerView, label: fridayLabel)
            weekdayList[4] = false
        default:
            break
        }
    }
    
    
    /// 모든 버튼의 상태를 초기화 해주는 메소드입니다.
    func initializeColorButton() {
        [lightRedButton, redButton, pinkButton, orangeButton, yellowButton,
         lightGreenButton, greenButton, skyblueButton, blueButton,
         lightPurpleButton, purpleButton, darkGrayButton].forEach {
            $0?.setImage(nil, for: .normal)
        }
    }
    
    
    /// 선택된 버튼에 체크 표시를 하고, 시간표 색상 값을 정해주는 메소드입니다.
    /// - Parameter sender: 선택된 버튼
    func selectedButton(sender: UIButton) {
        
        sender.setImage(buttonImage, for: .normal)
        sender.tintColor = UIColor.black
        
        guard let colorName = sender.backgroundColor?.name as? String else { return }
        
        
        colorString = colorName
    }
    
    
    /// 시간표 색상을 선택하는 메소드입니다.
    /// - Parameter sender: 선택된 버튼 (색상)
    @IBAction func selectColor(_ sender: UIButton) {
        
        initializeColorButton()
        
        selectedButton(sender: sender)
        
        
        switch sender.tag {
        /// case 200, 201, 206, 208, 210, 211의 경우는 textColor을 흰색으로 설정합니다.
        case 200, 201, 206, 208, 210, 211:
            textColorString = "white"
            
        /// 그 외의 경우는 모두 textColor을 검은색으로 설정합니다.
        default:
            textColorString = "black"
        }
    }
    
    
    /// 시간표 추가 화면에서 강의 시작 시간이 선택되면 호출되는 메소드입니다.
    /// - Parameter sender: UIDatePicker
    @IBAction func startTimeDidSelected(_ sender: UIDatePicker) {
        startTime = sender.date.timeTableTime
    }
    
    
    /// 시간표 추가 화면에서 강의 종료 시간이 선택되면 호출되는 메소드입니다.
    /// - Parameter sender: UIDatePicker
    @IBAction func endTimeDidSelected(_ sender: UIDatePicker) {
        endTime = sender.date.timeTableTime
    }
    
    
    /// textField의 길이를 체크하는 메소드입니다.
    /// - Parameters:
    ///   - textField: UITextField
    ///   - maxLength: 최대 글자 수
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
        
        [mondayContainerView, tuesdayContainerView, wednesdayContainerView,
         thursdayContainerView, fridayContainerView].forEach {
            $0?.layer.cornerRadius = ($0?.frame.width)! / 2
            $0?.backgroundColor = .clear
        }
        
        
        [lightRedView, redView, pinkView, orangeView, yellowView, lightGreenView,
         greenView, skyblueView, blueView, lightPurpleView, purpleView, darkGrayView,
         lightRedButton, redButton, pinkButton, orangeButton, yellowButton, lightGreenButton,
         greenButton, skyblueButton, blueButton, lightPurpleButton, purpleButton, darkGrayButton
        ].forEach {
            $0?.layer.cornerRadius = ($0?.frame.width)! / 2
        }
        
        self.courseIdField.becomeFirstResponder()
    }
    
    
    @IBAction func cancel(_ sender: Any) {
        alertVersion2(title: "경고", message: "정말 취소하시겠습니까?") { action in
            
        } handler2: { action in
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    
    /// 시간표에 데이터를 저장할 때 호출되는 메소드입니다.
    /// - Parameter sender: UIBarButtonItem
    @IBAction func save(_ sender: Any) {
        // 시간표에 데이터 전달하기 위한 값
        guard let courseId = courseIdField.text, courseId.count > 0,
                let courseName = courseNameField.text, courseName.count > 0,
                let roomName = roomNameField.text, roomName.count > 0,
                let professor = professorField.text, professor.count > 0 else {
                    
            alert(title: "경고", message: "시간표 정보를 모두 입력해주세요.")
                    
            return
        }
        
        /// 요일 정보가 있는지 확인하기 위한 반복문
        for i in 0...4 {
            if weekdayList[i] == true {
                isWeekdayInfoEntered = true
            }
        }
        
        
        /// 요일 정보가 없다면 경고창
        if !isWeekdayInfoEntered {
            alert(title: "경고", message: "요일 정보를 입력해주세요.")
            
            return
        }
        
        
        if startTime == endTime {
            alert(title: "경고", message: "강의 시작 시간과 종료 시간이 같습니다.")
            
            return
        }
        
        
        if startTime > endTime {
            alert(title: "경고", message: "강의 시작 시간이 종료 시간보다 늦습니다.")
            
            return
        }
        
        
        let backgroundColor: UIColor = UIColor(named: "\(colorString)") ?? .black

        let textColor: UIColor = UIColor(named: "\(textColorString)") ?? .white
        
        var lectureList: [ElliottEvent] = []
        
        
        for i in 0...4 {
            if weekdayList[i] == true {
                let elliotday: ElliotDay = ElliotDay(rawValue: i + 1)!
                
                let lectureInfo = ElliottEvent(courseId: courseId,
                                               courseName: courseName,
                                               roomName: roomName,
                                               professor: professor,
                                               courseDay: elliotday,
                                               startTime: startTime,
                                               endTime: endTime,
                                               textColor: textColor,
                                               backgroundColor: backgroundColor)
                
                lectureList.append(lectureInfo)
            }
        }
        
        
        if !Lecture.shared.courseList.isEmpty { // 이미 강의 정보가 저장되어있을 경우 시간표 중복 체크
            for i in 0...Lecture.shared.courseList.count - 1 {
                for j in 0...lectureList.count - 1 {
                    if lectureList[j].courseDay == Lecture.shared.courseList[i].courseDay {
                        
                        if Lecture.shared.courseList[i].startTime == lectureList[j].startTime ||
                            Lecture.shared.courseList[i].endTime == lectureList[j].endTime {
                            
                            alert(title: "경고", message: "강의 시간이 겹칩니다.")
                            
                            return
                        }
                        
                        
                        if lectureList[j].startTime >= Lecture.shared.courseList[i].startTime &&
                            lectureList[j].endTime <= Lecture.shared.courseList[i].endTime {
                            
                            alert(title: "경고", message: "강의 시간이 겹칩니다.")
                            
                            return
                        }
                        
                        
                        if lectureList[j].startTime > Lecture.shared.courseList[i].startTime &&
                            lectureList[j].startTime < Lecture.shared.courseList[j].endTime  {
                            
                            alert(title: "경고", message: "강의 시간이 겹칩니다.")
                            
                            return
                        }
                    }
                }
            }
        }
        
        
        delegate?.sendData(data: lectureList)
        
        
        alert(title: "알림", message: "저장되었습니다.") { action in
            self.dismiss(animated: true, completion: nil)
        }
    }
}





extension AddLectureTableViewController: UITextFieldDelegate {
    
    /// 지정된 텍스트를 변경할 것인지 delegate에게 묻는 메소드입니다.
    ///
    /// 강의명의 글자 수 입력을 20자로 제한합니다.
    ///
    /// - Parameters:
    ///   - textField: 텍스트를 포함하고 있는 TextField.
    ///   - range: 지정된 문자 범위입니다.
    ///   - string: 지정된 범위에 대한 대체 문자열입니다. 
    /// - Returns: Bool
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        
        let newLength = text.count + string.count - range.length

        return newLength <= 20
    }
    
    
    /// Return 버튼을 눌렀을 때의 process에 대해 delegate에게 묻는 메소드입니다.
    /// - Parameter textField: Return 버튼이 눌려진 TextField.
    /// - Returns: TextField가 return 버튼에 대한 동작을 구현해야하는 경우 true이고, 그렇지 않으면 false입니다.
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
