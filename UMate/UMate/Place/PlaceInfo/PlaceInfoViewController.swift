//
//  PlaceViewController.swift
//  UMate
//
//  Created by 안상희 on 2021/07/12.
//

import UIKit
import SafariServices

extension Notification.Name {
    /// 하위 탭을 선택할 때 post할 notification
    static let tapToggleDidRequest = Notification.Name(rawValue: "tapToggleDidRequest")
}




class PlaceInfoViewController: UIViewController {
    
    @IBOutlet weak var placeInfoTableView: UITableView!
    
    /// 가게 더미 데이터
    var place: Place! = Place.dummyData.first
    
    /// 리뷰 요약 데이터
    var review = PlaceReviewItem(starPoint: 4.8,
                                 taste: .clean,
                                 service: .kind,
                                 mood: .emotional,
                                 price: .affordable,
                                 amount: .suitable)
    
    /// 리뷰 데이터
    var reviews = [
        PlaceReviewItem.UserReview(reviewText: "분위기 너무 좋아요", date: "2021.06.01"),
        PlaceReviewItem.UserReview(reviewText: "커피 맛이 좋아요", date: "2021.05.28"),
        PlaceReviewItem.UserReview(reviewText: "커피는 데일리루틴 나만 알고싶은집", date: "2021.05.23")
    ]
    
    
    /// 화면 초기화
    override func viewDidLoad() {
        super.viewDidLoad()
        
        placeInfoTableView.dataSource = self
        placeInfoTableView.delegate = self
    }
    
    
    // MARK: 탭 그룹
    
    /// 상세 페이지 하위 탭
    enum SubTab {
        case detail
        case review
    }
    
    /// 선택된 탭을 저장하는 속성
    var selectedTap: SubTab = .detail
    
    
    /// 탭 버튼을 선택하면 호출되는 메소드 -
    /// - Parameter sender: 탭 버튼
    @IBAction func selectTap(_ sender: UIButton) {
        switch sender.tag {
        
        case 100:
            // 선택된 탭 저장
            selectedTap = .detail
            
            // 선택된 탭에 대한 정보를 함께 전달
            NotificationCenter.default.post(name: .tapToggleDidRequest, object: nil, userInfo: ["selectedTap": selectedTap])
            
            
            // 테이블 뷰 리로드 -> 테이블 뷰가 알맞은 셀 표시
            placeInfoTableView.reloadData()
            
        case 101:
            selectedTap = .review
            
            NotificationCenter.default.post(name: .tapToggleDidRequest, object: nil, userInfo: ["selectedTap": selectedTap])
            
            placeInfoTableView.reloadData()
            
        default:
            break
        }
    }
    
    @IBAction func openUrl(_ sender: UIButton) {
        guard let placeURLString = place.url,
              let placeURL = URL(string: placeURLString) else { return }
        openUrl(with: placeURL)
        
    }
    
}

// MARK: Open URL

enum PreferredBrowser: Int {
    case none
    case `internal`
    case external
}

class Preference {
    static var preferredBrowser: PreferredBrowser {
        get {
            let rawValue = UserDefaults.standard.integer(forKey: "preferToOpenInThisApp")
            return PreferredBrowser(rawValue: rawValue) ?? .none
        }
        set {
            UserDefaults.standard.set(newValue.rawValue, forKey: "preferToOpenInThisApp")
        }
    }
}

extension UIViewController {
    
    /// url을 전달하면 설정에 따라 알맞은 방식으로 url을 열어줍니다.
    /// - Parameter urlString: 열 url
    func openUrl(with url: URL) {
        switch Preference.preferredBrowser {
        case .none:
            selectAndOpenUrl(with: url)
        case .internal:
            openURLInternal(url: url)
        case .external:
            openURLExternal(url: url)
        }
    }
    
