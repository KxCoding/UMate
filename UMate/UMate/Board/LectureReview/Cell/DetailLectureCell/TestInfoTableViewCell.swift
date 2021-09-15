//
//  TestInfoTableViewCell.swift
//  TestInfoTableViewCell
//
//  Created by 남정은 on 2021/08/20.
//

import UIKit


/// 시험정보 공유 테이블 뷰 셀
/// - Author: 남정은
class TestInfoTableViewCell: UITableViewCell {
    // MARK: 시험정보
    ///시험종류를 나타내는 레이블
    @IBOutlet weak var kindOfTestLabel: UILabel!
    
    /// 수강학기를 나타내는 레이블
    @IBOutlet weak var semesterLabel: UILabel!
    
    /// 시험전략을 나타내는 레이블
    @IBOutlet weak var testStrategyLabel: UILabel!
    
    /// 문제유형을 나타내는 레이블
    @IBOutlet weak var questionType: UILabel!
    
    /// 문제예시들을 담는 스택뷰
    @IBOutlet weak var exaplesStackView: UIStackView!
    
    
    /// 셀 초기화
    /// - Parameters:
    ///   - lecture: 선택된 강의
    ///   - indexPath: 시험정보를 나타내는 셀 인덱스
    func configure(lecture: LectureInfo, indexPath: IndexPath) {
        let target = lecture.testInfoList[indexPath.row]
        kindOfTestLabel.text = target.testType
        semesterLabel.text = target.semester + " 수강자"
        testStrategyLabel.text = target.testStrategy
        questionType.text = target.questionTypes.map{ $0.trimmingCharacters(in: .whitespaces) }.joined(separator: ",")
        
        /// 문제예시
        exaplesStackView.removeFullyAllArrangedSubviews()
        for ex in target.examples {
            /// 문제 예시를 나타낼 레이블
            let exampleLabel = UILabel()
            exampleLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
            exampleLabel.numberOfLines = 0
            
            /// 글자길이에 따라 배경색 지정
            let mutable = NSMutableAttributedString(string: ex)
            mutable.addAttribute(.backgroundColor, value: UIColor.init(named: "systemGray6BackgroundColor") ?? .lightGray, range: NSRange(ex.startIndex..<ex.endIndex, in: ex))
            exampleLabel.attributedText = mutable
            
            exaplesStackView.addArrangedSubview(exampleLabel)
        }
    }
}



/// 스크롤되면서 cellForRowAt이 다시 호출될 때 스택뷰에 값이 중복되는 것을 방지하기위해 스택뷰에 저장된 값을 삭제하기위해 사용
/// - Author: 남정은
extension UIStackView {
    /// 파라미터로 받은 뷰의 하위뷰를 제거하고 상위뷰로부터의 연결을 끊음
    func removeFully(view: UIView) {
        removeArrangedSubview(view)
        view.removeFromSuperview()
    }
    
    /// 스택뷰의 하위뷰를 모두 삭제함
    func removeFullyAllArrangedSubviews() {
        arrangedSubviews.forEach { (view) in
            removeFully(view: view)
        }
    }
}
