//
//  PlaceViewController.swift
//  UMate
//
//  Created by 안상희 on 2021/07/12.
//

import UIKit

// 탭 선택될 때 post할 notification 등록
extension Notification.Name {
    static let tapToggleDidRequest = Notification.Name(rawValue: "tapToggleDidRequest")
}

class PlaceInfoViewController: UIViewController {
    
    // 상세 페이지 하위 탭
    enum SubTab {
        case detail
        case review
    }
    
    // 선택된 탭 저장
    var selectedTap: SubTab = .detail
    
    // 가게 더미 데이터
    var place = Place(name: "데일리루틴",
                      university: "숙명여대",
                      district: "숙대입구역 인근",
                      type: .cafe,
                      keywords: ["레트로", "사진 찍기 좋은", "새로 오픈한", "친절", "따뜻한", "커피 맛집", "목재 가구"],
                      instagramID: "dailyroutinecoffee",
                      url: "http://naver.me/xrPcV2Ie")
    
    // 리뷰 요약 데이터
    var review = PlaceReviewItem(starPoint: 4.8,
                                 taste: .clean,
                                 service: .kind,
                                 mood: .emotional,
                                 price: .affordable,
                                 amount: .suitable)
    
    // 리뷰 데이터
    var reviews = [
        UserReview(reviewText: "분위기 너무 좋아요", date: "2021.06.01"),
        UserReview(reviewText: "커피 맛이 좋아요", date: "2021.05.28"),
        UserReview(reviewText: "커피는 데일리루틴 나만 알고싶은집", date: "2021.05.23")
    ]
    
    
    
    @IBOutlet weak var placeInfoTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(type(of: self), #function)
        
        placeInfoTableView.dataSource = self
    }
    
    @IBAction func selectTap(_ sender: UIButton) {
        switch sender.tag {
        case 100:
            print("select detail tap")
            
            // 선택된 탭 저장
            selectedTap = .detail
            
            // 선택된 탭에 대한 정보를 함께 전달
            NotificationCenter.default.post(name: .tapToggleDidRequest, object: nil, userInfo: ["selectedTap": selectedTap])
            
            // 테이블 뷰 리로드 -> 테이블 뷰가 알맞은 셀 표시
            placeInfoTableView.reloadData()
        case 101:
            print("select review tap")
            selectedTap = .review
            NotificationCenter.default.post(name: .tapToggleDidRequest, object: nil, userInfo: ["selectedTap": selectedTap])
            
            placeInfoTableView.reloadData()
        default:
            break
        }
    }
    
}

extension PlaceInfoViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 4:
            if selectedTap == .review { return reviews.count }
            else { return 0 }
        default:
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
            
        case 0:
            return tableView.dequeueReusableCell(withIdentifier: "FirstSectionTableViewCell", for: indexPath)
            
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "InfoSectionTableViewCell", for: indexPath) as! InfoSectionTableViewCell
            
            cell.configure(with: place)
            
            return cell
            
        case 2:
            return tableView.dequeueReusableCell(withIdentifier: "TabSectionTableViewCell", for: indexPath)
            
        case 3:
            switch selectedTap {
            case .detail:
                let cell = tableView.dequeueReusableCell(withIdentifier: "DetailTableViewCell", for: indexPath) as! DetailTableViewCell
                
                cell.configure(with: place, indexPath: indexPath)
                
                return cell

            case .review:
                let cell = tableView.dequeueReusableCell(withIdentifier: "GeneralReviewTableViewCell", for: indexPath) as! GeneralReviewTableViewCell
                
                cell.configure(with: review)
                
                return cell
            }
            
        case 4:
            let cell = tableView.dequeueReusableCell(withIdentifier: "UserReviewTableViewCell", for: indexPath) as! UserReviewTableViewCell
            
            cell.reviewTextLabel.text = reviews[indexPath.row].reviewText
            cell.dateLabel.text = reviews[indexPath.row].date
            
            return cell
            
        default:
            fatalError()
            
        }
    }
    
    
}
