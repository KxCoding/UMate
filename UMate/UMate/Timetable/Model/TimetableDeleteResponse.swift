//
//  TimetableDeleteResponse.swift
//  UMate
//
//  Created by 안상희 on 2021/11/18.
//

import Foundation


/// 시간표 정보 삭제 DELETE 후 Response 받는 모델
struct TimetableDeleteResponse: Codable {
    let code: Int
    let message: String?
}
