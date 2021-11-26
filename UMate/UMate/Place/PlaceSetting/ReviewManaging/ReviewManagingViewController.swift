//
//  ReviewManagingViewController.swift
//  ReviewManagingViewController
//
//  Created by Hyunwoo Jang on 2021/09/02.
//

import Loaf
import UIKit


/// 리뷰 관리 화면
/// - Author: 장현우(heoun3089@gmail.com)
class ReviewManagingViewController: CommonViewController {
    
    /// 리뷰 목록 테이블뷰
    @IBOutlet weak var reviewManagingTableView: UITableView!
    
    /// 경고창
    ///
    /// 리뷰를 삭제했을 때 경고창을 표시합니다.
    lazy var reviewDeletedLoaf: Loaf = Loaf("리뷰가 삭제되었습니다", state: .info, location: .bottom, presentingDirection: .vertical, dismissingDirection: .vertical, sender: self)
    
    
    /// 다음 화면으로 넘어가기 전에 실행할 작업을 추가합니다.
    ///
    /// 선택된 상점 정보를 보냅니다.
    /// - Parameters:
    ///   - segue: viewController 정보를 가지고 있는 segue
    ///   - sender: 내가 쓴 리뷰 셀
    /// - Author: 장현우(heoun3089@gmail.com)
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let cell = sender as? UITableViewCell, let indexPath = reviewManagingTableView.indexPath(for: cell) {
            if let vc = segue.destination as? PlaceInfoViewController {
                let place = Place.dummyData.first(where: { $0.name == PlaceReviewDataManager.shared.placeReviewList[indexPath.row].place.name})
                
                vc.place = place
            }
        }
    }
    
    
    /// 초기화 작업을 실행합니다.
    ///
    /// 상점 리뷰 데이터를 다운로드합니다.
    /// - Author: 장현우(heoun3089@gmail.com)
    override func viewDidLoad() {
        super.viewDidLoad()
        
        PlaceReviewDataManager.shared.fetchReview(vc: self) {
            self.reviewManagingTableView.reloadData()
        }
        
        var token = NotificationCenter.default.addObserver(forName: .reviewDidEdited, object: nil, queue: .main) { [weak self] _ in
            guard let self = self else { return }
            
            PlaceReviewDataManager.shared.fetchReview(vc: self) {
                self.reviewManagingTableView.reloadData()
            }
        }
        tokens.append(token)
        
        token = NotificationCenter.default.addObserver(forName: .reviewEditFailed,
                                                       object: nil,
                                                       queue: .main) { _ in
            self.alert(message: "리뷰 수정에 실패했습니다.")
        }
        tokens.append(token)
        
        token = NotificationCenter.default.addObserver(forName: .errorOccured,
                                                       object: nil,
                                                       queue: .main) { _ in
            self.alert(message: "에러가 발생했습니다.")
        }
        tokens.append(token)
    }
}



/// 리뷰 목록 테이블뷰 데이터 관리
extension ReviewManagingViewController: UITableViewDataSource {
    
    /// 섹션에 표시할 셀 수를 리턴합니다.
    /// - Parameters:
    ///   - tableView: 리뷰 목록 테이블뷰
    ///   - section: 섹션 인덱스
    /// - Returns: 섹션 행의 수
    /// - Author: 장현우(heoun3089@gmail.com)
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return PlaceReviewDataManager.shared.placeReviewList.count
    }
    
    
    /// 섹션의 따라 셀을 구성합니다.
    /// - Parameters:
    ///   - tableView: 리뷰 목록 테이블뷰
    ///   - indexPath: 행의 위치를 나타내는 IndexPath
    /// - Returns: 구성한 셀
    /// - Author: 장현우(heoun3089@gmail.com)
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReviewListTableViewCell", for: indexPath) as! ReviewListTableViewCell
        
        let target = PlaceReviewDataManager.shared.placeReviewList[indexPath.row]
        cell.configure(with: target)
        
        return cell
    }
}



/// 스와이프 액션 추가
extension ReviewManagingViewController: UITableViewDelegate {
    
    /// 오른쪽 스와이프 액션을 추가합니다.
    /// - Parameters:
    ///   - tableView: 리뷰 목록 테이블뷰
    ///   - indexPath: 행의 위치를 나타내는 IndexPath
    /// - Returns: 스와이프 액션 Configuration
    /// - Author: 장현우(heoun3089@gmail.com)
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let edit = UIContextualAction(style: .normal, title: "리뷰 수정") { act, v, completion in
            let storyboard = UIStoryboard(name: "ReviewWrite", bundle: nil)
            
            if let vc = storyboard.instantiateViewController(withIdentifier: "ReviewWriteTableViewController") as? ReviewWriteTableViewController {
                let reviewData = PlaceReviewDataManager.shared.placeReviewList[indexPath.row]
                vc.reviewData = reviewData
                vc.placeName = reviewData.place.name
                self.present(vc, animated: true, completion: nil)
            }
            
            completion(true)
        }
        
        edit.backgroundColor = .systemBlue
        edit.image = UIImage(systemName: "square.and.pencil")
        
        let delete = UIContextualAction(style: .destructive, title: "리뷰 삭제") { act, v, completion in
            DispatchQueue.main.async {
                self.alertVersion2(message: "선택한 리뷰를 삭제하시겠습니까?", handler: { _ in
                    let targetReviewId = PlaceReviewDataManager.shared.placeReviewList[indexPath.row].placeReviewId
                    
                    PlaceReviewDataManager.shared.deleteReview(reviewId: targetReviewId, vc: self)
                    
                    if let index = PlaceReviewDataManager.shared.placeReviewList.firstIndex(where: { $0.placeReviewId == targetReviewId }) {
                        PlaceReviewDataManager.shared.placeReviewList.remove(at: index)
                    }
                    
                    self.reviewManagingTableView.deleteRows(at: [indexPath], with: .automatic)
                    
                    completion(true)
                })
            }
        }
        
        delete.backgroundColor = .red
        delete.image = UIImage(systemName: "pencil.slash")
        
        let conf = UISwipeActionsConfiguration(actions: [delete, edit])
        conf.performsFirstActionWithFullSwipe = true
        return conf
    }
}
