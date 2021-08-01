//
//  PlaceSearchViewController.swift
//  PlaceSearchViewController
//
//  Created by Hyunwoo Jang on 2021/08/01.
//

import UIKit

class PlaceSearchViewController: UIViewController {

    var list: [SearchPlaceItem] = [
        SearchPlaceItem(image: UIImage(named: "place_00"), placeTitle: "카페 지미스", regionName: "고양", classificationName: "카페"),
        SearchPlaceItem(image: UIImage(named: "place_01"), placeTitle: "카페 케이원", regionName: "송리단길", classificationName: "카페"),
        SearchPlaceItem(image: UIImage(named: "place_00"), placeTitle: "카페 브리타니", regionName: "부산", classificationName: "카페"),
        SearchPlaceItem(image: UIImage(named: "place_01"), placeTitle: "꼬앙드파리", regionName: "과천", classificationName: "카페")
    ]
    
    @IBOutlet weak var searchCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // 네비게이션바에 백버튼 타이틀 지우고 SearchBar를 추가
        self.navigationController?.navigationBar.topItem?.backButtonTitle = ""
        let searchBar = UISearchBar()
        searchBar.placeholder = "검색"
        self.navigationItem.titleView = searchBar
        searchBar.becomeFirstResponder()
    }
}




extension PlaceSearchViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return list.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PlaceSearchCollectionViewCell", for: indexPath) as! PlaceSearchCollectionViewCell
    
        let target = list[indexPath.row]
        cell.configure(with: target)
        
        return cell
    }
}




extension PlaceSearchViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout else {
            return .zero
        }
        
        let width: CGFloat = ((collectionView.frame.width - (flowLayout.minimumInteritemSpacing + flowLayout.sectionInset.left + flowLayout.sectionInset.right)) / 2)
        let height = width * 1.5
        
        return CGSize(width: Int(width), height: Int(height))
    }
}
