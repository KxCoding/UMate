//
//  PlaceResponse.swift
//  UMate
//
//  Created by Effie on 2021/11/23.
//

import Foundation
import UIKit
import RxSwift


/// Place 전용 응답 데이터 타입
/// - Author: 박혜정(mailmelater11@gmail.com)
protocol PlaceResponseType: Codable {
    associatedtype ResponseSelf

    var code: Int { get set }
    var message: String? { get set }
    var clientAlertMessage: String? { get set }

    static func parse(data: Data, vc: UIViewController) -> ResponseSelf?
}


extension PlaceResponseType where ResponseSelf: PlaceResponseType {

    /// 데이터를 알맞은 형식으로 파싱합니다.
    ///
    /// 파싱 결과애 따라 네트워크 경고창을 표시합니다.
    /// - Parameters:
    ///   - data: 파싱할 데이터
    ///   - vc: 경고창을 표시할 view controller
    /// - Returns: 결과 형식. PlaceResponseType을 채용한 타입의 인스턴스입니다.
    static func parse(data: Data, vc: UIViewController) -> ResponseSelf? {
        var response: ResponseSelf?

        let decoder = JSONDecoder()

        do {
            let resultResponse = try decoder.decode(ResponseSelf.self, from: data)
            if resultResponse.code == ResultCode.ok.rawValue {
                response = resultResponse
            } else {
                vc.alertNetworkError(message: resultResponse.clientAlertMessage) { _ in
                    vc.dismiss(animated: true, completion: nil)
                }
                response = nil
            }
        } catch {
            vc.alertNetworkError(message: "유효하지 않은 데이터 형식입니다") { _ in
                vc.dismiss(animated: true)
            }

            #if DEBUG
            print("파싱 에러")
            #endif
            
            response = nil
        }

        return response
    }
}


/// Place 전용 공통 응답 데이터
/// - Author: 박혜정(mailmelater11@gmail.com)
struct PlaceCommonResponse: PlaceResponseType {
    typealias ResponseSelf = Self

    var code: Int
    var message: String?
    var clientAlertMessage: String?
}



/// 상점 목록 응답 데이터
/// - Author: 박혜정(mailmelater11@gmail.com)
struct PlaceListResponse: PlaceResponseType {
    typealias ResponseSelf = Self

    var code: Int
    var message: String?
    var clientAlertMessage: String?

    let university: UniversityPlaceMainDto?
    let totalCount: Int
    let places: [PlaceSimpleDto]?
}



/// 상점 상제 정보 응답 데이터
/// - Author: 박혜정(mailmelater11@gmail.com)
struct PlaceResponse: PlaceResponseType {
    typealias ResponseSelf = Self

    var code: Int
    var message: String?
    var clientAlertMessage: String?

    let place: PlaceDto?
}



/// 상점 북마크 목록 응답 데이터
/// - Author: 박혜정(mailmelater11@gmail.com)
struct PlaceBookmarkListResponse: PlaceResponseType {
    typealias ResponseSelf = Self

    var code: Int
    var message: String?
    var clientAlertMessage: String?

    let userId: String
    let totalCount: Int
    let places: [PlaceSimpleDto]
}



/// 상점 북마크 확인 응답 데이터
/// - Author: 박혜정(mailmelater11@gmail.com)
struct PlaceBookmarkCheckResponse: PlaceResponseType {
    typealias ResponseSelf = Self

    var code: Int
    var message: String?
    var clientAlertMessage: String?

    let userId: String
    let placeName: String
    let isBookmarked: Bool
}
