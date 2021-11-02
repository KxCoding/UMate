//
//  BlobManager.swift
//  UMate
//
//  Created by 남정은 on 2021/11/02.
//

import Foundation
import UIKit
import AZSClient


#warning("현재는 Blob삭제 상태입니다.")
let constr = "DefaultEndpointsProtocol=https;AccountName=boardimage1018;AccountKey=wNQrSSwm3M29lj9+mLoWRuZRZCSOh9KmQZm1A79+2Z7iNwZ6bCSiGloRXKOIUoI7vsdFU3LACKtQOurFkShAaw==;EndpointSuffix=core.windows.net"



/// 블랍 메니저
///
/// 이미지 데이터를 관리합니다.
///  - Author: 남정은(dlsl7080@gamil.com)
struct BlobManager {
    
    static let shared = BlobManager()
    
    private let account: AZSCloudStorageAccount?
    
    private let client: AZSCloudBlobClient?
    
    private let container: AZSCloudBlobContainer?
    
    
    /// 이미지 업로드를 위한 설정을 초기화 합니다.
    ///  - Author: 남정은(dlsl7080@gamil.com)
    private init() {
        account = try? AZSCloudStorageAccount(fromConnectionString: constr)
        client = account?.getBlobClient()
        container = client?.containerReference(fromName: "images")
        
        upload(image: UIImage()) { finished, id in
            
        }
    }
    
    
    /// 블랍 컨테이너에 이미지를 업로드 합니다.
    /// - Parameters:
    ///   - image: 업로드할 이미지
    ///   - completion: 이미지 업로드 이후 실행할 작업
    ///  - Author: 남정은(dlsl7080@gamil.com)
    func upload(image: UIImage, completion: @escaping (Bool, String) -> ()) {
        guard let data = image.pngData() else { return }
        let id = UUID().uuidString + ".png"
        
        let blob = container?.blockBlobReference(fromName: id.lowercased())
        blob?.upload(from: data, completionHandler: { error in
            DispatchQueue.main.async {
                if let _ = error {
                    completion(false, id)
                    return
                }
                
                completion(true, id)
            }
        })
    }
}
