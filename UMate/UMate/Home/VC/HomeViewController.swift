//
//  HomeViewController.swift
//  UMate
//
//  Created by 안상희 on 2021/07/12.
//

import UIKit


/// 홈 화면
/// Author: 황신택, 안상희
class HomeViewController: UIViewController {
    @IBOutlet weak var listCollectionView: UICollectionView!
    
    /// 홈화면 설계리스트 메소드
  var list = getToHomeDataList()
    
    /// 학교 고유 id
    /// - Author: 안상희
    var schoolId: Int?
    
    /// 학교 홈페이지 URL
    /// - Author: 안상희
    var homepageUrl: String?
    
    /// 학교 포탈 URL
    /// - Author: 안상희
    var portalUrl: String?
    
    /// 학교 도서관 URL
    /// - Author: 안상희
    var libraryUrl: String?
    
    /// 학교 캠퍼스맵 URL
    /// - Author: 안상희
    var mapUrl: String?
    
    /// 학교 홈페이지 URL 가용성 플래그
    /// - Author: 안상희
    var isHomepageUrlAvailable: Bool = false
    
    /// 학교 포탈 URL 가용성 플래그
    /// - Author: 안상희
    var isPortalUrlAvailable: Bool = false
    
    /// 학교 도서관 URL 가용성 플래그
    /// - Author: 안상희
    var isLibraryUrlAvailable: Bool = false
    
    /// 학교 캠퍼스맵 URL 가용성 플래그
    /// - Author: 안상희
    var isMapUrlAvailable: Bool = false
    
    
    
    /// Asset에서 학교 고유 id에 해당하는 url 주소를 불러옵니다.
    /// - Parameters:
    ///   - id: 학교 고유 id
    /// - Author: 안상희
    func getPageURL(id: Int)  {
        guard let data = NSDataAsset(name: "university_info")?.data else { return }
        
        guard let source = String(data: data, encoding: .utf8) else { return }
        
        let lines = source.components(separatedBy: "###").dropFirst()
        
        for line in lines {
            let values = line.components(separatedBy: ",")
            guard values.count == 7 else {
                continue
            }
            
            // 학교 고유 아이디
            let index = Int(values[0].trimmingCharacters(in: .whitespacesAndNewlines))
            
            // 학교 홈페이지 URL
            let homepage = "https://" + values[2].trimmingCharacters(in: .whitespaces)
            
            // 학교 포탈 URL
            let portal = values[3].trimmingCharacters(in: .whitespaces)
            
            // 학교 도서관 URL
            let library = values[4].trimmingCharacters(in: .whitespaces)
            
            // 학교 캠퍼스맵 URL
            let map = values[5].trimmingCharacters(in: .whitespaces)
            
            if index == id {
                if homepage.count != 0 {
                    homepageUrl = homepage
                    isHomepageUrlAvailable = true
                } else {
                    isHomepageUrlAvailable = false
                }
                
                if portal.count != 0 {
                    portalUrl = portal
                    isPortalUrlAvailable = true
                    
                } else {
                    isPortalUrlAvailable = false
                }
                
                if library.count != 0 {
                    libraryUrl = library
                    isLibraryUrlAvailable = true
                } else {
                    isLibraryUrlAvailable = false
                }
                
                if map.count != 0 {
                    mapUrl = map
                    isMapUrlAvailable = true
                } else {
                    isMapUrlAvailable = false
                }
            }
        }
    }
    
    
    /// 학교 고유 id에 해당하는 홈페이지 URL을 불러옵니다.
    /// - Author: 안상희
    override func viewDidLoad() {
        super.viewDidLoad()
       
        schoolId = 114
        if let id = schoolId {
            getPageURL(id: id)
        }
    }
    
    
    /// 학교 상세 정보 화면으로 이동하기 전에 학교 고유 id와 navigationTitle을 전달합니다.
    /// - Parameters:
    ///   - segue: 뷰컨트롤러에 포함된 segue에 대한 정보를 갖는 객체
    ///   - sender: MainCollectionViewCell
    /// - Author: 안상희
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let cell = sender as? UICollectionViewCell {
            if let indexPath = listCollectionView.indexPath(for: cell) {
                if let vc = segue.destination as? SchoolDetailViewController {
                    if indexPath.item == 0 {
                        vc.navigationTitle = "학교 홈페이지"
                        vc.url = homepageUrl
                    } else if indexPath.item == 1 {
                        vc.navigationTitle = "포탈"
                        vc.url = portalUrl
                    } else if indexPath.item == 2 {
                        vc.navigationTitle = "도서관"
                        vc.url = libraryUrl
                    } else {
                        vc.navigationTitle = "캠퍼스맵"
                        vc.url = mapUrl
                    }
                }
            }
        }
    }
}



