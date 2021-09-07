//
//  LectureReviewWriteTableViewController.swift
//  UMate
//
//  Created by Chris Kim on 2021/09/06.
//

import UIKit
import DropDown

extension Notification.Name {
    static let newLectureReviewDidInput = Notification.Name(rawValue: "newLectureReviewDidInput")
}

class LectureReviewWriteTableViewController: UITableViewController {

    // MARK: 리뷰를 저장하기 위한 속성
    var reviewAssignment: LectureReview.Assignment?
    var reviewGroupMeeting: LectureReview.GroupMeeting?
    var reviewEvaluation: LectureReview.Evaluation?
    var reviewAttendance: LectureReview.Attendance?
    var reviewTestNumber: LectureReview.TestNumber?
    var reviewRating: LectureReview.Rating?
    
    // MARK: 과제버튼 아울렛
    @IBOutlet weak var manyAssignmentBtn: RoundedButton!
    @IBOutlet weak var normalAssignmentBtn: RoundedButton!
    @IBOutlet weak var noneAssignmentBtn: RoundedButton!
    
    
    @IBAction func selectAssignment(_ sender: UIButton) {
        manyAssignmentBtn.isSelected = sender.tag == 101
        normalAssignmentBtn.isSelected = sender.tag == 102
        noneAssignmentBtn.isSelected = sender.tag == 103
        
        /// 총점버튼을 눌렀을 때 버튼의 배경색상 변경
        [manyAssignmentBtn, normalAssignmentBtn, noneAssignmentBtn].forEach { button in
            guard let button = button else { return }
            
            button.backgroundColor = button.isSelected ? .systemRed : .systemGray5
        }
        
        /// 해당 버튼에 대한 값을 속성에 저장
        switch sender.tag {
        case 101:
            reviewAssignment = LectureReview.Assignment.many
        case 102:
            reviewAssignment = LectureReview.Assignment.normal
        case 103:
            reviewAssignment = LectureReview.Assignment.none
        default:
            break
        }
    }
    
