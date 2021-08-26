//
//  UIViewcontroller+View.swift
//  UIViewcontroller+View
//
//  Created by 남정은 on 2021/08/11.
//

import Foundation
import UIKit

extension UIViewController {
    
    /// UIImage를 얻을 때 사용합니다.
    /// navigationBar의 setBackgroundImage와 shadowImage의 커스텀 설정에 사용합니다.
    /// - Parameters:
    ///   - color: 원하는 색상을 배경색으로 전달합니다.
    ///   - size: 원하는 사이즈를 전달합니다.
    /// - Returns: 원하는 색상과 사이즈의 UIImage를 리턴합니다.
    func getImage(withColor color: UIColor, andSize size: CGSize) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        color.setFill()
        UIRectFill(rect)
        guard let image: UIImage = UIGraphicsGetImageFromCurrentImageContext() else { return UIImage() }
        return image
    }
}