extension HomeViewController: UICollectionViewDelegate {
    /// 페이지 URL 정보가 없으면 알림창을 띄웁니다.
    /// - Parameters:
    ///   - collectionView: 메인화면 콜렉션 뷰
    ///   - indexPath: 선택된 셀의 indexPath
    /// - Returns: URL 정보가 없다면 false를, 있다면 true를 리턴합니다.
    /// - Author: 안상희
    func collectionView(_ collectionView: UICollectionView,
                        shouldSelectItemAt indexPath: IndexPath) -> Bool {
        switch indexPath.item {
        case 0:
            if !isHomepageUrlAvailable {
                alert(message: "페이지 URL 정보가 없습니다.")
                return false
            }
        case 1:
            if !isPortalUrlAvailable {
                alert(message: "페이지 URL 정보가 없습니다.")
                return false
            }
        case 2:
            if !isLibraryUrlAvailable {
                alert(message: "페이지 URL 정보가 없습니다.")
                return false
            }
        case 3:
            if !isMapUrlAvailable {
                alert(message: "페이지 URL 정보가 없습니다.")
                return false
            }
        default:
            break
        }
        return true
    }
}



extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return list.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let type = list[indexPath.item]
        
        switch type {
        case .main(let model):
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MainCollectionViewCell", for: indexPath) as! MainCollectionViewCell
            cell.title.text = model.cellTitle
            cell.favoriteImageVIew.image = UIImage(named: model.backgoundImageName)
            return cell
            
            
        case .promotion(let model):
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PromotionCollectionViewCell", for: indexPath) as! PromotionCollectionViewCell
            
            cell.promotionLabel.text = model.cellTitle
            cell.detailLabel.text = model.detailTitle
            cell.promotionImageView.image = UIImage(named: model.backgoundImageName)
            
            return cell
        case .contest(let model):
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ContestCollectionViewCell", for: indexPath) as! ContestCollectionViewCell
            
            cell.titleLabel.text = model.cellTitle
            cell.detailLabel.text = model.detailTitle
            cell.contestImageView.image = UIImage(named: model.backgoundImageName)
            
            return cell
        }
        
    }
    
}



extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout else { return .zero }
        
        let type = list[indexPath.item]
        
        switch type {
        case .main(_):
            if traitCollection.horizontalSizeClass == .regular && traitCollection.verticalSizeClass == .regular {
                let width = (collectionView.frame.width - (flowLayout.minimumInteritemSpacing * 3 + flowLayout.sectionInset.left + flowLayout.sectionInset.right)) / 4
                
                return CGSize(width: Int(width), height: Int(width))
            }
            
            var width: CGFloat = (collectionView.frame.width - (flowLayout.minimumInteritemSpacing + flowLayout.sectionInset.left + flowLayout.sectionInset.right)) / 2
            
            var height = width * 1.0
            
            if view.frame.width > view.frame.height {
                height = width * 0.3
                width = (collectionView.frame.width - (flowLayout.minimumInteritemSpacing * 2 + flowLayout.sectionInset.left + flowLayout.sectionInset.right)) / 3
                
            }
            
            return CGSize(width: Int(width), height: Int(height))
            
        case .promotion(_):
            let width: CGFloat = (collectionView.frame.width - (flowLayout.minimumInteritemSpacing + flowLayout.sectionInset.left + flowLayout.sectionInset.right))
            
            let height = width * 0.3
            
            return CGSize(width: Int(width), height: Int(height))
            
        case .contest(_):
            let width: CGFloat = (collectionView.frame.width - (flowLayout.minimumInteritemSpacing + flowLayout.sectionInset.left + flowLayout.sectionInset.right))
            
            let height = width * 0.3
            
            return CGSize(width: Int(width), height: Int(height))
        }
        
    }
}
