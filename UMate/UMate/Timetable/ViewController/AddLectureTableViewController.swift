//
//  AddLectureTableViewController.swift
//  UMate
//
//  Created by 안상희 on 2021/07/21.
//

import Elliotable
import Moya
import RxSwift


/// TimeTable 탭의 메인 화면 ViewController 클래스
///
/// 사용자가 직접 강의 정보를 입력하여 강의를 추가할 수 있는 화면입니다.
/// - Author: 안상희
class AddLectureTableViewController: UITableViewController {
    // MARK: - Property
    /// 시간표 Delegate
    var timeTableDelegate: SendTimeTableDataDelegate?
    
    /// 강의 시작 시간을 저장하는 속성
    var startTime: String = "09:00"
    
    /// 강의 마침 시간을 저장하는 속성
    var endTime: String = "09:00"
    
    /// 요일을 저장하기 위한 정수값
    ///
    /// 1: 월요일, 2: 화요일, 3: 수요일, 4: 목요일, 5: 금요일
    var weekdayInt = 1
    
    /// 5개의 요일 중 선택된 요일을 나타내기 위한 리스트
    ///
    /// 선택된 요일은 true, 선택되지 않은 요일은 false입니다.
    var weekdayList = [Bool](repeating: false, count: 5)
    
    /// 시간표 강의 색상을 지정해주기 위한 속성
    ///
    /// 초기값은 lightRed입니다.
    var colorString = "lightRed"
    
    /// 시간표 강의 글자 색상을 지정해주기 위한 속성
    ///
    /// 초기값은 black입니다.
    var textColorString = "black"
    
    /// 요일 정보가 있는지 확인하기 위한 속성
    ///
    /// 요일 정보가 있다면 true, 없다면 false입니다.
    var isWeekdayInfoEntered = false
    
    /// 색상 선택 (버튼) 이미지 속성
    ///
    /// 색상이 선택되면 (버튼이 선택되면) check 표시로 바뀝니다.
    let timeTableColorButtonImage = UIImage(named: "check")
    
    
    // MARK: - Outlet
    /// 강의 ID를 입력하기 위한 TextField
    @IBOutlet weak var courseIdField: UITextField!
    
    /// 강의명을 입력하기 위한 TextField
    @IBOutlet weak var courseNameField: UITextField!
    
    /// 강의실을 입력하기 위한 TextField
    @IBOutlet weak var roomNameField: UITextField!
    
    /// 교수님 성함을 입력하기 위한 TextField
    @IBOutlet weak var professorField: UITextField!
    
    
    /// 월요일을 나타내는 UIView
    @IBOutlet weak var mondayContainerView: UIView!
    
    /// 화요일을 나타내는 UIView
    @IBOutlet weak var tuesdayContainerView: UIView!
    
    /// 수요일을 나타내는 UIView
    @IBOutlet weak var wednesdayContainerView: UIView!
    
    /// 목요일을 나타내는 UIView
    @IBOutlet weak var thursdayContainerView: UIView!
    
    /// 금요일을 나타내는 UIView
    @IBOutlet weak var fridayContainerView: UIView!
    

    /// 월요일을 나타내는 UILabel
    @IBOutlet weak var mondayLabel: UILabel!
    
    /// 화요일을 나타내는 UILabel
    @IBOutlet weak var tuesdayLabel: UILabel!
    
    /// 수요일을 나타내는 UILabel
    @IBOutlet weak var wednesdayLabel: UILabel!
    
    /// 목요일을 나타내는 UILabel
    @IBOutlet weak var thursdayLabel: UILabel!
    
    /// 금요일을 나타내는 UILabel
    @IBOutlet weak var fridayLabel: UILabel!
    
    
    /// lightRed를 나타내는 UIView
    @IBOutlet weak var lightRedView: UIView!
    
    /// red를 나타내는 UIView
    @IBOutlet weak var redView: UIView!
    
    /// pink를 나타내는 UIView
    @IBOutlet weak var pinkView: UIView!
    
    /// orange를 나타내는 UIView
    @IBOutlet weak var orangeView: UIView!
    
    /// yellow를 나타내는 UIView
    @IBOutlet weak var yellowView: UIView!
    
