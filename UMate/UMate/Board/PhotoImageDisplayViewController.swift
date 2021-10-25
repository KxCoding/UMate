//
//  PhotoImageDisplayViewController.swift
//  UMate
//
//  Created by Chris Kim on 2021/09/30.
//

import UIKit


/// 캡쳐한 사진 표시 화면
/// - Author: 김정민(kimjm010@icloud.com)
class PhotoImageDisplayViewController: UIViewController {

    /// 캡쳐한 사진을 표시할 이미지뷰
    @IBOutlet weak var photoImageView: UIImageView!
    
    /// 오버레이 뷰
    @IBOutlet var overlayView: UIView!
    
    /// 카메라 Flash Mode
    @IBOutlet weak var flashModeBtn: UIButton!
    
    /// 카메라 교체 버튼
    @IBOutlet weak var cameraSwitchBtn: UIButton!
    
    /// 캡쳐한 이미지 및 사용자 앨범의 이미지 관리 객체
    var customPicker: UIImagePickerController?
    
    
    /// Camera FlashMode를 변경합니다.
    @IBAction func changeFlashMode(_ sender: Any) {
        
        guard let picker = customPicker else { return }
        
        let current = picker.cameraFlashMode.rawValue
        let next = UIImagePickerController.CameraFlashMode(rawValue: current + 1) ?? .off
        picker.cameraFlashMode = next
        
        flashModeBtn.setTitle("\(next)", for: .normal)
    }
    
    
    /// CameraMode를 변경합니다.
    @IBAction func switchCamera(_ sender: Any) {
        switch customPicker?.cameraDevice {
        case .rear:
            customPicker?.cameraDevice = .front
        case .front:
            customPicker?.cameraDevice = .rear
        default:
            return
        }
    }
    
    
    /// 캡쳐를 취소합니다.
    /// - Parameter sender: 취소 Button
    @IBAction func done(_ sender: Any) {
        customPicker?.dismiss(animated: true, completion: nil)
    }
    
    
    /// 카메라로 촬영합니다.
    /// - Parameter sender: 촬영 Button
    @IBAction func takePhoto(_ sender: Any) {
        customPicker?.takePicture()
    }
    
    
    /// 재촬영을 위해 카메라 화면을 표시합니다.
    /// - Parameter sender: 다시 찍기 Button
    @IBAction func presentCamera(_ sender: Any) {
        setCamera()
    }
    
    
    /// 캡쳐한 사진을 첨부합니다.
    /// - Parameter sender: 사진 사용 Button
    @IBAction func addCapturedPhoto(_ sender: Any) {

        guard let capturedImage = photoImageView.image else { return }
        
        NotificationCenter.default.post(name: .newImageCaptured,
                                        object: nil,
                                        userInfo: ["img": capturedImage])
        
        dismiss(animated: true, completion: nil)
    }
    
    
    /// 캡쳐한 이미지 사용을 취소합니다.
    /// - Parameter sender: Cancel Button
    @IBAction func closeVC(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    /// 카메라의 상태를 설정합니다.
    func setCamera() {
        guard UIImagePickerController.isCameraDeviceAvailable(.rear) else { return }
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else { return }
        
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.cameraCaptureMode = .photo
        picker.delegate = self
        picker.allowsEditing = false
        picker.showsCameraControls = false
        
        overlayView.frame = view.bounds
        picker.cameraOverlayView = overlayView
        picker.cameraViewTransform = CGAffineTransform(translationX: 0, y: view.bounds.height / 5)
        flashModeBtn.setTitle("\(picker.cameraFlashMode)", for: .normal)
        
        customPicker = picker
        present(picker, animated: true, completion: nil)
    }
    
    
    /// 뷰가 메모리에 로드되었을 때 데이터 또는 UI를 초기화합니다.
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setCamera()
        
        cameraSwitchBtn.setTitle("", for: .normal)
        
        customPicker?.showsCameraControls = false
        
        flashModeBtn.isHidden = !UIImagePickerController.isFlashAvailable(for: .rear)
        cameraSwitchBtn.isHidden = !UIImagePickerController.isCameraDeviceAvailable(.front)
        
        // 캡쳐한 이미지를 게시글 작성 뷰컨트롤러의 이미지뷰에 표시합니다.
        NotificationCenter.default.addObserver(forName: .imagehasCaptured,
                                               object: nil,
                                               queue: .main) { [weak self] noti in
            guard let self = self else { return }
            
            if let image = noti.userInfo?["image"] as? UIImage {
                self.photoImageView.image = image
            }
        }
    }
}




/// 캡쳐후의 작업을 지정
/// - Author: 김정민(kimjm010@icloud.com)
extension PhotoImageDisplayViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    /// 캡쳐 작업이 끝난경우 화면을 닫습니다.
    /// - Parameter picker: ImagePicker를 관리하는 객체
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    
    /// 이미지를 선택한 경우 이미지뷰에 선택한 이미지를 표시합니다.
    /// - Parameters:
    ///   - picker: ImagePicker를 관리하는 객체
    ///   - info: 촬영한 이미지 및 수정된 이미지
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[.originalImage] as? UIImage {
            photoImageView.image = image
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
}




/// Camera FlashMode에 따라 표시할 레이블
/// - Author: 김정민(kimjm010@icloud.com)
extension UIImagePickerController.CameraFlashMode: CustomStringConvertible {
    public var description: String {
        switch self {
        case .off:
            return "Off"
        case .on:
            return "On"
        case .auto:
            return "auto"
        default:
            return "Off"
        }
    }
}
