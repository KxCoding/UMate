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
    
    @IBOutlet weak var imageCollectionView: UICollectionView!
    @IBOutlet weak var editBtn: UIBarButtonItem!
    @IBOutlet weak var imageSelectBtn: UIBarButtonItem!
    
    
    var imageList = [UIImage]()
    let imageManager = PHImageManager()
    
    
    
    /// <#Description#>
    /// - Parameter sender: <#sender description#>
    @IBAction func closeVC(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    
    /// <#Description#>
    /// - Parameter sender: <#sender description#>
    @IBAction func editBtn(_ sender: Any) {
        PHPhotoLibrary.shared().presentLimitedLibraryPicker(from: self)
    }
    
    
    /// <#Description#>
    /// - Parameters:
    ///   - editing: <#editing description#>
    ///   - animated: <#animated description#>
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        
        imageCollectionView.isEditing = editing
        imageCollectionView.reloadItems(at: imageCollectionView.indexPathsForVisibleItems)
        
        if !editing {
            imageCollectionView.indexPathsForSelectedItems?.forEach({ (indexPath) in
                print(#function)
                imageCollectionView.deselectItem(at: indexPath, animated: true)
            })
        }
        
        updateUserInterface()
    }
    
    
    /// <#Description#>
    /// - Parameter sender: <#sender description#>
    @IBAction func toggleSelectionMode(_ sender: Any) {
        setEditing(!isEditing, animated: true)    }
    
    
    /// <#Description#>
    func updateUserInterface() {
        imageSelectBtn.title = isEditing ? "Done" : "Select"
    }
    
    
    
    // 제한된 사진에 접근할 수 있는 권한이 있는지를 확인하는 속성
    var hasLimitedPermission = false
    
    //
    var allPhotos: PHFetchResult<PHAsset> = {
        let option = PHFetchOptions()
        
        let sortByDateAsc = NSSortDescriptor(key: "creationDate", ascending: true)
        option.sortDescriptors = [sortByDateAsc]
        
        return PHAsset.fetchAssets(with: option)
    }()
    
    
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
        imageCollectionView.allowsMultipleSelection = false
        imageCollectionView.allowsSelectionDuringEditing = true
        setEditing(false, animated: false)
        updateUserInterface()
        
        PHPhotoLibrary.shared().register(self)
    }
    
    deinit {
        PHPhotoLibrary.shared().unregisterChangeObserver(self)
    }
}




extension SelectImageViewController: UICollectionViewDataSource {
    
    /// <#Description#>
    /// - Parameters:
    ///   - collectionView: <#collectionView description#>
    ///   - section: <#section description#>
    /// - Returns: <#description#>
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if hasLimitedPermission {
            return allPhotos.count + 1
        }
        
        return allPhotos.count
    }
    
    
    /// <#Description#>
    /// - Parameters:
    ///   - collectionView: <#collectionView description#>
    ///   - indexPath: <#indexPath description#>
    /// - Returns: <#description#>
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.item == 0 && hasLimitedPermission {
            return collectionView.dequeueReusableCell(withReuseIdentifier: "MenuCollectionViewCell", for: indexPath)
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCollectionViewCell", for: indexPath)
            as! ImageCollectionViewCell
        
        let actualIndex = hasLimitedPermission ? indexPath.item - 1 : indexPath.item
        let target = allPhotos.object(at: actualIndex)
        let size = CGSize(width: collectionView.frame.width / 4, height: collectionView.frame.width / 4)
        
        imageManager.requestImage(for: target, targetSize: size, contentMode: .aspectFill, options: nil)
        { image, _ in
            cell.imageView.image = image
            cell.configure(with: self.isEditing)
        }
        
        return cell
    }
}




extension SelectImageViewController: UICollectionViewDelegateFlowLayout {
    
    
    /// <#Description#>
    /// - Parameters:
    ///   - collectionView: <#collectionView description#>
    ///   - collectionViewLayout: <#collectionViewLayout description#>
    ///   - indexPath: <#indexPath description#>
    /// - Returns: <#description#>
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width / 4, height: collectionView.frame.width / 4)
    }
}




extension SelectImageViewController: UICollectionViewDelegate {
    
    
    /// <#Description#>
    /// - Parameters:
    ///   - collectionView: <#collectionView description#>
    ///   - indexPath: <#indexPath description#>
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if indexPath.item == 0 && hasLimitedPermission {
            // TODO: 사진 액세스 허용 알림창
        } else {
            let actualIndex = hasLimitedPermission ? indexPath.item - 1 : indexPath.item
            let target = allPhotos.object(at: actualIndex)
            let size = CGSize(width: collectionView.frame.width / 4, height: collectionView.frame.width / 4)
            
            imageManager.requestImage(for: target, targetSize: size, contentMode: .aspectFill, options: nil) { image, _ in
                
                NotificationCenter.default.post(name: .imageDidSelect, object: nil, userInfo: ["img": [image]])
                
                self.dismiss(animated: true, completion: nil)
                
            }
        }
        
        if isEditing == false {
            imageCollectionView.deselectItem(at: indexPath, animated: true)
        }
    }
    
    
    
    /// <#Description#>
    /// - Parameters:
    ///   - collectionView: <#collectionView description#>
    ///   - indexPath: <#indexPath description#>
    /// - Returns: <#description#>
    func collectionView(_ collectionView: UICollectionView, shouldBeginMultipleSelectionInteractionAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    
    
    /// <#Description#>
    /// - Parameters:
    ///   - collectionView: <#collectionView description#>
    ///   - indexPath: <#indexPath description#>
    func collectionView(_ collectionView: UICollectionView, didBeginMultipleSelectionInteractionAt indexPath: IndexPath) {
        setEditing(true, animated: true)
    }
    
    
    
    /// <#Description#>
    /// - Parameter collectionView: <#collectionView description#>
    func collectionViewDidEndMultipleSelectionInteraction(_ collectionView: UICollectionView) {
        print(#function)
    }
}




extension SelectImageViewController: PHPhotoLibraryChangeObserver {
    
    
    /// <#Description#>
    /// - Parameter changeInstance: <#changeInstance description#>
    func photoLibraryDidChange(_ changeInstance: PHChange) {
        DispatchQueue.main.async {
            if let changes = changeInstance.changeDetails(for: self.allPhotos) {
                self.allPhotos = changes.fetchResultAfterChanges
                self.imageCollectionView.reloadData()
            }
        }
    }
}