    // MARK: 그룹미팅버튼 아울렛
    @IBOutlet weak var manyGroupMeetingBtn: RoundedButton!
    @IBOutlet weak var normalGroupMeetingBtn: RoundedButton!
    @IBOutlet weak var noneGroupMeetingBtn: RoundedButton!
    
    
    @IBAction func selectGroupMeeting(_ sender: UIButton) {
        manyGroupMeetingBtn.isSelected = sender.tag == 201
        normalGroupMeetingBtn.isSelected = sender.tag == 202
        noneGroupMeetingBtn.isSelected = sender.tag == 203
        
        /// 총점버튼을 눌렀을 때 버튼의 배경색상 변경
        [manyGroupMeetingBtn, normalGroupMeetingBtn, noneGroupMeetingBtn].forEach { button in
            guard let button = button else { return }
            
            button.backgroundColor = button.isSelected ? .systemRed : .systemGray5
        }
        
        /// 해당 버튼에 대한 값을 속성에 저장
        switch sender.tag {
        case 201:
            reviewGroupMeeting = LectureReview.GroupMeeting.many
        case 202:
            reviewGroupMeeting = LectureReview.GroupMeeting.normal
        case 203:
            reviewGroupMeeting = LectureReview.GroupMeeting.none
        default:
            break
        }
    }
    
    
    // MARK: 학점비율버튼 아울렛
    @IBOutlet weak var generousEvaluationBtn: RoundedButton!
    @IBOutlet weak var normalEvaluationBtn: RoundedButton!
    @IBOutlet weak var tightEvaluationBtn: RoundedButton!
    @IBOutlet weak var hellEvaluationBtn: RoundedButton!
    
    
    @IBAction func selectEvaluation(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        
        generousEvaluationBtn.isSelected = sender.tag == 301
        normalEvaluationBtn.isSelected = sender.tag == 302
        tightEvaluationBtn.isSelected = sender.tag == 303
        hellEvaluationBtn.isSelected = sender.tag == 304
        
        /// 총점버튼을 눌렀을 때 버튼의 배경색상 변경
        [generousEvaluationBtn, normalEvaluationBtn, tightEvaluationBtn, hellEvaluationBtn].forEach { button in
            guard let button = button else { return }
            
            button.backgroundColor = button.isSelected ? .systemRed : .systemGray5
        }
        
        /// 해당 버튼에 대한 값을 속성에 저장
        switch sender.tag {
        case 301:
            reviewEvaluation = LectureReview.Evaluation.generous
        case 302:
            reviewEvaluation = LectureReview.Evaluation.normal
        case 303:
            reviewEvaluation = LectureReview.Evaluation.tight
        case 304:
            reviewEvaluation = LectureReview.Evaluation.hell
        default:
            break
        }
    }
    
    
    // MARK: 출석버튼 아울렛
    @IBOutlet weak var mixAttendanceBtn: RoundedButton!
    @IBOutlet weak var directAttendanceBtn: RoundedButton!
    @IBOutlet weak var seatAttendanceBtn: RoundedButton!
    @IBOutlet weak var electronincAttendanceBtn: RoundedButton!
    @IBOutlet weak var noneAttendanceBtn: RoundedButton!
    
    
    @IBAction func selectAttendance(_ sender: UIButton) {
        mixAttendanceBtn.isSelected = sender.tag == 401
        directAttendanceBtn.isSelected = sender.tag == 402
        seatAttendanceBtn.isSelected = sender.tag == 403
        electronincAttendanceBtn.isSelected = sender.tag == 404
        noneAttendanceBtn.isSelected = sender.tag == 405
        
        /// 총점버튼을 눌렀을 때 버튼의 배경색상 변경
        [mixAttendanceBtn, directAttendanceBtn, seatAttendanceBtn, electronincAttendanceBtn, noneAttendanceBtn].forEach { button in
            guard let button = button else { return }
            
            button.backgroundColor = button.isSelected ? .systemRed : .systemGray5
        }
        
        /// 해당 버튼에 대한 값을 속성에 저장
        switch sender.tag {
        case 401:
            reviewAttendance = LectureReview.Attendance.mix
        case 402:
            reviewAttendance = LectureReview.Attendance.direct
        case 403:
            reviewAttendance = LectureReview.Attendance.seat
        case 404:
            reviewAttendance = LectureReview.Attendance.electronic
        case 405:
            reviewAttendance = LectureReview.Attendance.none
        default: break
        }
    }
    
    
    // MARK: 시험횟수버튼 아울렛
    @IBOutlet weak var fourTestNumberBtn: RoundedButton!
    @IBOutlet weak var threeTestNumberBtn: RoundedButton!
    @IBOutlet weak var twoTestNumberBtn: RoundedButton!
    @IBOutlet weak var oneTestNumberBtn: RoundedButton!
    @IBOutlet weak var noneTestNumberBtn: RoundedButton!
    
    
    @IBAction func selectTestNumber(_ sender: UIButton) {
        fourTestNumberBtn.isSelected = sender.tag == 501
        threeTestNumberBtn.isSelected = sender.tag == 502
        twoTestNumberBtn.isSelected = sender.tag == 503
        oneTestNumberBtn.isSelected = sender.tag == 504
        noneTestNumberBtn.isSelected = sender.tag == 505
        
        /// 총점버튼을 눌렀을 때 버튼의 배경색상 변경
        [fourTestNumberBtn, threeTestNumberBtn, twoTestNumberBtn, oneTestNumberBtn, noneTestNumberBtn].forEach { button in
            guard let button = button else { return }
            
            button.backgroundColor = button.isSelected ? .systemRed : .systemGray5
        }
        
        /// 해당 버튼에 대한 값을 속성에 저장
        switch sender.tag {
        case 501:
            reviewTestNumber = LectureReview.TestNumber.four
        case 502:
            reviewTestNumber = LectureReview.TestNumber.three
        case 503:
            reviewTestNumber = LectureReview.TestNumber.two
        case 504:
            reviewTestNumber = LectureReview.TestNumber.one
        case 505:
            reviewTestNumber = LectureReview.TestNumber.none
        default:
            break
        }
    }
    
