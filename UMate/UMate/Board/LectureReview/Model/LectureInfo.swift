//
//  LectureInfo.swift
//  LectureInfo
//
//  Created by 남정은 on 2021/08/20.
//

import Foundation



struct LectureInfo {
    init(assortment: String, lectureNumber: String, credit: String, lectureTitle: String, professor: String, lectureTime: String, lectureRoom: String, reviews: [LectureReview] = []) {
        self.assortment = assortment
        self.lectureNumber = lectureNumber
        self.credit = credit
        self.lectureTitle = lectureTitle
        self.professor = professor
        self.lectureTime = lectureTime
        self.lectureRoom = lectureRoom
        self.reviews = reviews
    }
    
    let assortment: String
    let lectureNumber: String
    let credit: String
    let lectureTitle: String
    let professor: String
    let lectureTime: String
    let lectureRoom: String
    
    
    let reviews: [LectureReview]
}


struct LectureReview {
    
    enum Assignment: Int {
        case many
        case normal
        case none
    }
    
    let assignment: Assignment
    
    enum GroupMeeting: Int {
        case many
        case normal
        case none
    }
    
    let groupMeeting: GroupMeeting
    
    enum Evaluation: Int {
        case generous
        case normal
        case tight
        case hell
    }
    
    let evaluation: Evaluation
    
    enum Attendance: Int {
        case mix
        case direct
        case seat
        case electronic
        case none
    }
    
    let attendance: Attendance
    
    enum TestNumber: Int {
        case four
        case three
        case two
        case one
        case none
    }
    
    let testNumber: TestNumber
    
    enum Rating: Int {
        case one = 1
        case two = 2
        case three = 3
        case four = 4
        case five = 5
    }
    
    let rating: Rating
    
    
    let semester: String
    let reviewContent: String
}


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
