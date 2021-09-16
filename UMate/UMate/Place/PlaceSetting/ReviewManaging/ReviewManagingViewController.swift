//
//  ReviewManagingViewController.swift
//  ReviewManagingViewController
//
//  Created by Hyunwoo Jang on 2021/09/02.
//

import Loaf
import UIKit


/// 내가 쓴 리뷰탭 관련 뷰컨트롤러 클래스
/// - Author: 장현우(heoun3089@gmail.com)
class ReviewManagingViewController: UIViewController {
    /// 내가 쓴 리뷰 목록을 표시할 테이블뷰
    /// - Author: 장현우(heoun3089@gmail.com)
    @IBOutlet weak var reviewManagingTableView: UITableView!
    
    /// 리뷰를 삭제했을 때 알림을 표시할 경고창
    /// - Author: 장현우(heoun3089@gmail.com)
    lazy var reviewDeletedLoaf: Loaf = Loaf("리뷰가 삭제되었습니다", state: .info, location: .bottom, presentingDirection: .vertical, dismissingDirection: .vertical, sender: self)
    
    
    /// 다음 화면으로 넘어가기 전에 실행할 작업을 추가합니다.
    /// - Parameters:
    ///   - segue: segue에 관련된 viewController 정보를 가지고 있는 seuge
    ///   - sender: 테이블뷰셀
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



extension ReviewManagingViewController: UITableViewDataSource {
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReviewListTableViewCell", for: indexPath) as! ReviewListTableViewCell
        
        let target = PlaceReviewItem.dummyData[indexPath.row]
        cell.configure(with: target)
        
        return cell
    }
}



extension ReviewManagingViewController: UITableViewDelegate {
    /// 오른쪽 스와이프 액션을 추가합니다.
    /// - Parameters:
    ///   - tableView: 이 메소드를 호출하는 테이블뷰
    ///   - indexPath: 행의 위치를 나타내는 IndexPath
    /// - Returns: 스와이프 액션 Configuration
    /// - Author: 장현우(heoun3089@gmail.com)
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        // 리뷰 수정 스와이프 액션을 클릭하면 리뷰를 수정하는 화면을 띄웁니다.
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
        
        // 리뷰 삭제 스와이프 액션을 클릭하면 선택한 리뷰를 삭제합니다.
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
