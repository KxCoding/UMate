//
//  LectureInfo.swift
//  LectureInfo
//
//  Created by 남정은 on 2021/08/20.
//

import Foundation



class LectureInfo {
    init(lectureTitle: String, professor: String, openingSemester: String, textbookName: String, bookLink: String, reviews: [LectureReview] = [], testInfoList: [TestInfo] = []) {
        
        self.lectureTitle = lectureTitle
        self.professor = professor
        self.openingSemester = openingSemester
        self.textbookName = textbookName
        self.bookLink = bookLink
        self.reviews = reviews
        self.testInfoList = testInfoList
    }
    
    let lectureTitle: String
    let professor: String
    let openingSemester: String
    let textbookName: String
    let bookLink: String
    
    var reviews: [LectureReview]
    var testInfoList: [TestInfo]
}


class LectureReview {
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



class TestInfo {
    init(semester: String, testType: String, testStrategy: String, questionTypes: [String], examples: [String]) {
        self.semester = semester
        self.testType = testType
        self.testStrategy = testStrategy
        self.questionTypes = questionTypes
        self.examples = examples
    }
    
    let semester: String
    let testType: String
    let testStrategy: String
    let questionTypes: [String]
    let examples:  [String]
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
