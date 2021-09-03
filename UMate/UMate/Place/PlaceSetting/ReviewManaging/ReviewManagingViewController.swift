//
//  ReviewManagingViewController.swift
//  ReviewManagingViewController
//
//  Created by Hyunwoo Jang on 2021/09/02.
//

import UIKit

class ReviewManagingViewController: UIViewController {
    @IBOutlet weak var reviewManagingTableView: UITableView!
    var reviewData = PlaceReviewItem.dummyData
    
    
    /// 다음 화면으로 넘어가기 전에 실행할 작업을 추가합니다.
    /// - Parameters:
    ///   - segue: segue에 관련된 viewController 정보를 가지고 있는 seuge
    ///   - sender: 테이블뷰셀
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
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reviewData.count
    }
    
    
    /// 데이터소스 객체에게 지정된 위치에 해당하는 셀에 데이터를 요청합니다.
    /// - Parameters:
    ///   - tableView: 이 메소드를 호출하는 테이블뷰
    ///   - indexPath: 행의 위치를 나타내는 IndexPath
    /// - Returns: 설정한 셀
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReviewListTableViewCell", for: indexPath) as! ReviewListTableViewCell
        
        let target = reviewData[indexPath.row]
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
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let edit = UIContextualAction(style: .normal, title: "리뷰 수정") { act, v, completion in
            print("리뷰 수정")
            completion(true)
        }
        
        edit.backgroundColor = .systemBlue
        edit.image = UIImage(systemName: "square.and.pencil")
        
        let delete = UIContextualAction(style: .destructive, title: "리뷰 삭제") { act, v, completion in
            self.reviewData.remove(at: indexPath.row)
            self.reviewManagingTableView.deleteRows(at: [indexPath], with: .automatic)
            completion(true)
        }
        
        delete.backgroundColor = .red
        delete.image = UIImage(systemName: "pencil.slash")
        
        let conf = UISwipeActionsConfiguration(actions: [delete, edit])
        conf.performsFirstActionWithFullSwipe = true
        return conf
    }
}
