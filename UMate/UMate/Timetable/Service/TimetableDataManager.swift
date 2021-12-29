//
//  TimetableDataManager.swift
//  UMate
//
//  Created by 안상희 on 2021/12/29.
//

import Elliotable
import Foundation
import RxSwift
import NSObject_Rx
import Moya


/// 시간표 데이터 관리
class TimetableDataManager {
    /// 싱글톤
    static let shared = TimetableDataManager()
    
    private init() { }
    
    /// DisposeBag
    let disposeBag = DisposeBag()
    
    /// 네트워크 서비스 객체
    let provider = MoyaProvider<TimetableService>()
    
    /// 시간표 강의 정보를 저장하는 리스트
    var lectureList: [ElliottEvent] = []
    
    /// 시간표 Delegate
    var timeTableDelegate: SendTimeTableDataDelegate?
}
