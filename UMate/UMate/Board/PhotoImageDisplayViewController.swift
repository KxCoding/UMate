//
//  PhotoImageDisplayViewController.swift
//  UMate
//
//  Created by Chris Kim on 2021/09/30.
//

import UIKit


/// 캡쳐한 사진을 보여주는 클래스
/// - Author: 김정민(kimjm010@icloud.com)
class PhotoImageDisplayViewController: UIViewController {

    /// 켭쳐한 사진을 표시할 이미지뷰
    /// - Author: 김정민(kimjm010@icloud.com)
    @IBOutlet weak var photoImageView: UIImageView!
    
    /// - Author: 김정민(kimjm010@icloud.com)
    @IBOutlet var overlayView: UIView!
    
    /// 카메라 Falash Mode 속성
    /// - Author: 김정민(kimjm010@icloud.com)
    @IBOutlet weak var flashModeBtn: UIButton!
    
    /// 카메라 스위치 속성
    /// - Author: 김정민(kimjm010@icloud.com)
    @IBOutlet weak var cameraSwitchBtn: UIButton!
    
    /// 캡쳐에 필요한 뷰 컨틀롤러
    /// - Author: 김정민(kimjm010@icloud.com)
    var customPicker: UIImagePickerController?
    
    /// 캡쳐 종료 후 ComposeViewController로 돌아가기위한 속성
    /// - Author: 김정민(kimjm010@icloud.com)
    let vc = ComposeViewController()
    
    
    /// Camera FlashMode를 변경합니다.
    /// - Author: 김정민(kimjm010@icloud.com)
    @IBAction func changeFlashMode(_ sender: Any) {
        
        guard let picker = customPicker else { return }
        
        let current = picker.cameraFlashMode.rawValue
        let next = UIImagePickerController.CameraFlashMode(rawValue: current + 1) ?? .off
        picker.cameraFlashMode = next
        
        flashModeBtn.setTitle("\(next)", for: .normal)
    }
    
    
    /// CameraMode를 변경합니다.
    /// - Author: 김정민(kimjm010@icloud.com)
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
    
    
    /// 캡쳐 취소 메소드
    /// - Author: 김정민(kimjm010@icloud.com)
    @IBAction func done(_ sender: Any) {
        customPicker?.dismiss(animated: true, completion: {
            self.present(self.vc, animated: true, completion: nil)
        })
    }
    
    
    /// 캡쳐를 합니다.
    /// - Author: 김정민(kimjm010@icloud.com)
    @IBAction func takePhoto(_ sender: Any) {
        customPicker?.takePicture()
    }
    
    
    /// 캡쳐를 위한 카메라를 표시합니다.
    /// - Author: 김정민(kimjm010@icloud.com)
    @IBAction func presentCamera(_ sender: Any) {
        setCamera()
    }
    
    
    /// 캡쳐한 사진을 게시글에 첨부합니다.
    /// - Author: 김정민(kimjm010@icloud.com)
    @IBAction func addCapturedPhoto(_ sender: Any) {

        guard let capturedImage = photoImageView.image else { return }
        
        NotificationCenter.default.post(name: .newImageCaptured, object: nil, userInfo: ["img": capturedImage])
        dismiss(animated: true) {
            self.present(self.vc, animated: true, completion: nil)
        }
    }
    
    
    /// 캡쳐한 이미지 사용을 취소
    @IBAction func closeVC(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    /// 초기 카메라를 셋팅하는 메소드입니다.
    /// - Author: 김정민(kimjm010@icloud.com)
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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setCamera()
        
        cameraSwitchBtn.setTitle("", for: .normal)
        
        customPicker?.showsCameraControls = false
        
        flashModeBtn.isHidden = !UIImagePickerController.isFlashAvailable(for: .rear)
        cameraSwitchBtn.isHidden = !UIImagePickerController.isCameraDeviceAvailable(.front)
        
        // 캡쳐한 이미지를 이미지뷰에 표시합니다.
        NotificationCenter.default.addObserver(forName: .imagehasCaptured, object: nil, queue: .main) { [weak self] noti in
            guard let self = self else { return }
            
            if let image = noti.userInfo?["image"] as? UIImage {
                self.photoImageView.image = image
            }
        }
    }
}




///
extension PhotoImageDisplayViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    /// 캡쳐 작업이 끝난경우 호출되는 메소드입니다.
    /// - Author: 김정민(kimjm010@icloud.com)
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    
    /// 이미지를 선택한 경우 이미지뷰에 선택한 이미지를 표시합니다.
    /// - Author: 김정민(kimjm010@icloud.com)
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
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
