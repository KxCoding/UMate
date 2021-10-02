//
//  SelectImageViewController.swift
//  UMate
//
//  Created by Chris Kim on 2021/08/10.
//

import UIKit
import Photos
import PhotosUI
import MobileCoreServices


/// 게시글에 첨부할 이미지를 선택하는 뷰컨트롤러
/// - Author: 김정민(kimjm010@icloud.com)

class SelectImageViewController: CommonViewController {

    
    /// 게시글 작성 시 이미지 첨부를 위한 아울렛
    /// - Author: 김정민(kimjm010@icloud.com)
    @IBOutlet weak var imageCollectionView: UICollectionView!
    @IBOutlet weak var editBtn: UIBarButtonItem!
    
    /// 이미지 fetch를 위한 속성
    /// - Author: 김정민(kimjm010@icloud.com)
    let imageManager = PHImageManager()
    
    /// 제한된 사진에 접근할 수 있는 권한이 있는지를 확인하는 속성
    /// - Author: 김정민(kimjm010@icloud.com)
    var hasLimitedPermission = false
    
    /// Fetch한 사진을 담을 속성
    /// - Author: 김정민(kimjm010@icloud.com)
    var allPhotos: PHFetchResult<PHAsset> = {
        let option = PHFetchOptions()
        
        let sortByDateAsc = NSSortDescriptor(key: "creationDate", ascending: true)
        option.sortDescriptors = [sortByDateAsc]
        
        return PHAsset.fetchAssets(with: option)
    }()
    
    
    /// 이미지 첨부를 위한 ViewController를 닫습니다.
    /// - Parameter sender: SelectImageViewController
    /// - Author: 김정민(kimjm010@icloud.com)
    @IBAction func closeVC(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    /// 제한된 사진에 접근할 수 있는 경우, 제한 된 사진을 편집할 수 있습니다.
    /// - Parameter sender: SelectImageViewController
    /// - Author: 김정민(kimjm010@icloud.com)
    @IBAction func editSelectedImage(_ sender: Any) {
        PHPhotoLibrary.shared().presentLimitedLibraryPicker(from: self)
    }
    
    
    /// 게시글에 첨부할 이미지를 선택합니다.
    /// - Author: 김정민(kimjm010@icloud.com)
    @IBAction func selectImage(_ sender: Any) {
        guard let indexPath = imageCollectionView.indexPathsForSelectedItems else { return }
        
        for index in indexPath {
            let target = allPhotos.object(at: index.item)
            let size = CGSize(width: imageCollectionView.frame.width / 4,
                              height: imageCollectionView.frame.width / 4)
            
            imageManager.requestImage(for: target, targetSize: size, contentMode: .aspectFill, options: nil) { (image, _) in
                
                NotificationCenter.default.post(name: .imageDidSelect, object: nil, userInfo: ["img": [image]])
                
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    
    /// 사진에 접근하기 위한 권한 요청합니다.
    /// - Author: 김정민(kimjm010@icloud.com)
    func requestAuthorization() {
        let status: PHAuthorizationStatus
        
        status = PHPhotoLibrary.authorizationStatus(for: .readWrite)
        hasLimitedPermission = status == .limited
        
        switch status {
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization(for: .readWrite) { (selectedStatus) in
                switch selectedStatus {
                case .authorized, .limited:
                    DispatchQueue.main.async {
                        self.editBtn.isEnabled = selectedStatus == .limited
                    }
                    self.hasLimitedPermission = selectedStatus == .limited
                    break
                default:
                    // TODO: 접근할 수 없음 -> 설정에서 변경하라는 알림창
                    break
                }
            }
        case .denied:
            // TODO: 접근할 수 없음 -> 설정에서 변경하라는 알림창
            break
        case .restricted:
            // TODO: 접근할 수 없음 -> 설정에서 변경하라는 알림창
            break
        case .limited:
            self.editBtn.isEnabled = true
        case .authorized:
            self.editBtn.isEnabled = false
        default:
            break
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        requestAuthorization()
        imageCollectionView.allowsSelection = true
        imageCollectionView.allowsMultipleSelection = true
        
        PHPhotoLibrary.shared().register(self)
    }
    
    
    deinit {
        PHPhotoLibrary.shared().unregisterChangeObserver(self)
    }
}



/// 게시글에 첨부할 이미지를 선택합니다.
/// - Author: 김정민(kimjm010@icloud.com)
extension SelectImageViewController: UICollectionViewDataSource {
    
    /// 사용자의 사진앱에 있는 이미지를 표시하기 위한 컬렉션뷰입니다.
    /// - Parameters:
    ///   - collectionView: collectionView
    ///   - section: 하나의 섹션에 표시할 아이템의 갯수
    /// - Returns: Fetch된 사진의 갯수
    /// - Author: 김정민(kimjm010@icloud.com)
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return allPhotos.count
    }
    
    
    /// 각 셀마다 이미지를 표시합니다.
    /// - Author: 김정민(kimjm010@icloud.com)
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCollectionViewCell", for: indexPath)
            as! ImageCollectionViewCell
        let target = allPhotos.object(at: indexPath.item)
        let size = CGSize(width: collectionView.frame.width / 4, height: collectionView.frame.width / 4)
        
        imageManager.requestImage(for: target, targetSize: size, contentMode: .aspectFill, options: nil) { image, _ in
            cell.imageView.image = image
        }
        
        return cell
    }
}




extension SelectImageViewController: UICollectionViewDelegateFlowLayout {
    
    /// Fetch된 이미지의 사이즈를 설정합니다.
    /// - Parameters:
    ///   - collectionView: 이미지컬렉션뷰
    ///   - collectionViewLayout: 컬렉션뷰의 레이아웃
    ///   - indexPath: 컬렉션뷰 아이템의 인덱스패스
    /// - Returns: 화면에 4개의 이미지가 표시될 수 있습니다.
    /// - Author: 김정민(kimjm010@icloud.com)
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width / 4, height: collectionView.frame.width / 4)
    }
}




extension SelectImageViewController: PHPhotoLibraryChangeObserver {
    
    /// PhotoLibrary 옵저버 제거합니다.
    /// - Author: 김정민(kimjm010@icloud.com)
    func photoLibraryDidChange(_ changeInstance: PHChange) {
        DispatchQueue.main.async {
            if let changes = changeInstance.changeDetails(for: self.allPhotos) {
                self.allPhotos = changes.fetchResultAfterChanges
                self.imageCollectionView.reloadData()
            }
        }
    }
}
