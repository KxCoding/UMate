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
import RxSwift
import RxCocoa
import NSObject_Rx


/// 서버에 이미지 저장
/// - Author: 남정은(dlsl7080@gmail.com)
extension Notification.Name {
    static let requestPostImage = Notification.Name(rawValue: "requestPostImage")
}




/// 앨범 표시 화면
/// - Author: 김정민(kimjm010@icloud.com), 남정은(dlsl7080@gmail.com)
class SelectImageViewController: CommonViewController {
    
    /// 앨범의 이미지 컬렉션뷰
    @IBOutlet weak var imageCollectionView: UICollectionView!
    
    /// 이미지 선택 버튼
    @IBOutlet weak var imageSelectButton: UIBarButtonItem!
    
    /// 앨범 표시 화면 닫기 버튼
    @IBOutlet weak var closeVCButton: UIBarButtonItem!
    
    /// 편집버튼
    /// 제한된 사진을 변경할 수 있습니다.
    @IBOutlet weak var editBtn: UIBarButtonItem!
    
    /// 이미지 관리 객체
    let imageManager = PHImageManager()
    
    /// 이미지 옵션
    /// - Author: 남정은(dlsl7080@gmail.com)
    lazy var imageOption: PHImageRequestOptions = {
        let option = PHImageRequestOptions()
        option.deliveryMode = PHImageRequestOptionsDeliveryMode.fastFormat
        return option
    }()
    
    /// Fetch한 사진 저장
    var allPhotos: PHFetchResult<PHAsset> = {
        let option = PHFetchOptions()
        
        let sortByDateAsc = NSSortDescriptor(key: "creationDate", ascending: true)
        option.sortDescriptors = [sortByDateAsc]
        
        return PHAsset.fetchAssets(with: option)
    }()
    
    /// 제한된 접근권한 확인
    var hasLimitedPermission = false
    
    
    /// 접근 가능한 사진을 변경합니다.
    /// - Parameter sender: SelectImageViewController
    /// - Author: 김정민(kimjm010@icloud.com)
    @IBAction func editSelectedImage(_ sender: Any) {
        PHPhotoLibrary.shared().presentLimitedLibraryPicker(from: self)
    }
    
    
    /// 사진에 접근하기 위한 권한 요청합니다.
    /// - Author: 김정민(kimjm010@icloud.com)
    func requestAuthorization() {
        let status: PHAuthorizationStatus
        
        status = PHPhotoLibrary.authorizationStatus(for: .readWrite)
        hasLimitedPermission = status == .limited
        
        switch status {
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization(for: .readWrite) { [weak self] (selectedStatus) in
                switch selectedStatus {
                case .authorized, .limited:
                    DispatchQueue.main.async {
                        self?.editBtn.isEnabled = selectedStatus == .limited
                    }
                    self?.hasLimitedPermission = selectedStatus == .limited
                    break
                default:
                    self?.alertToAccessPhotoLibrary()
                    break
                }
            }
        case .denied:
            alertToAccessPhotoLibrary()
            break
        case .restricted:
            alertToAccessPhotoLibrary()
            break
        case .limited:
            self.editBtn.isEnabled = true
        case .authorized:
            self.editBtn.isEnabled = false
        default:
            break
        }
    }
    
    
    /// 뷰 컨트롤러의 뷰 계층이 메모리에 올라간 뒤 호출됩니다.
    /// - Author: 김정민(kimjm010@icloud.com)
    override func viewDidLoad() {
        super.viewDidLoad()
        
        requestAuthorization()
        imageCollectionView.allowsSelection = true
        imageCollectionView.allowsMultipleSelection = true
        
        // 앨범 화면을 닫습니다.
        // - Author: 김정민(kimjm010@icloud.com)
        closeVCButton.rx.tap
            .subscribe(onNext: { [unowned self] in
                self.dismiss(animated: true, completion: nil)
            })
            .disposed(by: rx.disposeBag)
        
        
        // 게시글에 첨부할 이미지를 선택합니다.
        // - Author: 김정민(kimjm010@icloud.com), 남정은(dlsl7080@gamil.com)
        imageSelectButton.rx.tap
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [unowned self] in
                guard let indexPath = imageCollectionView.indexPathsForSelectedItems else { return }
                
                for index in indexPath {
                    let target = allPhotos.object(at: index.item)
                    
                    imageManager.requestImage(for: target,targetSize: PHImageManagerMaximumSize,
                                                 contentMode: .aspectFill,
                                                 options: nil) { (image, _) in
                        if let image = image {
                            NotificationCenter.default.post(name: .imageDidSelect, object: nil, userInfo: ["img": [image]])
                            
                            NotificationCenter.default.post(name: .requestPostImage, object: nil, userInfo: ["image": image])
                        }
                        
                        self.dismiss(animated: true, completion: nil)
                    }
                }
            })
            .disposed(by: rx.disposeBag)
        
        PHPhotoLibrary.shared().register(self)
    }
    
    deinit {
        PHPhotoLibrary.shared().unregisterChangeObserver(self)
    }
}




/// 첨부할 이미지 데이터 설정
/// - Author: 김정민(kimjm010@icloud.com)
extension SelectImageViewController: UICollectionViewDataSource {

    /// 접근 가능한 이미지 수를 리턴합니다.
    /// - Parameters:
    ///   - collectionView: imageCollectionView
    ///   - section: 하나의 섹션에 표시할 아이템의 수
    /// - Returns: Fetch된 사진의 수
    /// - Author: 김정민(kimjm010@icloud.com)
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return allPhotos.count
    }


    /// 이미지 표시를 위한 셀을 구성합니다.
    /// - Parameters:
    ///   - collectionView: imageCollectionView
    ///   - indexPath: image의 indexPath
    /// - Returns: imageCollectionView의 cell
    /// - Author: 김정민(kimjm010@icloud.com)
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




/// 이미지 컬렉션 뷰 셀의 레이아웃 조정
/// - Author: 김정민(kimjm010@icloud.com)
extension SelectImageViewController: UICollectionViewDelegateFlowLayout {
    
    /// 이미지 셀의 사이즈를 설정합니다.
    /// - Parameters:
    ///   - collectionView: imageCollectionView
    ///   - collectionViewLayout: 컬렉션뷰의 레이아웃
    ///   - indexPath: 컬렉션뷰 아이템의 인덱스패스
    /// - Returns: 화면에 4개의 이미지가 표시될 수 있습니다.
    /// - Author: 김정민(kimjm010@icloud.com)
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
    
    /// photoLibrary애 변화가 있을 경우 호출됩니다.
    /// - Parameter changeInstance: 변경 사항을 나타내는 객체
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

