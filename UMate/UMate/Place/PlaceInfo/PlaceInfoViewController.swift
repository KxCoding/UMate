//
//  PlaceViewController.swift
//  UMate
//
//  Created by 안상희 on 2021/07/12.
//

import UIKit


/// Notification Name Extension
extension Notification.Name {
    /// 하위 탭을 선택할 때 post할 notification
    /// - Author: 박혜정(mailmelater11@gmail.com)
    static let tapToggleDidRequest = Notification.Name(rawValue: "tapToggleDidRequest")
}



/// 가게 상세 정보 화면 VC 클래스
/// - Author: 박혜정(mailmelater11@gmail.com), 장현우(heoun3089@gmail.com)
class PlaceInfoViewController: UIViewController {
    
    // MARK: Nested Types
    
    /// 상세 페이지 하위 탭
    /// - Author: 박혜정(mailmelater11@gmail.com)
    enum SubTab {
        case detail
        case review
    }
    
    
    
    // MARK: Outlets
    
    /// 전체 데이터를 표시하는 테이블 뷰
    /// - Author: 박혜정(mailmelater11@gmail.com)
    @IBOutlet weak var placeInfoTableView: UITableView!
    
    
    // MARK: Properties
    
    /// 상세 정보를 표시할 가게
    /// - Author: 박혜정(mailmelater11@gmail.com)
    var place: Place!
    
    /// 리뷰 요약 데이터
    /// - Author: 장현우(heoun3089@gmail.com)
    var review = PlaceReviewItem(reviewText: "분위기 너무 좋아요",
                                 date: Date(),
                                 image: UIImage(named: "search_00"),
                                 placeName: "오오비",
                                 starPoint: 4.5,
                                 taste: .clean,
                                 service: .kind,
                                 mood: .clear,
                                 price: .cheap,
                                 amount: .suitable,
                                 totalPoint: .fivePoint,
                                 recommendationCount: 5)
    
    /// 선택된 하위 탭을 저장하는 속성
    ///
    /// 화면 진입 시 정보 탭이 선택되어 있습니다.
    /// - Author: 박혜정(mailmelater11@gmail.com)
    var selectedTap: SubTab = .detail
    
    /// 소멸 시점에 제거할 옵저버 객체를 담는 배열
    var tokens = [NSObjectProtocol]()
    
    
    // MARK: Actions
    
    /// 선택된 탭에 알맞은 내용으로 contents를 업데이트 합니다.
    /// - Parameter sender: 탭 버튼
    /// - Author: 박혜정(mailmelater11@gmail.com)
    @IBAction func selectTap(_ sender: UIButton) {
        switch sender.tag {
        
        // 정보 탭 선택
        case 100:
            // 선택된 탭 저장
            selectedTap = .detail
            
            // 선택된 탭에 대한 정보를 함께 전달
            NotificationCenter.default.post(name: .tapToggleDidRequest, object: nil, userInfo: ["selectedTap": selectedTap])
            
            
            // 테이블 뷰 리로드 -> 테이블 뷰가 알맞은 셀 표시
            placeInfoTableView.reloadData()
            
        // 리뷰 탭 선택
        case 101:
            selectedTap = .review
            
            NotificationCenter.default.post(name: .tapToggleDidRequest, object: nil, userInfo: ["selectedTap": selectedTap])
            
            placeInfoTableView.reloadData()
            
        default:
            break
        }
    }
    
    
    // MARK: View Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // delegation
        placeInfoTableView.dataSource = self
        placeInfoTableView.delegate = self
        
        // add notification observer
        var token = NotificationCenter.default.addObserver(forName: .openUrl, object: nil, queue: .main) { [weak self] noti in
            guard let self = self else { return }
            
            // 함께 전송 된 url 타입과 url을 바인딩
            guard let urlType = noti.userInfo?["type"] as? URLType,
                  let url = noti.userInfo?["url"] as? URL else { return }
            
            //  타입에 따라 적절한 방식으로 url 열기
            switch urlType {
            case .web:
                self.openUrl(with: url)
            case .tel:
                self.openURLExternal(url: url)
            }
            
        }
        
        tokens.append(token)
        
        token = NotificationCenter.default.addObserver(forName: .reviewWillApplied, object: nil, queue: .main) { _ in
            self.placeInfoTableView.reloadData()
        }
        
