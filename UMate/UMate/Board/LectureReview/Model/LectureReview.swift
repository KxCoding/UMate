//
//  LectureReview.swift
//  UMate
//
//  Created by 남정은 on 2021/09/16.
//

import Foundation


/// 강의평에 대한 모델 클래스
/// - Author: 남정은(dlsl7080@gmail.com)
class LectureReview {
    /// 과제 빈도
    enum Assignment: Int {
        case many
        case normal
        case none
    }
    
    /// 조모임 빈도
    enum GroupMeeting: Int {
        case many
        case normal
        case none
    }
    
    /// 평가 기준
    enum Evaluation: Int {
        case generous
        case normal
        case tight
        case hell
    }
    
    /// 출결 방법
    enum Attendance: Int {
        case mix
        case direct
        case seat
        case electronic
        case none
    }
    
    /// 시험 횟수
    enum TestNumber: Int {
        case four
        case three
        case two
        case one
        case none
    }
    
    /// 총평 점수
    enum Rating: Int {
        case one = 1
        case two = 2
        case three = 3
        case four = 4
        case five = 5
    }
    
    /// 과제 빈도
    let assignment: Assignment
    
    /// 조모임 빈도
    let groupMeeting: GroupMeeting
    
    /// 평가 기준
    let evaluation: Evaluation
    
    /// 출결 방법
    let attendance: Attendance
    
    /// 시험 횟수
    let testNumber: TestNumber
    
    /// 총평 점수
    let rating: Rating
    
    /// 수강학기
    let semester: String
    
    /// 강의평 내용
    let reviewContent: String
    
    
    init(assignment: LectureReview.Assignment, groupMeeting: LectureReview.GroupMeeting, evaluation: LectureReview.Evaluation, attendance: LectureReview.Attendance, testNumber: LectureReview.TestNumber, rating: LectureReview.Rating, semester: String, reviewContent: String) {
         self.assignment = assignment
         self.groupMeeting = groupMeeting
         self.evaluation = evaluation
         self.attendance = attendance
         self.testNumber = testNumber
         self.rating = rating
         self.semester = semester
         self.reviewContent = reviewContent
     }
}



/// 강의평가 항목을 스트링으로 나타내기 위해 사용
/// - Author: 남정은(dlsl7080@gmail.com)
extension LectureReview.Assignment: CustomStringConvertible {
    var description: String {
        switch self {
        case .many:
            return "많음"
        case .normal:
            return "보통"
        case .none:
            return "없음"
        }
    }
}



/// 강의평가 항목을 스트링으로 나타내기 위해 사용
/// - Author: 남정은(dlsl7080@gmail.com)
extension LectureReview.GroupMeeting: CustomStringConvertible {
    var description: String {
        switch self {
        case .many:
            return "많음"
        case .normal:
            return "보통"
        case .none:
            return "없음"
        }
    }
}



/// 강의평가 항목을 스트링으로 나타내기 위해 사용
/// - Author: 남정은(dlsl7080@gmail.com)
extension LectureReview.Evaluation: CustomStringConvertible {
    var description: String {
        switch self {
        case .generous:
            return "후함"
        case .normal:
            return "비율채워줌"
        case .tight:
            return "매우깐깐함"
        case .hell:
            return "F폭격기"
        }
    }
}



/// 강의평가 항목을 스트링으로 나타내기 위해 사용
/// - Author: 남정은(dlsl7080@gmail.com)
extension LectureReview.Attendance: CustomStringConvertible {
    var description: String {
        switch self {
        case .mix:
            return "혼용"
        case .direct:
            return "직접호명"
        case .seat:
            return "지정좌석"
        case .electronic:
            return "전자출결"
        case .none:
            return "반영안함"
        }
    }
}



/// 강의평가 항목을 스트링으로 나타내기 위해 사용
/// - Author: 남정은(dlsl7080@gmail.com)
extension LectureReview.TestNumber: CustomStringConvertible {
    var description: String {
        switch self {
        case .four:
            return "네번이상"
        case .three:
            return "세번"
        case .two:
            return "두번"
        case .one:
            return "한번"
        case .none:
            return "없음"
        }
    }
}



/// 강의평가 항목을 스트링으로 나타내기 위해 사용
/// - Author: 남정은(dlsl7080@gmail.com)
extension LectureReview.Rating: CustomStringConvertible {
    var description: String {
        switch self {
        case .one:
            return "1점"
        case .two:
            return "2점"
        case .three:
            return "3점"
        case .four:
            return "4점"
        case .five:
            return "5점"
        }
    }
}

