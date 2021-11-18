//
//  TimetableSingleResponse.swift
//  UMate
//
//  Created by 안상희 on 2021/11/18.
//

import Foundation

/// 시간표 등록 후 Response 받는 모델
struct TimetablePostResponse: Codable {
    let timetableId: Int
    let code: Int
    let message: String?
}
