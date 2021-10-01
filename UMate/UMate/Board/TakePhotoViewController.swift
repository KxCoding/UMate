//
//  TakePhotoViewController.swift
//  UMate
//
//  Created by Chris Kim on 2021/09/30.
//

import UIKit
import AVFoundation


/// 캡쳐 시 카메라 화면을 표시하는 뷰 클래스
/// - Author: 김정민(kimjm010@icloud.com)
class previewView: UIView {
    
    /// 캡쳐한 이미지를 표시하는 클래스
    override class var layerClass: AnyClass {
        return AVCaptureVideoPreviewLayer.self
    }
    
    /// Capture한 이미지를 표시하는 속성
    var videoPreviewLayer: AVCaptureVideoPreviewLayer {
        return layer as! AVCaptureVideoPreviewLayer
    }
}




/// 아이폰 기본 카메라를 통한 캡쳐 클래스
/// - Author: 김정민(kimjm010@icloud.com)
class TakePhotoViewController: UIViewController {

    /// 카메라 화면을 표시하는 속성
    @IBOutlet weak var previewView: previewView!
    
    /// Camera FlashMode 속성
    @IBOutlet weak var flashModeBtn: UIButton!
    
    /// Camera Switch 속성
    @IBOutlet weak var cameraSwitchBtn: UIButton!
    
    /// 사진촬영 버튼
    @IBOutlet weak var takePhotoBtn: UIButton!
    
    /// 카메라 캡쳐 Activity를 관리하는 객체
    var captureSession = AVCaptureSession()
    
    /// captureSession에 데이터를 제공하는 속성
    var currentDeviceInput: AVCaptureDeviceInput?
    
    /// 캡쳐한 이미지 를 저장하는 속성
    var photoOutput = AVCapturePhotoOutput()
    
    /// 캡쳐한 이미지의 데이터
    var photoData: Data?
    
    /// 사진 캡쳐 요청에 사용할 기능 및 설정의 사양을 저장하는 속성
    var currentPhotoSetting: AVCapturePhotoSettings?
    