    /// lightGreen을 나타내는 UIView
    @IBOutlet weak var lightGreenView: UIView!
    
    /// green을 나타내는 UIView
    @IBOutlet weak var greenView: UIView!
    
    /// skyblue를 나타내는 UIView
    @IBOutlet weak var skyblueView: UIView!
    
    /// blue를 나타내는 UIView
    @IBOutlet weak var blueView: UIView!
    
    /// lightPurple를 나타내는 UIView
    @IBOutlet weak var lightPurpleView: UIView!
    
    /// purple를 나타내는 UIView
    @IBOutlet weak var purpleView: UIView!
    
    /// darkGray를 나타내는 UIView
    @IBOutlet weak var darkGrayView: UIView!
    
    
    /// lightRed 색상을 선택하기 위한 UIButton
    @IBOutlet weak var lightRedButton: UIButton!
    
    /// red 색상을 선택하기 위한 UIButton
    @IBOutlet weak var redButton: UIButton!
    
    /// pink 색상을 선택하기 위한 UIButton
    @IBOutlet weak var pinkButton: UIButton!
    
    /// orange 색상을 선택하기 위한 UIButton
    @IBOutlet weak var orangeButton: UIButton!
    
    /// yellow 색상을 선택하기 위한 UIButton
    @IBOutlet weak var yellowButton: UIButton!
    
    /// lightGreen 색상을 선택하기 위한 UIButton
    @IBOutlet weak var lightGreenButton: UIButton!
    
    /// green 색상을 선택하기 위한 UIButton
    @IBOutlet weak var greenButton: UIButton!
    
    /// skyblue 색상을 선택하기 위한 UIButton
    @IBOutlet weak var skyblueButton: UIButton!
    
    /// blue 색상을 선택하기 위한 UIButton
    @IBOutlet weak var blueButton: UIButton!
    
    /// lightPurple 색상을 선택하기 위한 UIButton
    @IBOutlet weak var lightPurpleButton: UIButton!
    
    /// purple 색상을 선택하기 위한 UIButton
    @IBOutlet weak var purpleButton: UIButton!
    
    /// darkGray 색상을 선택하기 위한 UIButton
    @IBOutlet weak var darkGrayButton: UIButton!
    
    
    
    
    
