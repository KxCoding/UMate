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
    
    /// 데이터 엔코더
    let encoder = JSONEncoder()
    
    /// 날짜 파싱 포매터
    let postDateFormatter: ISO8601DateFormatter = {
       let f = ISO8601DateFormatter()
        f.formatOptions = [.withFullDate, .withTime, .withDashSeparatorInDate, .withColonSeparatorInTime]
        return f
    }()
    
    /// 서버 날짜를 Date로 변환할 때 사용
    let decodingFormatter: DateFormatter = {
       let f = DateFormatter()
        f.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        f.calendar = Calendar(identifier: .iso8601)
        f.timeZone = TimeZone(secondsFromGMT: 0)
        f.locale = Locale(identifier: "en_US_POSIX")
        
        return f
    }()
    
    /// 서버 요청 API
    let session = URLSession.shared
 
    /// 캐시 생성
    let cache = NSCache<NSURL,UIImage>()
    
    
    /// 캐시에서 이미지를 불러오거나 이미지를 새로 다운로드 합니다.
    /// - Parameters:
    ///   - urlString: 이미지를 다운할 urlString
    ///   - completion: 완료블록
    ///   - Author: 남정은(dlsl7080@gmail.com)
    func downloadImage(from urlString: String, completion: @escaping (UIImage?) -> ()) {
        guard let url = NSURL(string: urlString) else {
            DispatchQueue.main.async {
                completion(nil)
            }
            return
        }
        if let image = cache.object(forKey: url) { //url이 만들어졌다면 캐시에서 그에 해당하는 이미지를 가져옴.
            DispatchQueue.main.async {
                completion(image) //성공하면 메인쓰레드에 image를 전달함.
            }
        // 캐시에 이미지가 없다면 새로 다운로드
        } else {
            DispatchQueue.global().async {
                guard let data = try? Data(contentsOf: url as URL) else {
                    DispatchQueue.main.async {
                        completion(nil)
                    }
                    return
                }
                
                guard let image = UIImage(data: data) else {
                    DispatchQueue.main.async {
                        completion(nil)
                    }
                    return
                }
                self.cache.setObject(image, forKey: url)
                
                DispatchQueue.main.async {
                    completion(image)
                }
            }
        }
    }
    
    
    /// UIImage 사이즈를 조절합니다.
    /// - Parameters:
    ///   - image: 이미지
    ///   - targetSize: 원하는 사이즈
    /// - Returns: 사이즈가 바뀐 이미지
    /// - Author: 남정은(dlsl7080@gmail.com)
    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size
        
        let widthRatio  = targetSize.width  / size.width// 원하는 사이즈와 원래사이즈의 배율 계산
        let heightRatio = targetSize.height / size.height
        
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        }
        
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        // 비트맵을 기반으로 이미지 생성
        UIGraphicsBeginImageContextWithOptions(newSize, true, 1.0)
        
        // 지정한 사이즈에 이미지 그리기
        image.draw(in: rect)
        
        // 이미지 생성 완료
        guard let newImage = UIGraphicsGetImageFromCurrentImageContext() else { return UIImage() }
        
        // 컨텍스트를 삭제
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
    
    /// 댓글 좋아요를 삭제합니다.
    /// - Parameter likeCommentId: 댓글 좋아요 Id
    /// - Author: 남정은(dlsl7080@gmail.com)
    func deleteLikeComment(likeCommentId: Int, completion: @escaping (Bool) -> ()) {
        guard let url = URL(string: "https://board1104.azurewebsites.net/api/likeComment/\(likeCommentId)") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        
        self.session.dataTask(with: request) { data, response, error in
            if let error = error {
                print(error)
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                return
            }
            
            guard let data = data else {
                return
            }

            do {
                let decoder = JSONDecoder()
                let res = try decoder.decode(CommonResponse.self, from: data)
                
                if res.resultCode == ResultCode.ok.rawValue {
                    #if DEBUG
                    print("삭제 성공")
                    #endif
                    completion(true)
                } else {
                    #if DEBUG
                    print("삭제 실패")
                    #endif
                }
            } catch {
                print(error)
            }
        }.resume()
    }
}


