//
//  PlaceMainViewController.swift
//  UMate
//
//  Created by Effie on 2021/08/05.
//

import UIKit

extension UIView {
    
    func setViewPillShape() {
        self.layer.cornerRadius = self.frame.height / 2
        self.layer.borderColor = UIColor.systemGray4.cgColor
        self.layer.borderWidth = 1
    }
    
    func setViewSquircle() {
        self.layer.cornerRadius = self.frame.height / 6
        self.layer.borderColor = UIColor.systemGray4.cgColor
        self.layer.borderWidth = 1
    }
}

class PlaceMainViewController: UIViewController {
    
    @IBOutlet weak var locationContainer: UIView!
    @IBOutlet weak var searchBtnContainer: UIView!
    
    @IBOutlet weak var nearbyPlaceCollectionView: UICollectionView!
    
    var list = [Place]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        list.append(contentsOf: [
            Place(name: "스티키리키",
                  university: "숙명여대",
                  district: "숙대입구역 인근",
                  type: .desert,
                  keywords: ["수제 아이스크림", "포토존", "핫플", "아기자기한"],
                  instagramID: "stickyrickys",
                  url: "http://naver.me/xE1xr6kD"),
            Place(name: "오오비",
                  university: "숙명여대",
                  district: "숙대입구역 인근",
                  type: .cafe,
                  keywords: ["햇살 맛집", "드립커피", "아늑한", "LP 음악", "통창"],
                  instagramID: "oob_official",
                  url: "http://naver.me/FMAdSiZN"),
            Place(name: "카페 모",
                  university: "숙명여대",
                  district: "숙대입구역 인근",
                  type: .cafe,
                  keywords: ["보태니컬", "영화", "햇살 맛집", "나만 알고 싶은"],
                  instagramID: "cafe_mo",
                  url: "http://naver.me/F7CF9X6a"),
            Place(name: "부암동 치킨",
                  university: "숙명여대",
                  district: "청파동 언덕길",
                  type: .restaurant,
                  keywords: ["치킨", "맛집", "회식", "뒷풀이"],
                  instagramID: nil,
                  url: "http://naver.me/5y4qBz2M")
        ])
        
        nearbyPlaceCollectionView.dataSource = self
        nearbyPlaceCollectionView.delegate = self
        
        nearbyPlaceCollectionView.isPagingEnabled = true
        nearbyPlaceCollectionView.decelerationRate = UIScrollView.DecelerationRate.fast
        
        // Item
        // fractionalWidth, fractionalHeight는 0~1 사이 값, 1이면 상위(group size)만큼 채움
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 5)

        // Group
        // width: 상대값: fractionWidth(0.8), 넓이는 상위(section) width의 80%
        // height: 절대값: absolute(120)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.9), heightDimension: .absolute(120))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])

        // Section (orthogonalScrollingBehavior)
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPagingCentered

        // Compositional Layout
        let layout = UICollectionViewCompositionalLayout(section: section)
        nearbyPlaceCollectionView.collectionViewLayout = layout
        
        locationContainer.setViewPillShape()
        searchBtnContainer.setViewPillShape()
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let cell = sender as? NearbyPlaceCollectionViewCell, let indexPath = nearbyPlaceCollectionView.indexPath(for: cell) {
            if let vc = segue.destination as? PlaceInfoViewController {
                vc.place = list[indexPath.item]   
            }
        }
    }
}

extension PlaceMainViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return list.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NearbyPlaceCollectionViewCell", for: indexPath) as! NearbyPlaceCollectionViewCell
        
        cell.configure(with: list[indexPath.item])
        
        return cell
    }
    
}


extension PlaceMainViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = collectionView.frame.width - 48
        let height = CGFloat(120)
        return CGSize(width: width, height: height)
    }
    
}
