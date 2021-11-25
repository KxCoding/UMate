//
//  LectureReviewWriteTableViewController.swift
//  UMate
//
//  Created by Chris Kim on 2021/09/06.
//

import UIKit
import DropDown
import Loaf
import Moya
import RxSwift
import RxCocoa
import NSObject_Rx


/// 강의평가 작성 화면
/// - Author: 김정민(kimjm010@icloud.com)
class LectureReviewWriteTableViewController: UITableViewController {
    
    /// 네트워크 통신 관리 객체
    let provider = MoyaProvider<LectureReviewSaveService>()
    
    /// 관련 강의 정보 전달
    var lectureInfo: LectureInfoDetailResponse.LectrueInfo?
    
    /// 리뷰 저장을 위한 속성
    /// - Author: 김정민(kimjm010@icloud.com)
    var reviewAssignment: LectureReview.Assignment?
    var reviewGroupMeeting: LectureReview.GroupMeeting?
    var reviewEvaluation: LectureReview.Evaluation?
    var reviewAttendance: LectureReview.Attendance?
    var reviewTestNumber: LectureReview.TestNumber?
    var reviewRating: LectureReview.Rating?
    
    /// 과제버튼 아울렛
    /// - Author: 김정민(kimjm010@icloud.com)
    @IBOutlet weak var manyAssignmentBtn: RoundedButton!
    @IBOutlet weak var normalAssignmentBtn: RoundedButton!
    @IBOutlet weak var noneAssignmentBtn: RoundedButton!
    
    
    /// 과제 버튼 클릭에 대한 이벤트를 처리합니다.
    /// - Parameter sender: Assignment 버튼
    /// - Author: 김정민(kimjm010@icloud.com)
    @IBAction func selectAssignment(_ sender: UIButton) {
        manyAssignmentBtn.isSelected = sender.tag == 101
        normalAssignmentBtn.isSelected = sender.tag == 102
        noneAssignmentBtn.isSelected = sender.tag == 103
        
        // 과제 버튼을 눌렀을 때 버튼의 배경색상을 변경합니다.
        /// - Author: 김정민(kimjm010@icloud.com)
        [manyAssignmentBtn, normalAssignmentBtn, noneAssignmentBtn].forEach { button in
            guard let button = button else { return }
            
            button.backgroundColor = button.isSelected ? .systemRed : .systemGray5
        }
        
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
    
    /// 그룹미팅버튼 아울렛
    /// - Author: 김정민(kimjm010@icloud.com)
    @IBOutlet weak var manyGroupMeetingBtn: RoundedButton!
    @IBOutlet weak var normalGroupMeetingBtn: RoundedButton!
    @IBOutlet weak var noneGroupMeetingBtn: RoundedButton!
    
    
    /// 그룹미팅 버튼 클릭에 대한 이벤트를 처리합니다.
    /// - Parameter sender: Groupmetting 버튼
    /// - Author: 김정민(kimjm010@icloud.com)
    @IBAction func selectGroupMeeting(_ sender: UIButton) {
        manyGroupMeetingBtn.isSelected = sender.tag == 201
        normalGroupMeetingBtn.isSelected = sender.tag == 202
        noneGroupMeetingBtn.isSelected = sender.tag == 203
        
        // 그룹미팅 버튼을 눌렀을 때 버튼의 배경색상을 변경합니다.
        /// - Author: 김정민(kimjm010@icloud.com)
        [manyGroupMeetingBtn, normalGroupMeetingBtn, noneGroupMeetingBtn].forEach { button in
            guard let button = button else { return }
            
            button.backgroundColor = button.isSelected ? .systemRed : .systemGray5
        }
        
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
    
    
    /// 학점비율버튼 아울렛
    /// - Author: 김정민(kimjm010@icloud.com)
    @IBOutlet weak var generousEvaluationBtn: RoundedButton!
    @IBOutlet weak var normalEvaluationBtn: RoundedButton!
    @IBOutlet weak var tightEvaluationBtn: RoundedButton!
    @IBOutlet weak var hellEvaluationBtn: RoundedButton!
    
    
    /// 학점비율 버튼 클릭에 대한 이벤트를 처리합니다.
    /// - Parameter sender: Evaluation 버튼
    /// - Author: 김정민(kimjm010@icloud.com)
    @IBAction func selectEvaluation(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        
        generousEvaluationBtn.isSelected = sender.tag == 301
        normalEvaluationBtn.isSelected = sender.tag == 302
        tightEvaluationBtn.isSelected = sender.tag == 303
        hellEvaluationBtn.isSelected = sender.tag == 304
        
        // 학점비율 버튼을 눌렀을 때 버튼의 배경색상을 변경합니다.
        /// - Author: 김정민(kimjm010@icloud.com)
        [generousEvaluationBtn, normalEvaluationBtn, tightEvaluationBtn, hellEvaluationBtn].forEach { button in
            guard let button = button else { return }
            
            button.backgroundColor = button.isSelected ? .systemRed : .systemGray5
        }
        
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
    
    
    /// 출결버튼 아울렛
    /// - Author: 김정민(kimjm010@icloud.com)
    @IBOutlet weak var mixAttendanceBtn: RoundedButton!
    @IBOutlet weak var directAttendanceBtn: RoundedButton!
    @IBOutlet weak var seatAttendanceBtn: RoundedButton!
    @IBOutlet weak var electronincAttendanceBtn: RoundedButton!
    @IBOutlet weak var noneAttendanceBtn: RoundedButton!
    
    
    /// 출결버튼 클릭에 대한 이벤트를 처리합니다.
    /// - Parameter sender: Attendance 버튼
    /// - Author: 김정민(kimjm010@icloud.com)
    @IBAction func selectAttendance(_ sender: UIButton) {
        mixAttendanceBtn.isSelected = sender.tag == 401
        directAttendanceBtn.isSelected = sender.tag == 402
        seatAttendanceBtn.isSelected = sender.tag == 403
        electronincAttendanceBtn.isSelected = sender.tag == 404
        noneAttendanceBtn.isSelected = sender.tag == 405
        
        // 출결버튼을 눌렀을 때 버튼의 배경색상을 변경합니다.
        /// - Author: 김정민(kimjm010@icloud.com)
        [mixAttendanceBtn, directAttendanceBtn, seatAttendanceBtn, electronincAttendanceBtn, noneAttendanceBtn].forEach { button in
            guard let button = button else { return }
            
            button.backgroundColor = button.isSelected ? .systemRed : .systemGray5
        }
        
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
    
    
    /// 시험횟수 버튼 아울렛
    /// - Author: 김정민(kimjm010@icloud.com)
    @IBOutlet weak var fourTestNumberBtn: RoundedButton!
    @IBOutlet weak var threeTestNumberBtn: RoundedButton!
    @IBOutlet weak var twoTestNumberBtn: RoundedButton!
    @IBOutlet weak var oneTestNumberBtn: RoundedButton!
    @IBOutlet weak var noneTestNumberBtn: RoundedButton!
    
    
    /// 시험횟수 버튼 클릭에 대한 이벤트를 처리합니다.
    /// - Parameter sender: Testnumber 버튼
    /// - Author: 김정민(kimjm010@icloud.com)
    @IBAction func selectTestNumber(_ sender: UIButton) {
        fourTestNumberBtn.isSelected = sender.tag == 501
        threeTestNumberBtn.isSelected = sender.tag == 502
        twoTestNumberBtn.isSelected = sender.tag == 503
        oneTestNumberBtn.isSelected = sender.tag == 504
        noneTestNumberBtn.isSelected = sender.tag == 505
        
        // 시험 횟수 버튼을 눌렀을 때 버튼의 배경색상을 변경합니다.
        /// - Author: 김정민(kimjm010@icloud.com)
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
    
    /// 총점버튼 아울렛
    /// - Author: 김정민(kimjm010@icloud.com)
    @IBOutlet weak var oneRatingBtn: RoundedButton!
    @IBOutlet weak var twoRatingBtn: RoundedButton!
    @IBOutlet weak var threeRatingBtn: RoundedButton!
    @IBOutlet weak var fourRatingBtn: RoundedButton!
    @IBOutlet weak var fiveRatingBtn: RoundedButton!
    
    
    /// 총점버튼 클릭에 대한 이벤트를 처리합니다.
    /// - Parameter sender: Rating 버튼
    /// - Author: 김정민(kimjm010@icloud.com)
    @IBAction func selectRating(_ sender: UIButton) {
        oneRatingBtn.isSelected = sender.tag == 601
        twoRatingBtn.isSelected = sender.tag == 602
        threeRatingBtn.isSelected = sender.tag == 603
        fourRatingBtn.isSelected = sender.tag == 604
        fiveRatingBtn.isSelected = sender.tag == 605
        
        // 총점버튼을 눌렀을 때 버튼의 배경색상을 변경합니다.
        /// - Author: 김정민(kimjm010@icloud.com)
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

    /// 수강학기 선택 버튼
    /// - Author: 김정민(kimjm010@icloud.com)
    @IBOutlet weak var selectSemesterButton: UIButton!
    
    /// 수강학기 선택 뷰
    /// - Author: 김정민(kimjm010@icloud.com)
    @IBOutlet weak var selectSemesterView: UIView!
    
    /// 수강학기 선택을 위한 메뉴 속성
    /// 수강학기는 현재 연도로부터 5년이전까지 선택할 수 있습니다.
    /// - Author: 김정민(kimjm010@icloud.com)
    lazy var menu: DropDown? = {
        let menu = DropDown()
        if let semesters = lectureInfo?.semesters.components(separatedBy: "/") {
            menu.dataSource = semesters
        }
        menu.width = 150
        menu.backgroundColor = UIColor.init(named: "systemGray6BackgroundColor")
        menu.textColor = .label
        
        return menu
    }()
    
    
    /// 수강학기를 선택합니다.
    /// - Parameter sender: 수강학기 선택 버튼
    /// - Author: 김정민(kimjm010@icloud.com)
    @IBAction func selectSemester(_ sender: UIButton) {
        menu?.show()
        menu?.anchorView = sender
        guard let height = menu?.anchorView?.plainView.bounds.height else { return }
        menu?.bottomOffset = CGPoint(x: 0, y: height)
        menu?.width = 150
        menu?.backgroundColor = UIColor.init(named: "systemGray6BackgroundColor")
        menu?.textColor = .label
        menu?.selectionAction = { [weak self] (index: Int, item: String) in
            guard let _ = self else { return }
            self?.semesterLabel.text = item
        }
    }
    
    
    /// 강의평가 작성아울렛
    /// - Author: 김정민(kimjm010@icloud.com)
    @IBOutlet weak var reviewcontentTextView: UITextView!
    @IBOutlet weak var reviewPlaceholder: UILabel!
    @IBOutlet weak var semesterLabel: UILabel!
    @IBOutlet weak var reviewSaveButton: UIButton!
    
    
    /// 강의리뷰 저장 메소드입니다.
    /// - Parameter sender: 강의평가 저장 버튼
    /// - Author: 김정민(kimjm010@icloud.com)
    @IBAction func saveLectureReview(_ sender: Any) {
        
        guard let reviewAssignment = reviewAssignment else {
            Loaf("과제 비율을 체크해주세요 :)", state: .custom(.init(backgroundColor: .black)), sender: self).show()
            return
        }
        
        guard let reviewGroupMeeting = reviewGroupMeeting else {
            Loaf("조모임 비율을 체크해주세요 :)", state: .custom(.init(backgroundColor: .black)), sender: self).show()
            return
        }

        guard let reviewEvaluation = reviewEvaluation else {
            Loaf("학점 비율을 체크해주세요 :)", state: .custom(.init(backgroundColor: .black)), sender: self).show()
            return
        }
        
        guard let reviewAttendance = reviewAttendance else {
            Loaf("출결 방식을 체크해주세요 :)", state: .custom(.init(backgroundColor: .black)), sender: self).show()
            return
        }
        
        guard let reviewTest = reviewTestNumber else {
            Loaf("시험 횟수를 체크해주세요 :)", state: .custom(.init(backgroundColor: .black)), sender: self).show()
            return
        }
        
        guard let reviewRating = reviewRating else {
            Loaf("총점을 체크해주세요 :)", state: .custom(.init(backgroundColor: .black)), sender: self).show()
            return
        }
        
        guard let semester = menu?.selectedItem else {
            Loaf("수강학기를 체크해주세요 :)", state: .custom(.init(backgroundColor: .black)), sender: self).show()
            return
        }
        
        guard let reviewContent = reviewcontentTextView.text, reviewContent.count > 20 else {
            Loaf("조금 더 자세한 총평을 작성해주세요 :)", state: .custom(.init(backgroundColor: .black)), sender: self).show()
            return
        }
        
        // 작성 경고문
        alertVersion3(title: "강의평을 작성하시겠습니까?", message: "\n※ 등록 후에는 수정하거나 삭제할 수 없습니다.\n\n※ 허위/중복/성의없는 정보를 작성할 경우, 서비스 이용이 제한될 수 있습니다.") { _ in
            let dateStr = BoardDataManager.shared.postDateFormatter.string(from: Date())
            let newReview = LectureReviewPostData(lectureReviewId: 0, userId: LoginDataManager.shared.loginKeychain.get(AccountKeys.userId.rawValue) ?? "", lectureInfoId: self.lectureInfo?.lectureInfoId ?? 0, assignment: reviewAssignment.rawValue, groupMeeting: reviewGroupMeeting.rawValue, evaluation: reviewEvaluation.rawValue, attendance: reviewAttendance.rawValue, testNumber: reviewTestNumber.rawValue, rating: reviewRating.rawValue, semester: semester, content: reviewContent, createdAt: dateStr)
    
                guard let url = URL(string: "https://umateserverboard.azurewebsites.net/api/lectureReview") else { return }
       
                let body = try? BoardDataManager.shared.encoder.encode(newReview)
                
                self.sendSavingLectureReviewRequest(url: url, httpMethod: "POST", httpBody: body)
                self.dismiss(animated: true, completion: nil)
        }
    }
    
    
    /// 강의리뷰 작성화면을 닫습니다.
    /// - Author: 김정민(kimjm010@icloud.com)
    @IBAction func closeVC(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    /// 작성한 강의평을 서버에 저장합니다.
    /// - Parameter lectureReviewPostData: 강의평 정보 객체
    ///   - Author: 남정은(dlsl7080@gmail.com), 김정민(kimjm010@icloud.com)
    func sendLectureReviewDataToServer(lectureReviewPostData: LectureReviewPostData) {
        provider.rx.request(.saveLectureReviewData(lectureReviewPostData))
            .filterSuccessfulStatusCodes()
            .map(SaveLectureReviewResponseData.self)
            .subscribe { (result) in
                switch result {
                case .success(let response):
                    switch response.resultCode {
                    case ResultCode.ok.rawValue:
                        #if DEBUG
                        print("추가 성공")
                        #endif

                        let newReview = LectureReviewListResponse.LectureReview(lectureReviewId: response.lectureReview.lectureReviewId, userId: response.lectureReview.userId, lectureInfoId: response.lectureReview.lectureInfoId, assignment: response.lectureReview.assignment, groupMeeting: response.lectureReview.groupMeeting, evaluation: response.lectureReview.evaluation, attendance: response.lectureReview.attendance, testNumber: response.lectureReview.testNumber, rating: response.lectureReview.rating, semester: response.lectureReview.semester, content: response.lectureReview.content, createdAt: response.lectureReview.createdAt)

                        NotificationCenter.default.post(name: .newLectureReviewDidInput, object: nil, userInfo: ["review": newReview])
                        
                    case ResultCode.fail.rawValue:
                        #if DEBUG
                        print("이미 존재함")
                        #endif
                    default:
                        break
                    }
                case .failure(let error):
                    #if DEBUG
                    print(error.localizedDescription)
                    #endif
                }
            }
            .disposed(by: rx.disposeBag)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        reviewSaveButton.setToEnabledButtonTheme()
        selectSemesterView.layer.cornerRadius = 10
        reviewcontentTextView.layer.cornerRadius = 10
        reviewcontentTextView.delegate = self

    }
}



/// 강의총평 Placeholder 지정
///  - Author:  김정민(kimjm010@icloud.com)
extension LectureReviewWriteTableViewController: UITextViewDelegate {
    
    /// 강의 총평을 편집하는 경우 Placeholder를 숨기는 메소드
    /// - Parameter textField: 깅의총평 textView
    ///  - Author:  김정민(kimjm010@icloud.com)
    func textViewDidBeginEditing(_ textView: UITextView) {
        reviewPlaceholder.isHidden = true
    }
    
    
    /// 강의 총평 편집 후 글자수가 0보다 작거나 같은 경우 다시 Placeholder를 설정하는 메소드
    /// - Parameter textField: 강의총평 textView
    ///  - Author:  김정민(kimjm010@icloud.com)
    func textViewDidEndEditing(_ textView: UITextView) {
        guard let text = textView.text, text.count > 0 else {
            reviewPlaceholder.isHidden = false
            return
        }
        
        reviewPlaceholder.isHidden = false
    }
}