    /// FlashMode를 저장하는 속성
    /// 기본값은 Off입니다.
    var flashMode = AVCaptureDevice.FlashMode.off
    
    
    /// Camera FlashMode를 변경합니다.
    /// - Parameter sender: Camera FlashMode 버튼
    @IBAction func switchFlashMode(_ sender: Any) {
        let current = flashMode.rawValue % 3
        
        let next = AVCaptureDevice.FlashMode(rawValue: current + 1) ?? .off
        
        flashMode = next
        
        flashModeBtn.setImage(UIImage(named: "cameraFlash_Off"), for: .normal)
    }
    
    
    /// Camera 전면 또는 후면으로 변경합니다.
    /// - Parameter sender: Camera Switch 버튼
    @IBAction func switchCamera(_ sender: Any) {
        
        guard let currentDeviceInput = currentDeviceInput else {
            return
        }
        
        // 현재 카메라의를 저장(.rear or .front)
        let currentCameraPosition = currentDeviceInput.device.position
        
        let backDeviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera, .builtInDualWideCamera, .builtInDualCamera], mediaType: .video, position: .back)
        
        let frontDeviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera, .builtInDualWideCamera, .builtInDualCamera], mediaType: .video, position: .front)
        
        var newCamera: AVCaptureDevice? = nil
        
        switch currentCameraPosition {
        case .unspecified, .front:
            newCamera = backDeviceDiscoverySession.devices.first
        case .back:
            newCamera = frontDeviceDiscoverySession.devices.first
        default:
            break
        }
        
        if let newCamera = newCamera {
            do {
                captureSession.beginConfiguration()
                captureSession.removeInput(currentDeviceInput)
                
                let deviceInput = try AVCaptureDeviceInput(device: newCamera)
                if captureSession.canAddInput(deviceInput) {
                    captureSession.addInput(deviceInput)
                    self.currentDeviceInput = deviceInput
                } else {
                    captureSession.addInput(currentDeviceInput)
                }
                
                captureSession.commitConfiguration()
            } catch {
                // TODO: 에러 처리하기
            }
        }
    }
    
    
    /// 사진 촬영을 시작합니다.
    /// - Parameter sender: TakePhoto 버튼
    @IBAction func takePhoto(_ sender: Any) {
        
        // 캡쳐한 이미지의 설정을 저장하는 속성
        let photoSetting: AVCapturePhotoSettings
        
        if photoOutput.availablePhotoCodecTypes.contains(.hevc) {
            photoSetting = AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.hevc])
        } else {
            photoSetting = AVCapturePhotoSettings()
        }
        
        photoSetting.flashMode = flashMode
        
        // 캡쳐한 이미지에 설정한 값을 반영
        photoOutput.capturePhoto(with: photoSetting, delegate: self)
        photoData = nil
        currentPhotoSetting = photoSetting
    }
    
    
    /// 촬영하는 화면을 닫고 게시글 작성화면으로 이동합니다
    @IBAction func closeVC(_ sender: Any) {
        stopCaptureSession()
        dismiss(animated: true, completion: nil)
    }
    
    
    /// 카메라에 접근하기 위해 권한을 요청합니다.
    func requestAuthorization() {
        AVCaptureDevice.requestAccess(for: .video) { granted in
            if granted {
                DispatchQueue.main.async {
                    self.startCaptureSession()
                }
            } else {
                // TODO: 경고창 표시할 것. 설정에서 변경할 수 있도록 할 것
            }
        }
    }
    
    
    /// 디바이스의 카메라를 확인합니다.
    func detectCameraDevice() -> AVCaptureDevice? {
        if let device = AVCaptureDevice.default(.builtInDualCamera, for: .video, position: .back) {
            return device
        } else if let device = AVCaptureDevice.default(.builtInDualWideCamera, for: .video, position: .back) {
            return device
        } else if let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) {
            return device
        }
        
        return nil
    }
    
    
    /// captureSession의 작업을 시작합니다.
    func startCaptureSession() {
        
        // captureSession이 변경되는 것을 알립니다.
        captureSession.beginConfiguration()
        
        // startCaptureSession의 모든 작업을 마친 후 마지막에 호출
        defer {
            captureSession.commitConfiguration()
            captureSession.startRunning()
        }
        
        guard let device = detectCameraDevice() else {
            captureSession.commitConfiguration()
            return
        }
        
        guard let input = try? AVCaptureDeviceInput(device: device) else {
            captureSession.commitConfiguration()
            return
        }
        
        currentDeviceInput = input
        
        flashModeBtn.isHidden = !input.device.isFlashAvailable
        
        guard captureSession.canAddInput(input) else {
            captureSession.commitConfiguration()
            return
        }
        
        captureSession.addInput(input)
        
        guard captureSession.canAddOutput(photoOutput) else {
            captureSession.commitConfiguration()
            return
        }
        
        captureSession.sessionPreset = .photo
        captureSession.addOutput(photoOutput)
        
        previewView.videoPreviewLayer.session = captureSession
        // 캡쳐한 이미지의 aspect ratio를 설정
        previewView.videoPreviewLayer.videoGravity = .resizeAspectFill
        
        captureSession.commitConfiguration()
        captureSession.startRunning()
    }
        
    
    /// captureSession의 작업을 중지합니다.
    func stopCaptureSession() {
        captureSession.stopRunning()
    }
    
    
    /// 카메라에 접근할 수 있는 권한을 확인합니다.
    func checkAuthorization() {
        let status = AVCaptureDevice.authorizationStatus(for: .video)
        
        switch status {
        case .notDetermined:
            requestAuthorization()
        case .restricted:
            // TODO: 경고창 표시할 것. 설정에서 변경할 수 있도록 할 것
            break
        case .denied:
            // TODO: 경고창 표시할 것. 설정에서 변경할 수 있도록 할 것
            break
        case .authorized:
            startCaptureSession()
        default:
            break
        }
    }
    
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        checkAuthorization()
        
        cameraSwitchBtn.setTitle("", for: .normal)
    }
}




/// 캡쳐한 후의 이미지를 전달
/// - Author: 김정민(kimjm010@icloud.com)
extension TakePhotoViewController: AVCapturePhotoCaptureDelegate {
    
    /// 캡쳐한 이미지와 메타데이터를 전달합니다.
    /// - Parameters:
    ///   - output: 캡쳐한 이미지
    ///   - photo: 캡쳐한 이미지의 데이터
    ///   - error: 발생할 수 있는 error
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        
        guard let photoData = photo.fileDataRepresentation() else { return }
        guard let image = UIImage(data: photoData) else { return }
        
        NotificationCenter.default.post(Notification(name: .imagehasCaptured, object: nil, userInfo: ["image": image]))
        stopCaptureSession()
        dismiss(animated: true, completion: nil)
    }
}




/// Camera FlashMode의 상태에 따라 표시할 레이블
/// - Author: 김정민(kimjm010@icloud.com)
extension AVCaptureDevice.FlashMode {
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
