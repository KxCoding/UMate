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


/// 앨범 표시 화면
/// - Author: 김정민(kimjm010@icloud.com)
class SelectImageViewController: CommonViewController {

    /// 앨범의 이미지
    @IBOutlet weak var imageCollectionView: UICollectionView!
    
    /// 편집버튼
    /// 제한된 사진을 변경할 수 있습니다.
    @IBOutlet weak var editBtn: UIBarButtonItem!
    
    /// 이미지 fetch 객체
    let imageManager = PHImageManager()
    
    /// 제한된 접근권한 확인
    var hasLimitedPermission = false
    
    /// Fetch한 사진 저장
    var allPhotos: PHFetchResult<PHAsset> = {
        let option = PHFetchOptions()
        
        let sortByDateAsc = NSSortDescriptor(key: "creationDate", ascending: true)
        option.sortDescriptors = [sortByDateAsc]
        
        return PHAsset.fetchAssets(with: option)
    }()
    
    
    /// 앨범 화면 닫기
    /// - Parameter sender: cancel버튼
    @IBAction func closeVC(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    /// 접근 가능한 사진 편집
    /// 제한된 사진에 접근할 수 있는 경우, 제한 된 사진을 편집할 수 있습니다.
    /// - Parameter sender: SelectImageViewController
    @IBAction func editSelectedImage(_ sender: Any) {
        PHPhotoLibrary.shared().presentLimitedLibraryPicker(from: self)
    }
    
    
    /// 게시글에 첨부할 이미지를 선택합니다.
    /// - Parameter sender: select 버튼
    @IBAction func selectImage(_ sender: Any) {
        guard let indexPath = imageCollectionView.indexPathsForSelectedItems else { return }
        
        for index in indexPath {
            let target = allPhotos.object(at: index.item)
            let size = CGSize(width: imageCollectionView.frame.width / 4,
                              height: imageCollectionView.frame.width / 4)
            
            imageManager.requestImage(for: target,
                                         targetSize: size,
                                         contentMode: .aspectFill,
                                         options: nil) { (image, _) in
                
                NotificationCenter.default.post(name: .imageDidSelect,
                                                object: nil,
                                                userInfo: ["img": [image]])
                
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    
    /// 사진에 접근하기 위한 권한 요청합니다.
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




/// 첨부할 이미지 데이터 설정
/// - Author: 김정민(kimjm010@icloud.com)
extension SelectImageViewController: UICollectionViewDataSource {
    
    /// 접근 가능한 이미지 갯수를 리턴합니다.
    /// - Parameters:
    ///   - collectionView: imageCollectionView
    ///   - section: 하나의 섹션에 표시할 아이템의 갯수
    /// - Returns: Fetch된 사진의 갯수
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return allPhotos.count
    }
    
    
    /// 이미지를 표시합니다.
    /// - Parameters:
    ///   - collectionView: imageCollectionView
    ///   - indexPath: image의 indexPath
    /// - Returns: imageCollectionView의 cell
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCollectionViewCell",
                                                      for: indexPath) as! ImageCollectionViewCell
        
        let target = allPhotos.object(at: indexPath.item)
        let size = CGSize(width: collectionView.frame.width / 4, height: collectionView.frame.width / 4)
        imageManager.requestImage(for: target, targetSize: size, contentMode: .aspectFill, options: nil) { image, _ in
            cell.imageView.image = image
        }
        
        return cell
    }
}




/// 컬렉션뷰셀의 사이즈 설정
/// - Author: 김정민(kimjm010@icloud.com)
extension SelectImageViewController: UICollectionViewDelegateFlowLayout {
    
    /// 컬렉션뷰 셀의 사이즈를 설정합니다.
    /// - Parameters:
    ///   - collectionView: 이미지컬렉션뷰
    ///   - collectionViewLayout: 컬렉션뷰의 레이아웃
    ///   - indexPath: 컬렉션뷰 아이템의 인덱스패스
    /// - Returns: 화면에 4개의 이미지가 표시될 수 있습니다.
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: collectionView.frame.width / 4,
                      height: collectionView.frame.width / 4)
    }
}




/// PhotoLibrary 옵저버 제거
/// - Author: 김정민(kimjm010@icloud.com)
extension SelectImageViewController: PHPhotoLibraryChangeObserver {
    
    /// photoLibrary애 변화가 있을 경우 호출
    /// - Parameter changeInstance: 수정사항이 있는 photolibrary 객체
    func photoLibraryDidChange(_ changeInstance: PHChange) {
        DispatchQueue.main.async {
            if let changes = changeInstance.changeDetails(for: self.allPhotos) {
                self.allPhotos = changes.fetchResultAfterChanges
                self.imageCollectionView.reloadData()
            }
        }
    }
}
