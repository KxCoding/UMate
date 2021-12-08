//
//  CommonTableViewCell.swift
//  UMate
//
//  Created by 황신택 on 2021/10/26.
//

import UIKit
import RxSwift
import RxCocoa

/// 공통되는 기능을 포함한 테이블 뷰 셀
/// - Author: 황신택(sinadsl1457@gamil.com)
class CommonTableViewCell: UITableViewCell {
    /// 이미지 캐시
    let cache = NSCache<NSURL, UIImage>()
    
    let backgroundScheduler = ConcurrentDispatchQueueScheduler(queue: DispatchQueue.global())
}