    // MARK: - Action
    /// 요일 정보를 선택합니다.
    ///
    /// 선택된 요일 값을 저장하고 View의 상태를 변경합니다.
    /// - Parameter sender: 선택된 버튼
    @IBAction func selectDay(_ sender: UIButton) {
        initializeWeekday()
        
        switch sender.tag {
        case 101:
            if mondayContainerView.backgroundColor == .clear {
                selectWeekday(view: mondayContainerView, label: mondayLabel)
                weekdayInt = 1
                weekdayList[0] = true
                break
            }
            
            unselectWeekday(view: mondayContainerView, label: mondayLabel)
            weekdayList[0] = false
        case 102:
            if tuesdayContainerView.backgroundColor == .clear {
                selectWeekday(view: tuesdayContainerView, label: tuesdayLabel)
                weekdayInt = 2
                weekdayList[1] = true
                break
            }
            
            unselectWeekday(view: tuesdayContainerView, label: tuesdayLabel)
            weekdayList[1] = false
        case 103:
            if wednesdayContainerView.backgroundColor == .clear {
                selectWeekday(view: wednesdayContainerView, label: wednesdayLabel)
                weekdayInt = 3
                weekdayList[2] = true
                break
            }
            
            unselectWeekday(view: wednesdayContainerView, label: wednesdayLabel)
            weekdayList[2] = false
        case 104:
            if thursdayContainerView.backgroundColor == .clear {
                selectWeekday(view: thursdayContainerView, label: thursdayLabel)
                weekdayInt = 4
                weekdayList[3] = true
                break
            }
            
            unselectWeekday(view: thursdayContainerView, label: thursdayLabel)
            weekdayList[3] = false
        case 105:
            if fridayContainerView.backgroundColor == .clear {
                selectWeekday(view: fridayContainerView, label: fridayLabel)
                weekdayInt = 5
                weekdayList[4] = true
                break
            }
            
            unselectWeekday(view: fridayContainerView, label: fridayLabel)
            weekdayList[4] = false
        default:
            break
        }
    }
    
    
    /// 시간표 색상을 선택합니다.
    /// - Parameter sender: 선택된 버튼 (색상)
    @IBAction func selectColor(_ sender: UIButton) {
        // 먼저 시간표 색상 선택을 초기화합니다.
        initializeColor()
        
        // 선택된 색상 (버튼)에 체크 표시를 하고, 시간표 색상 값을 저장합니다.
        selectColor(sender: sender)
        
        
        // 선택된 버튼 (색상)에 따라 텍스트 색상을 변경합니다.
        switch sender.tag {
        // case 200, 201, 206, 208, 210, 211의 경우는 textColor을 흰색으로 설정합니다.
        case 200, 201, 206, 208, 210, 211:
            textColorString = "white"

        // 그 외의 경우는 모두 textColor을 검은색으로 설정합니다.
        default:
            textColorString = "black"
        }
    }
    
    
    /// 시간표 추가 화면에서 강의 시작 시간이 선택되면 호출됩니다.
    /// - Parameter sender: 강의 시작 시간을 선택하는 picker
    @IBAction func startTimeDidSelected(_ sender: UIDatePicker) {
        startTime = sender.date.timeTableTime
    }
    
    
    /// 시간표 추가 화면에서 강의 종료 시간이 선택되면 호출됩니다.
    /// - Parameter sender: 강의 종료 시간을 선택하는 picker
    @IBAction func endTimeDidSelected(_ sender: UIDatePicker) {
        endTime = sender.date.timeTableTime
    }
    
    
    /// 취소 버튼을 누르면 경고창이 나오고, 사용자가 확인을 누르면 현재 화면이 dismiss 됩니다.
    /// - Parameter sender: 시간표 강의 입력 취소 버튼
    @IBAction func cancel(_ sender: Any) {
        alertVersion2(title: "경고", message: "정말 취소하시겠습니까?") { action in
        } handler2: { action in
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    
    /// 시간표에 데이터를 저장할 때 호출됩니다.
    /// - Parameter sender: 시간표에 입력할 강의 정보를 저장하는 버튼
    @IBAction func save(_ sender: Any) {
        // 시간표에 데이터 전달하기 위한 값.
        guard let courseId = courseIdField.text, courseId.count > 0,
                let courseName = courseNameField.text, courseName.count > 0,
                let roomName = roomNameField.text, roomName.count > 0,
                let professor = professorField.text, professor.count > 0 else {
            alert(title: "경고", message: "시간표 정보를 모두 입력해주세요.")
            return
        }
        
        var courseDay: String = ""
        
        // 시간표 강의 정보를 저장하는 리스트
        var lectureList: [ElliottEvent] = []
        
        // 시간표 데이터가 있는지 확인합니다.
        let timetableDataIsAvailable = checkTimeTableData()
        
        
        // 시간표 데이터가 있다면 데이터를 lectureList에 저장하고, 중복 체크를 한 후에 최종적으로 값을 전달합니다.
        if timetableDataIsAvailable {
            let backgroundColor: UIColor = UIColor(named: "\(colorString)") ?? .black

            let textColor: UIColor = UIColor(named: "\(textColorString)") ?? .white

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
                    
                    switch i + 1 {
                    case 1:
                        courseDay = "월"
                    case 2:
                        courseDay = "화"
                    case 3:
                        courseDay = "수"
                    case 4:
                        courseDay = "목"
                    default:
                        courseDay = "금"
                    }
                }
            }
            
            
            // 이미 강의 정보가 저장되어있을 경우 시간표 중복이므로 경고 메시지를 표시합니다.
            if !LectureManager.shared.lectureEventList.isEmpty {
                for i in 0..<LectureManager.shared.lectureEventList.count {
                    for j in 0..<lectureList.count {
                        if lectureList[j].courseDay == LectureManager.shared.lectureEventList[i].courseDay {
                            if LectureManager.shared.lectureEventList[i].startTime == lectureList[j].startTime ||
                                LectureManager.shared.lectureEventList[i].endTime == lectureList[j].endTime {
                                alert(title: "경고", message: "강의 시간이 겹칩니다.")
                                return
                            }

                            if lectureList[j].startTime >= LectureManager.shared.lectureEventList[i].startTime &&
                                lectureList[j].endTime <= LectureManager.shared.lectureEventList[i].endTime {
                                alert(title: "경고", message: "강의 시간이 겹칩니다.")
                                return
                            }

                            if lectureList[j].startTime > LectureManager.shared.lectureEventList[i].startTime &&
                                lectureList[j].startTime < LectureManager.shared.lectureEventList[i].endTime  {
                                alert(title: "경고", message: "강의 시간이 겹칩니다.")
                                return
                            }
                        }
                    }
                }
            }
            
            
            let timetablePostData = TimetablePostData(courseId: courseId,
                                                      courseName: courseName,
                                                      roomName: roomName,
                                                      professorName: professor,
                                                      courseDay: courseDay,
                                                      startTime: startTime,
                                                      endTime: endTime,
                                                      backgroundColor: colorString,
                                                      textColor: textColorString)
            
            TimetableDataManager.shared.provider.rx.request(.postTimetable(timetablePostData))
                .filterSuccessfulStatusCodes()
                .map(TimetablePostResponse.self)
                .subscribe(onSuccess: {
                    if $0.code == ResultCode.ok.rawValue {
#if DEBUG
                        print($0.message)
#endif
                        self.timeTableDelegate?.sendData(data: lectureList, timetableId: $0.timetableId)
                    } else {
#if DEBUG
                        print($0.message)
#endif
                    }
                })
                .disposed(by: rx.disposeBag)
            
            
            // 강의 정보가 저장되면 알림을 띄웁니다.
            alert(title: "알림", message: "저장되었습니다.") { action in
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    
    // MARK: - Method
    /// 요일 정보를 선택합니다.
    ///
    /// 요일 클릭 시, 선택 상태가 변경됩니다.
    /// - Parameters:
    ///   - view: 선택된 버튼에 해당하는 뷰
    ///   - label: 선택된 버튼에 해당하는 라벨
    func selectWeekday(view: UIView, label: UILabel) {
        view.backgroundColor = UIColor.systemGray
        label.textColor = UIColor.white
    }
    
    
    /// 요일 정보를 선택 해제합니다.
    ///
    /// 요일 선택을 해제할 때 호출되고, 뷰와 텍스트 색상이 기본값으로 변경됩니다.
    /// - Parameters:
    ///   - view: 선택 해제된 버튼에 해당하는 뷰
    ///   - label: 선택 해제된 버튼에 해당하는 라벨
    func unselectWeekday(view: UIView, label: UILabel) {
        view.backgroundColor = .clear
        label.textColor = UIColor.black
    }
    
    
    /// 모든 버튼의 상태를 초기화합니다.
    func initializeColor() {
        [lightRedButton, redButton, pinkButton, orangeButton, yellowButton,
         lightGreenButton, greenButton, skyblueButton, blueButton,
         lightPurpleButton, purpleButton, darkGrayButton].forEach {
            $0?.setImage(nil, for: .normal)
        }
    }
    
    
    /// 선택된 요일의 상태를 초기화합니다.
    func initializeWeekday() {
        // 요일 선택 View를 초기화합니다.
        [mondayContainerView, tuesdayContainerView, wednesdayContainerView,
         thursdayContainerView, fridayContainerView].forEach {
            $0?.layer.cornerRadius = ($0?.frame.width)! / 2
            $0?.backgroundColor = .clear
        }
        
        [mondayLabel, tuesdayLabel, wednesdayLabel, thursdayLabel, fridayLabel].forEach {
            $0?.textColor = UIColor.black
        }
        
        for i in 0..<weekdayList.count {
            weekdayList[i] = false
        }
    }
    
    
    /// 선택된 버튼에 체크 표시를 하고, 시간표 색상 값을 저장합니다.
    /// - Parameter sender: 선택된 버튼 (색상)
    func selectColor(sender: UIButton) {
        // 버튼 상태 변경
        sender.setImage(timeTableColorButtonImage, for: .normal)
        sender.tintColor = UIColor.black
        
        // 색상 이름 저장
        guard let colorName = sender.backgroundColor?.name else { return }
        colorString = colorName
    }
    
    
    /// textField의 길이를 체크합니다.
    /// - Parameters:
    ///   - textField: UITextField
    ///   - maxLength: 최대 글자 수
    func checkMaxLength(textField: UITextField!, maxLength: Int) {
        if (textField.text?.count ?? 0 > maxLength) {
            textField.deleteBackward()
        }
    }
    
    
    /// 시간표 정보가 제대로 입력되었는지 확인합니다.
    /// - Returns: true라면 입력이 모두 완료된 것이고, false라면 입력이 모두 완료되지 않은 것입니다.
    func checkTimeTableData() -> Bool {
        // 요일 정보가 있는지 확인하기 위한 반복문입니다.
        for i in 0...4 {
            if weekdayList[i] == true {
                isWeekdayInfoEntered = true
            }
        }
        
        
        // 요일 정보가 없다면 경고창을 표시합니다.
        if !isWeekdayInfoEntered {
            alert(title: "경고", message: "요일 정보를 입력해주세요.")
            return false
        }
        
        if startTime == endTime {
            alert(title: "경고", message: "강의 시작 시간과 종료 시간이 같습니다.")
            return false
        }
        
        if startTime > endTime {
            alert(title: "경고", message: "강의 시작 시간이 종료 시간보다 늦습니다.")
            return false
        }
        return true
    }
    
    
    /// 각 textField에 delegate를 설정하고, 요일 선택 및 시간표 선택 View를 초기화합니다. courseIdField를 FirstResponder로 지정합니다.
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 각 TextField에 delegate를 설정합니다.
        courseIdField.delegate = self
        courseNameField.delegate = self
        roomNameField.delegate = self
        professorField.delegate = self
        
        // 요일 선택 View를 초기화합니다.
        [mondayContainerView, tuesdayContainerView, wednesdayContainerView,
         thursdayContainerView, fridayContainerView].forEach {
            $0?.layer.cornerRadius = ($0?.frame.width)! / 2
            $0?.backgroundColor = .clear
        }
        
        // 시간표 선택 View를 초기화합니다.
        [lightRedView, redView, pinkView, orangeView, yellowView, lightGreenView,
         greenView, skyblueView, blueView, lightPurpleView, purpleView, darkGrayView,
         lightRedButton, redButton, pinkButton, orangeButton, yellowButton, lightGreenButton,
         greenButton, skyblueButton, blueButton, lightPurpleButton, purpleButton, darkGrayButton
        ].forEach {
            $0?.layer.cornerRadius = ($0?.frame.width)! / 2
        }
        
        // courseIdField가 FirstResponder가 되도록 설정합니다.
        self.courseIdField.becomeFirstResponder()
    }
}



// MARK: - Extension
extension AddLectureTableViewController: UITextFieldDelegate {
    /// 지정된 텍스트를 변경할 것인지 delegate에게 묻습니다.
    ///
    /// 강의명의 글자 수 입력을 20자로 제한합니다.
    ///
    /// - Parameters:
    ///   - textField: 텍스트를 포함하고 있는 TextField
    ///   - range: 지정된 문자 범위
    ///   - string: 지정된 범위에 대한 대체 문자열
    /// - Returns: 지정된 텍스트를 변경할 경우 true, 아니라면 false를 리턴합니다.
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        guard let text = textField.text else {
            return true
        }
        
        let newLength = text.count + string.count - range.length

        return newLength <= 5
    }
    
    
    /// Return 버튼을 눌렀을 때의 process에 대해 delegate에게 묻습니다.
    ///
    /// Return 버튼을 누르면 다음 textField로 이동합니다.
    /// - Parameter textField: Return 버튼이 눌려진 해당 TextField
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



// MARK: - Protocol
/// 추가한 시간표 데이터를 TimeTableViewController로 전달하는 프로토콜입니다.
protocol SendTimeTableDataDelegate {
    /// 시간표 데이터를 전달합니다.
    func sendData(data: [ElliottEvent], timetableId: Int)
}
