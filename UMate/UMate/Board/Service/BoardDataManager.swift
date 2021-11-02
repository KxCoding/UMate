//
//  BoardDataManager.swift
//  UMate
//
//  Created by 남정은 on 2021/11/02.
//

import Foundation
import UIKit


/// 게시판에 사용되는 데이터 관리
/// - Author: 남정은(dlsl7080@gmail.com)
class BoardDataManager {
    
    static let shared = BoardDataManager()
    private init() { }
    
    
    /// URL을 Data로 변환하여 이미지를 얻습니다.
    /// - Parameter urlString: url주소 문자
    /// - Returns: 이미지
    /// - Author: 남정은(dlsl7080@gmail.com)
    func getImage(urlString: String) -> UIImage? {
        if let url = URL(string: urlString),
           let data = try? Data(contentsOf: url),
           let image = UIImage(data: data) {
            
            return image
        }
        return nil
    }
}
