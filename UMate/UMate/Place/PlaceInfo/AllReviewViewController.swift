//
//  AllReviewViewController.swift
//  UMate
//
//  Created by Hyunwoo Jang on 2021/09/17.
//

import UIKit


/// 모든 리뷰를 표시하는 화면과 관련된 뷰컨트롤러 클래스
/// - Author: 장현우(heoun3089@gmail.com)
class AllReviewViewController: UIViewController {
    /// 이전 화면에서 가게 이름을 받아올 변수
    /// - Author: 장현우(heoun3089@gmail.com)
    var placeName: String?
    
    
    /// 뷰가 나타나기 전에 호출됩니다.
    /// - Parameter animated: 애니메이션 사용 여부
    /// - Author: 장현우(heoun3089@gmail.com)
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // 이전 화면에서 가게 이름 정보를 받아왔다면 네비게이션 타이틀에 표시
        if let placeName = placeName {
            self.navigationController?.navigationBar.topItem?.title = ""
            self.navigationItem.title = "\(placeName)의 리뷰"
        }
    }
}



extension AllReviewViewController: UITableViewDataSource {
    /// 데이터 소스 객체에게 지정된 섹션에 있는 행의 수를 물어봅니다.
    /// - Parameters:
    ///   - tableView: 이 메소드를 호출하는 테이블뷰
    ///   - section: 테이블뷰 섹션을 식별하는 Index 번호
    /// - Returns: 섹션에 있는 행의 수
    /// - Author: 장현우(heoun3089@gmail.com)
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return PlaceReviewItem.dummyData.count
    }
    
    
    /// 데이터소스 객체에게 지정된 위치에 해당하는 셀에 데이터를 요청합니다.
    /// - Parameters:
    ///   - tableView: 이 메소드를 호출하는 테이블뷰
    ///   - indexPath: 행의 위치를 나타내는 IndexPath
    /// - Returns: 설정한 셀
    /// - Author: 장현우(heoun3089@gmail.com)
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserReviewTableViewCell", for: indexPath) as! UserReviewTableViewCell
        
        cell.reviewTextLabel.text = PlaceReviewItem.dummyData[indexPath.row].reviewText
        cell.dateLabel.text = PlaceReviewItem.dummyData[indexPath.row].date
        cell.recommendationCountLabel.text = "\(PlaceReviewItem.dummyData[indexPath.row].recommendationCount)"
        
        return cell
    }
}