        tokens.append(token)
    }
    
    
    /// 뷰가 나타나기 전에 호출됩니다.
    /// - Parameter animated: 애니메이션 사용 여부
    /// - Author: 장현우(heoun3089@gmail.com)
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationItem.title = "가게 정보"
    }
    
    
    /// 다음 화면으로 넘어가기 전에 호출됩니다.
    /// - Parameters:
    ///   - segue: 다음 화면 뷰컨트롤러에 대한 정보를 가지고 있는 segue 객체
    ///   - sender: segue를 연결한 객체
    /// - Author: 장현우(heoun3089@gmail.com)
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? ReviewWriteTableViewController {
            vc.placeName = place.name
        }
        
        if let vc = segue.destination as? AllReviewViewController {
            vc.placeName = place.name
        }
    }
    
    
    deinit {
        // 화면에서 사용된 옵저버 제거
        for token in tokens {
            NotificationCenter.default.removeObserver(token)
        }
    }
    
}



// MARK: - Tableview Delegation

extension PlaceInfoViewController: UITableViewDataSource {
    
    /// table view에서 표시할 section의 개수를 제공합니다.
    /// - Parameter tableView: 이 정보를 요청하는 table view
    /// - Returns: 섹션의 개수
    func numberOfSections(in tableView: UITableView) -> Int {
        if selectedTap == .review {
            return 6
        }
        return 5
    }
    
    
    /// 지정된 table view의 지정된 section에서 표시할 셀의 개수를 제공합니다.
    /// - Parameters:
    ///   - tableView: 이 정보를 요청하는 table view
    ///   - section: 테이블 뷰의 특정 섹션을 가리키는 index number
    /// - Returns: 섹션에 포함되는 아이템의 개수
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 4:
            if selectedTap == .review {
                if PlaceReviewItem.dummyData.count < 3 {
                    return PlaceReviewItem.dummyData.count
                } else {
                    return 3
                }
            }
            else { return 0 }
        default:
            return 1
        }
    }
    
    
    /// 지정된 table view의 지정 indexpath에서 표시할 셀을 제공합니다.
    /// - Parameters:
    ///   - tableView: 이 정보를 요청하는 table view
    ///   - indexPath: 열의 위치를 가리키는 indexpath
    /// - Returns: 완성된 셀
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        
        // 이미지 섹션
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "FirstSectionTableViewCell", for: indexPath) as! FirstSectionTableViewCell
            
            cell.configure(with: place)
            
            return cell
            
        // 기본 정보 섹션
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "InfoSectionTableViewCell", for: indexPath) as! InfoSectionTableViewCell
            
            cell.configure(with: place)
            
            return cell
            
        // 하위 탭 섹션
        case 2:
            return tableView.dequeueReusableCell(withIdentifier: "TabSectionTableViewCell", for: indexPath)
            
        // 선택된 하위 탭에 따라 - 상세 정보 / 리뷰 요약
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
            
        // 선택된 하위 탭에 따라 - 리뷰
        case 4:
            let cell = tableView.dequeueReusableCell(withIdentifier: "UserReviewTableViewCell", for: indexPath) as! UserReviewTableViewCell
            
            let target = PlaceReviewItem.dummyData[indexPath.row]
            cell.userPointView.rating = target.starPoint
            cell.userPointLabel.text = "\(target.starPoint)"
            cell.reviewTextLabel.text = target.reviewText
            cell.dateLabel.text = target.date.reviewDate
            cell.recommendationCountLabel.text = target.recommendationCount.description
            
            return cell
            
        case 5:
            return tableView.dequeueReusableCell(withIdentifier: "AllReviewTableViewCell", for: indexPath)
            
        default:
            fatalError()
            
        }
    }
    
}



extension PlaceInfoViewController: UITableViewDelegate {
    
    /// 지정된 indexpath의 셀 높이를 제한합니다.
    /// - Parameters:
    ///   - tableView: 이 정보를 요청하는 table view
    ///   - indexPath: 열의 위치를 가리키는 indexpath
    /// - Returns: 열이 가져야 할 높이 (음수가 아닌 실수)
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        // 이미지 섹션
        case 0:
            return tableView.frame.width * 0.5
            
        // 하위 탭 섹션
        case 2:
            return tableView.frame.width / 8
        default:
            return UITableView.automaticDimension
        }
    }
    
}
