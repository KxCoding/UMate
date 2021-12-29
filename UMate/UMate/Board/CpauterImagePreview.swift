//
//  CpauterImagePreview.swift
//  UMate
//
//  Created by Chris Kim on 2021/12/28.
//

import UIKit
import Photos


/// 캡쳐 카메라 프리뷰 화면
/// - Author: 김정민(kimjm010@icloud.com)
class PreviewView: UIView {
    
    /// 캡쳐한 이미지를 표시하는 클래스
    override class var layerClass: AnyClass {
        return AVCaptureVideoPreviewLayer.self
    }
    
    /// 미리보기 레이어
    var videoPreviewLayer: AVCaptureVideoPreviewLayer {
        return layer as! AVCaptureVideoPreviewLayer
    }
}
