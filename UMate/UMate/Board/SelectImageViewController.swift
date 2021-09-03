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

extension Notification.Name {
    static let imageDidSelect = Notification.Name(rawValue: "imageDidSelect")
}


class SelectImageViewController: UIViewController {
    
    // 게시글 작성 시 이미지 첨부를 위한 아울렛
    @IBOutlet weak var imageCollectionView: UICollectionView!
    @IBOutlet weak var editBtn: UIBarButtonItem!
    
    // 첨부한 이미지를 담을 속성
    var imageList = [UIImage]()
    // 이미지 fetch를 위한 속성
    let imageManager = PHImageManager()
    
    
    /// 이미지 첨부를 위한 ViewController를 닫는 메소드
    /// - Parameter sender: SelectImageViewController
    @IBAction func closeVC(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    /// 제한된 사진에 접근할 수 있는 경우, 제한 된 사진을 편집할 수 있는 메소드
    /// - Parameter sender: SelectImageViewController
    @IBAction func editSelectedImage(_ sender: Any) {
        PHPhotoLibrary.shared().presentLimitedLibraryPicker(from: self)
    }
    
    
    /// 게시글에 첨부할 이미지를 선택하는 메소드
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
    
    // 제한된 사진에 접근할 수 있는 권한이 있는지를 확인하는 속성
    var hasLimitedPermission = false
    
    // Fetch한 사진을 담을 속성
    var allPhotos: PHFetchResult<PHAsset> = {
        let option = PHFetchOptions()
        
        let sortByDateAsc = NSSortDescriptor(key: "creationDate", ascending: true)
        option.sortDescriptors = [sortByDateAsc]
        
        return PHAsset.fetchAssets(with: option)
    }()
    
    
    /// 사진에 접근하기 위한 권한 요청 메소드
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




extension SelectImageViewController: UICollectionViewDataSource {
    
    /// 사용자의 사진앱에 있는 이미지를 표시하기 위한 컬렉션뷰
    /// - Parameters:
    ///   - collectionView: collectionView
    ///   - section: 없음
    /// - Returns: Fetch된 사진의 갯수
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return allPhotos.count
    }
    
    
    /// 각 셀마다 이미지를 표시하기위한 메소드
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCollectionViewCell", for: indexPath)
            as! ImageCollectionViewCell
        let target = allPhotos.object(at: indexPath.item)
        let size = CGSize(width: collectionView.frame.width / 4, height: collectionView.frame.width / 4)
        
        imageManager.requestImage(for: target, targetSize: size, contentMode: .aspectFill, options: nil)
        { image, _ in
            cell.imageView.image = image
        }
        
        return cell
    }
}




extension SelectImageViewController: UICollectionViewDelegateFlowLayout {
    
    ///  Fetch된 이미지의 사이즈를 설정하기 위한 메소드
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width / 4, height: collectionView.frame.width / 4)
    }
}




extension SelectImageViewController: PHPhotoLibraryChangeObserver {
    
    /// PhotoLibrary 옵저버 제거를 위한 메소드
    func photoLibraryDidChange(_ changeInstance: PHChange) {
        DispatchQueue.main.async {
            if let changes = changeInstance.changeDetails(for: self.allPhotos) {
                self.allPhotos = changes.fetchResultAfterChanges
                self.imageCollectionView.reloadData()
            }
        }
    }
}