    // MARK: 총점버튼 아울렛
    @IBOutlet weak var oneRatingBtn: RoundedButton!
    @IBOutlet weak var twoRatingBtn: RoundedButton!
    @IBOutlet weak var threeRatingBtn: RoundedButton!
    @IBOutlet weak var fourRatingBtn: RoundedButton!
    @IBOutlet weak var fiveRatingBtn: RoundedButton!
    
    
    /// 총점버튼을 눌렀을 때 버튼의 배경색상 변경
    @IBAction func selectRating(_ sender: UIButton) {
        oneRatingBtn.isSelected = sender.tag == 601
        twoRatingBtn.isSelected = sender.tag == 602
        threeRatingBtn.isSelected = sender.tag == 603
        fourRatingBtn.isSelected = sender.tag == 604
        fiveRatingBtn.isSelected = sender.tag == 605
        
        [oneRatingBtn, twoRatingBtn, threeRatingBtn, fourRatingBtn, fiveRatingBtn].forEach { button in
            guard let button = button else { return }
            
            button.backgroundColor = button.isSelected ? .systemRed : .systemGray5
        }
        
        /// 해당 버튼에 대한 값을 속성에 저장
        switch sender.tag {
        case 601:
            reviewRating = LectureReview.Rating.one
        case 602:
            reviewRating = LectureReview.Rating.two
        case 603:
            reviewRating = LectureReview.Rating.three
        case 604:
            reviewRating = LectureReview.Rating.four
        case 605:
            reviewRating = LectureReview.Rating.five
        default:
            break
        }
    }
    
    /// 수강학기 선택을 위한 메뉴 속성
    let menu: DropDown? = {
        let menu = DropDown()
        let now = Date()
        let currnetYear = Calendar.current.dateComponents([.year], from: now)
        guard let currentYear = currnetYear.year else { return menu }
        
        let startYear = (currentYear) - 5
        
        for year in startYear ... currentYear {
            for sem in 1...2 {
                menu.dataSource.append("\(year)학년 \(sem)학기")
            }
        }
        
        return menu
    }()
    
    
    /// 수강학기 선택 메소드
    /// - Parameter sender: 수강학기 선택 버튼
    @IBAction func selectSemester(_ sender: UIButton) {
        menu?.show()
        menu?.anchorView = sender
        menu?.bottomOffset = CGPoint(x: 0, y: sender.frame.size.height)
        menu?.selectionAction = { [weak self] (index: Int, item: String) in
            guard let _ = self else { return }
            self?.semesterLabel.text = item
        }
    }
    
    
    // MARK: 강의평가 작성아울렛
    @IBOutlet weak var reviewcontentTextView: UITextView!
    @IBOutlet weak var reviewPlaceholder: UILabel!
    @IBOutlet weak var semesterLabel: UILabel!
    @IBOutlet weak var reviewSaveButton: UIButton!
    
    
    
    /// 강의리뷰 저장 메소드
    @IBAction func saveLectureReview(_ sender: Any) {
        
        guard let reviewContent = reviewcontentTextView.text, reviewContent.count > 0 else {
            alert(message: "총평을 작성해주세요.")
            return
        }
        
        // TODO: 강제추출 -> optionalBinding으로 바꿀것!
        // TODO: 알림 메소드로 비어있는 항목있는 경우 저장 불가 구현!
        
        let newReview = LectureReview(assignment: reviewAssignment!, groupMeeting: reviewGroupMeeting!, evaluation: reviewEvaluation!, attendance: reviewAttendance!, testNumber: reviewTestNumber!, rating: reviewRating!, semester: semesterLabel.text!, reviewContent: reviewContent)
        
        NotificationCenter.default.post(name: .newLectureReviewDidInput, object: nil, userInfo: ["review": newReview])
        
        dismiss(animated: true, completion: nil)
        
        #if DEBUG
        print(#function, "강의리뷰 저장완료!", reviewContent)
        #endif
    }
    
    
    /// 강의리뷰 작성화면을 닫는 메소드
    @IBAction func closeVC(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        reviewSaveButton.setButtonTheme()
        reviewcontentTextView.delegate = self
    }
}




extension LectureReviewWriteTableViewController: UITextViewDelegate {
    
    /// 리뷰를 작성할 경우 placeholder를 가리는 메소드
    func textViewDidChange(_ textView: UITextView) {
        reviewPlaceholder.isHidden = textView.hasText
    }
}
