//
//  ReviewManagingViewController.swift
//  ReviewManagingViewController
//
//  Created by Hyunwoo Jang on 2021/09/02.
//

import Loaf
import UIKit


/// 내가 쓴 리뷰 화면
/// - Author: 장현우(heoun3089@gmail.com)
class ReviewManagingViewController: UIViewController {
    
    /// 내가 쓴 리뷰 테이블뷰
    @IBOutlet weak var reviewManagingTableView: UITableView!
    
    /// 경고창
    ///
    /// 리뷰를 삭제했을 때 경고창을 표시합니다.
    lazy var reviewDeletedLoaf: Loaf = Loaf("리뷰가 삭제되었습니다", state: .info, location: .bottom, presentingDirection: .vertical, dismissingDirection: .vertical, sender: self)
    
    
    /// 다음 화면으로 넘어가기 전에 실행할 작업을 추가합니다.
    ///
    /// 선택된 상점 정보를 보냅니다.
    /// - Parameters:
    ///   - segue: viewController 정보를 가지고 있는 seuge
    ///   - sender: 내가 쓴 리뷰 셀
    /// - Author: 장현우(heoun3089@gmail.com)
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let cell = sender as? UITableViewCell, let indexPath = reviewManagingTableView.indexPath(for: cell) {
            if let vc = segue.destination as? PlaceInfoViewController {
                let place = Place.dummyData.first(where: { $0.name == PlaceReviewItem.dummyData[indexPath.row].placeName})
                
                vc.place = place
            }
        }
    }
}



/// 내가 쓴 리뷰 테이블뷰 데이터 관리
extension ReviewManagingViewController: UITableViewDataSource {
    
    /// 섹션에 표시할 셀 수를 리턴합니다.
    /// - Parameters:
    ///   - tableView: 내가 쓴 리뷰 테이블뷰
    ///   - section: 섹션 인덱스
    /// - Returns: 섹션 행의 수
    /// - Author: 장현우(heoun3089@gmail.com)
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return PlaceReviewItem.dummyData.count
    }
    
    
    /// 섹션의 따라 셀을 구성합니다.
    /// - Parameters:
    ///   - tableView: 내가 쓴 리뷰 테이블뷰
    ///   - indexPath: 행의 위치를 나타내는 IndexPath
    /// - Returns: 구성한 셀
    /// - Author: 장현우(heoun3089@gmail.com)
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReviewListTableViewCell", for: indexPath) as! ReviewListTableViewCell
        
        let target = PlaceReviewItem.dummyData[indexPath.row]
        cell.configure(with: target)
        
        return cell
    }
}



/// 스와이프 액션 추가
extension ReviewManagingViewController: UITableViewDelegate {
    
    /// 오른쪽 스와이프 액션을 추가합니다.
    /// - Parameters:
    ///   - tableView: 내가 쓴 리뷰 테이블뷰
    ///   - indexPath: 행의 위치를 나타내는 IndexPath
    /// - Returns: 스와이프 액션 Configuration
    /// - Author: 장현우(heoun3089@gmail.com)
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let edit = UIContextualAction(style: .normal, title: "리뷰 수정") { act, v, completion in
            let storyboard = UIStoryboard(name: "ReviewWrite", bundle: nil)
            
            if let vc = storyboard.instantiateViewController(withIdentifier: "ReviewWriteTableViewController") as? ReviewWriteTableViewController {
                let reviewData = PlaceReviewItem.dummyData[indexPath.row]
                vc.reviewData = reviewData
                self.present(vc, animated: true, completion: nil)
            }
            
            completion(true)
        }
        
        edit.backgroundColor = .systemBlue
        edit.image = UIImage(systemName: "square.and.pencil")
        
        let delete = UIContextualAction(style: .destructive, title: "리뷰 삭제") { act, v, completion in
            PlaceReviewItem.dummyData.remove(at: indexPath.row)
            self.reviewManagingTableView.deleteRows(at: [indexPath], with: .automatic)
            self.reviewDeletedLoaf.show(.custom(1.2))
            
            completion(true)
        }
        
        delete.backgroundColor = .red
        delete.image = UIImage(systemName: "pencil.slash")
        
        let conf = UISwipeActionsConfiguration(actions: [delete, edit])
        conf.performsFirstActionWithFullSwipe = true
        return conf
    }
}
