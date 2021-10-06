//
//  BlobDataManager.swift
//  UMate
//
//  Created by 황신택 on 2021/10/06.
//

import Foundation
import AZSClient
import UIKit

/// 파일 업로드에서 발생하는 에러
/// Author: 황신택(sinadsl1457@gmail.com)
enum BlobError: Error {
    /// 알 수 없는 에러가 발생했을 때 전달되는 에러
    case unKnown
}

/// 파일 업로드/다운로드를 담당하는 싱글톤 매니저
struct BlobManger {
    /// 저장소 계정
    private let account: AZSCloudStorageAccount?
    
    /// 저장소 클라이언트
    private let client: AZSCloudBlobClient?
    
    /// 파일이 저장되는 컨테이너
    private let container: AZSCloudBlobContainer?
    
    /// 싱글톤 인스턴스
    static let shared = BlobManger()
    
    /// 스토리지 계정 초기화
    /// test 컨테이너에 접근할 수 있도록 초기화 합니다.
    private init() {
        account = try? AZSCloudStorageAccount(fromConnectionString: conStr)
        client = account?.getBlobClient()
        container = client?.containerReference(fromName: "taek")
    }
    
}
