//
//  HomeViewController.swift
//  UMate
//
//  Created by 안상희 on 2021/07/12.
//

import UIKit


/// 홈화면
/// - Author: 황신택 (sinadsl1457@gmail.com), 안상희
class HomeViewController: UIViewController {
    /// 홈 화면 콜렉션뷰
    @IBOutlet weak var listCollectionView: UICollectionView!
    
    /// 홈 화면 데이터 리스트
    var list = HomeViewCellData.getHomeDataList()
    
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
    /// 섹션에 아이템을 개수를 지정합니다.
    /// - Parameters:
    ///   - collectionView: 해당 요청을 보낸 콜렉션 뷰
    ///   - section: 섹션의 위치
    /// - Returns: 색션에 표시할 아이템 개수를 리턴합니다.
    /// - Author: 황신택 (sinadsl1457@gmail.com)
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return list.count
    }
    
    
    /// 셀에 데이터를 지정합니다.
    /// - Parameters:
    ///   - collectionView: 관련 요청을 보낸 콜렉션 뷰
    ///   - indexPath: 셀의 indexPath
    /// - Returns: 홈데이터가 표시된 셀이 리턴됩니다.
    /// - Author: 황신택 (sinadsl1457@gmail.com)
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let type = list[indexPath.item]
        
        switch type {
        case .main(let model):
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MainCollectionViewCell", for: indexPath) as! MainCollectionViewCell
            cell.title.text = model.cellTitle
            cell.favoriteImageView.image = UIImage(named: model.backgoundImageName)
            return cell
        case .promotion(let model):
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PromotionCollectionViewCell", for: indexPath) as! CompaniesInfoCollectionViewCell
            cell.companyCategoryLabel.text = model.cellTitle
            cell.detailLabel.text = model.detailTitle
            cell.companyCategoryImageView.image = UIImage(named: model.backgoundImageName)
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
    /// 델리게이트에게 지정된 아이템의 셀의 사이즈를 물어봅니다.
    /// - Parameters:
    ///   - collectionView: 레이아웃을 표시하는 콜렉션 뷰
    ///   - collectionViewLayout: 정보를 요청한 레이아웃 객체
    ///   - indexPath: 아이템의 위치를 나타내는 indexPath
    /// - Returns: 지정된 아이템의 넓이 높이를 리턴합니다.
    /// - Author: 황신택 (sinadsl1457@gmail.com)
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
            let width: CGFloat = (collectionView.frame.width - (flowLayout.minimumInteritemSpacing + flowLayout.sectionInset.left + flowLayout.sectionInset.right)) * 1.06
            
            let height = width * 0.3
            
            return CGSize(width: Int(width), height: Int(height))
            
        case .contest(_):
            let width: CGFloat = (collectionView.frame.width - (flowLayout.minimumInteritemSpacing + flowLayout.sectionInset.left + flowLayout.sectionInset.right)) * 1.06
            
            let height = width * 0.3
            
            return CGSize(width: Int(width), height: Int(height))
        }
    }
}