    /// URL을 전달하면 오픈 방식을 선택하도록 하고, 선택된 방식으로 열어줍니다.
    /// - Parameter url: 오픈할 url
    private func selectAndOpenUrl(with url: URL) {
        
        let openInternal: (UIAlertAction) -> () = { [weak self] _ in
            guard let self = self else { return }
            
            self.openURLInternal(url: url)
        }
        
        let openExternal: (UIAlertAction) -> () = { [weak self] _ in
            guard let self = self else { return }
            
            self.openURLExternal(url: url)
        }
            
            let sheet = UIAlertController(title: nil,
                                          message: nil,
                                          preferredStyle: .actionSheet)
            let openInThisApp = UIAlertAction(title: "이 앱에서 열기",
                                              style: .default,
                                              handler: openInternal)
            let openInOtherApp = UIAlertAction(title: "관련 앱에서 열기",
                                               style: .default,
                                               handler: openExternal)
            
            let cancelAction = UIAlertAction(title: "취소",
                                             style: .cancel,
                                             handler: nil)
            
            sheet.addAction(openInThisApp)
            sheet.addAction(openInOtherApp)
            sheet.addAction(cancelAction)
            
            present(sheet, animated: true, completion: nil)
        
    }
    
    private func openURLInternal(url: URL) {
//        guard let openUrlVC = UIStoryboard(name: "OpenURLViewController", bundle: nil).instantiateViewController(identifier: "OpenURLViewController") as? OpenURLViewController else { return }
//
//        openUrlVC.url = url
//
//        self.present(UINavigationController(rootViewController: openUrlVC), animated: true, completion: nil)
        
        let safariVC = SFSafariViewController(url: url)
        self.present(safariVC, animated: true, completion: nil)
    }
    
    func openURLExternal(url: URL) {
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    func launchApp(url: URL) {
        
    }
}



// MARK: Tableview Delegation
extension PlaceInfoViewController: UITableViewDataSource {
    
    /// table view에서 몇 개의 section을 표시할 건지 data source에게 묻는 메소드
    /// - Parameter tableView: 이 정보를 요청하는 table view
    /// - Returns: 섹션의 개수
    func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    
    
    /// 지정된 섹션에서 몇 개의 item을 표시할 건지 data source에게 묻는 메소드
    /// - Parameters:
    ///   - tableView: 이 정보를 요청하는 table view
    ///   - section: 테이블 뷰의 특정 섹션을 가리키는 index number
    /// - Returns: 섹션에 포함되는 아이템의 개수
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 4:
            if selectedTap == .review { return reviews.count }
            else { return 0 }
        default:
            return 1
        }
    }
    
    
    /// data source에게 테이블 뷰에서 특정 indexpath의 아이템에 응하는 셀을 요청하는 메소드
    /// - Parameters:
    ///   - tableView: 이 정보를 요청하는 table view
    ///   - indexPath: 열의 위치를 가리키는 indexpath
    /// - Returns: 완성된 셀
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        
        /// 이미지 섹션
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "FirstSectionTableViewCell", for: indexPath) as! FirstSectionTableViewCell
            
            cell.configure(with: place)
            
            return cell
            
        /// 기본 정보 섹션
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "InfoSectionTableViewCell", for: indexPath) as! InfoSectionTableViewCell
            
            cell.configure(with: place, viewController: self)
            
            return cell
            
        /// 하위 탭 섹션
        case 2:
            return tableView.dequeueReusableCell(withIdentifier: "TabSectionTableViewCell", for: indexPath)
            
        /// 선택된 하위 탭에 따라 - 상세 정보 / 리뷰 요약
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
            
        /// 선택된 하위 탭에 따라 - 리뷰
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

extension PlaceInfoViewController: UITableViewDelegate {
    
    /// 섹션 - 현재는 이미지 섹션 - 의 높이를 제한하는 메소드
    /// - Parameters:
    ///   - tableView: 이 정보를 요청하는 table view
    ///   - indexPath: 열의 위치를 가리키는 indexpath
    /// - Returns: 열이 가져야 할 높이 (음수가 아닌 실수)
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return tableView.frame.width * 0.5
        }
        else {
            return UITableView.automaticDimension
        }
    }
}
