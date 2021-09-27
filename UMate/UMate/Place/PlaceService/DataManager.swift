//
//  DataManager.swift
//  UMate
//
//  Created by Effie on 2021/08/29.
//

import UIKit


/// 네트워크 요청을 통해 받은 데이터를 다루는 메소드를 포함하는 클래스
///
/// 이 클래스의 메소드는 단일 공유 객체를 통해 호출합니다.
/// - Author: 박혜정(mailmelater11@gmail.com)
class DataManager {
    
    // MARK: Properties
    
    /// singleton instance
    static let shared = DataManager()
    private init() { }
    
    // MARK: - Data
    
    /// 공유 URLSession 객체
    let session = URLSession.shared
    
    /// 전달된 URL로 요청을 실행하고, 요청 후 전달한 작업을 실행합니다.
    /// - Parameters:
    ///   - url: URL
    ///   - completion: 요청 이후에 실행할 작업
    func fetchData(with url: URL, completion: ((Data) -> ())?) {
        session.dataTask(with: url) { data, response, error in
            /// 에러 확인
            if let error = error {
                #if DEBUG
                print("datatask error", error)
                #endif
                return
            }
            
            /// 응답 코드 확인
            guard let httpResponse = response as? HTTPURLResponse,
                  httpResponse.statusCode == 200 else {
                #if DEBUG
                print((response as? HTTPURLResponse)?
                        .statusCode ?? "can't get status code")
                #endif
                return
            }
            
            /// 데이터 언래핑
            guard let data = data else {
                #if DEBUG
                print("data == nil ")
                #endif
                return
            }
            
            /// completion 실행
            if let completion = completion {
                DispatchQueue.main.async {
                    completion(data)
                }
            }
            
        }.resume()
    }
    
    
    /// 전달된 문자열로 URL을 생성해 요청을 실행하고, 요청 이후 전달한 handler 를 실행합니다.
    /// - Parameters:
    ///   - url: URL
    ///   - completion: 요청 이후에 실행할 작업
    func fetchData(with urlString: String, completion: ((Data) -> ())?){
        
        /// URL 생성
        guard let url = URL(string: urlString) else {
            #if DEBUG
            print("fail converting stirng to url")
            #endif
            return
        }
        
        fetchData(with: url, completion: completion)
    }
    
    
    // MARK: - JSON
    
    /// 커스텀 디코더
    private let jsonDecoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }()
    
    
    /// json 데이터를 원하는 데이터 객체로 디코딩하는 메소드
    /// - Parameters:
    ///   - type: 결과로 리턴받기 원하는 데이터 타입
    ///   - data: json 데이터
    /// - Returns: 디코딩에 성공하면 지정한 타입의 객체를 리턴, 실패하면 nil.
    func decodeJson<T>(type: T.Type, fromJson data: Data) -> T? where T: Codable {
        guard let result = try? jsonDecoder.decode(type, from: data) else {
            #if DEBUG
            print("fail parsiing json to given type")
            #endif
            
            return nil
        }
        return result
    }
    
    
    
    
    // MARK: - Image
    
    /// 이미지 캐시
    var imageCache = NSCache<NSURL, UIImage>()
    
    
    /// 주어진 url로부터 이미지를 가져와서 캐싱하는 메소드
    /// - Parameter url: url
    /// - Returns: 캐시에 저장된 이미지가 있거나 url로 해당 이미지를 가져올 수 있으면 이미지를 리턴, 실패하면 nil
    func getImage(from url: URL) -> UIImage? {
        
        var result: UIImage? = nil
        
        let nsUrl = url as NSURL
        
        /// 캐시에 이미지가 저장되었는지 확인
        if let image = imageCache.object(forKey: nsUrl) {
            result = image
        } else {
            /// 전달된 url 키로 캐싱된 이미지가 없다면
            #if DEBUG
            print("can't get data from cache")
            #endif
            
            /// 이미지 다운로드
            fetchData(with: url) { data in
                guard let image = UIImage(data: data) else {
                    print("cannot convert data to image")
                    return
                }
                
                /// 캐싱
                self.imageCache.setObject(image, forKey: nsUrl)
                
                /// 저장
                result = image
            }
        }
        
        return result
    }
    
    
    /// 주어진 문자열로 부터 url을 생성해 이미지를 가져오는 메소드
    /// - Parameter urlString: url 문자열
    /// - Returns: 캐시에 저장된 이미지가 있거나 url로 해당 이미지를 가져올 수 있으면 이미지를 리턴, 실패하면 nil
    func getImage(from urlString: String) -> UIImage? {
        
        guard let url = URL(string: urlString) else {
            return nil
        }
        
        return getImage(from: url)
    }
    
    
    
    /// 이미지를 요청하고, 전송된 이미지로 특정 작업을 수행하는 메소드
    /// - Parameters:
    ///   - url: URL
    ///   - completion: 이미지를 가지고 수행할 작업
    func fetchImage(with url: URL, completion: ((UIImage) -> ())?) {
        fetchData(with: url) { data in
            guard let image = UIImage(data: data) else {
                print("cannot convert data to image")
                return
            }
            
            if let completion = completion {
                completion(image)
            }
        }
    }
    
    
    // MARK: - Unsplash API
    
    /// Unsplash API 키
    ///
    /// Demo - 50 request / hour
    let unsplashKey = "RZoyv1JUGLzedP_O6q1OBthZTnne2ME7lwkE_gDZmOI"
    
    
    /// 특정 키워드의 이미지를 unsplash에 요청하고, 받은 이미지로 특정 작업을 수행하는 메소드
    /// - Parameters:
    ///   - query: 키워드(쿼리)
    ///   - completion: 이미지와 함께 실행할 작업
    func fetchUnsplashInfo(with query: String, completion: ((UnsplashImagesInfo) -> ())?) {
        
        /// URL 세팅
        let count = 1
        let orientation = "landscape"
        let urlString = "https://api.unsplash.com/photos/random?client_id=\(unsplashKey)&query=\(query)&count=\(count)&orientation=\(orientation)"
        
        guard let url = URL(string: urlString) else {
            #if DEBUG
            print("invalid api request url (Unsplash)")
            #endif
            return
        }
        
        fetchData(with: url) { [weak self] data in
            guard let self = self else { return }
            
            /// 전송된 data를 디코딩
            guard let imagesInfo = self.decodeJson(type: [UnsplashImagesInfo].self,
                                                   fromJson: data) else {
                #if DEBUG
                print("or maybe it's error invalid api key or query")
                #endif
                return
            }
            
            /// 첫번째 이미지를 언래핑
            guard let item = imagesInfo.first else {
                #if DEBUG
                print("no acual data in [UnsplashImagesInfo]")
                #endif
                return
            }
            
            if let completion = completion {
                completion(item)
            }
        }
        
    }
    
    
    // MARK: - Util Methods
    
    /// 주어진 문자열의 이름과 확장자를 가진 파일을  번들에서 찾아서 유효한 문자열이면 url을 제공하는 메소드
    /// - Parameter string: 찾는 리소스 파일의 문자열
    /// - Returns: 일치하는 리소스의 url
    func generateUrl(forFile string: String) -> URL? {
        
        let arr = string.components(separatedBy: ".")
        guard let fileName = arr.first,
              let extensionName = arr.last,
              fileName != extensionName else { return nil }
        
        guard let url = Bundle.main.url(forResource: fileName,
                                        withExtension: extensionName) else {
            #if DEBUG
            print("cannot find resource from bundle")
            #endif
            return nil
        }
        
        return url
    }
    
    
    /// 전달된 이름의 json 파일을 특정 타입으로 파싱하는 메소드
    /// - Parameters:
    ///   - type: 결과 타입
    ///   - fileName: 번들에 추가된, 파싱할 json 파일의 이름
    /// - Returns: 결과 타입의 객체
    func getObject<T>(of type: T.Type, fromJson fileName: String) -> T? where T: Codable {
        
        guard let url = Bundle.main.url(forResource: fileName, withExtension: "json") else {
            #if DEBUG
            print("cannot find json resource from bundle")
            #endif
            return nil
        }
        
        guard let data = try? Data(contentsOf: url) else { return nil }
        
        guard let result = decodeJson(type: type.self, fromJson: data) else { return nil }
        
        return result
    }
    
    
    /// Unsplash 이미지가 필요한 이미지 뷰의 이미지를 lazy 하게 이미지를 업데이트하는 유틸 메소드
    ///
    /// 기본 placeholder 이미지  > hash blur 이미지 > 최종 이미지 순서로 적용됩니다.
    /// - Parameters:
    ///   - type: 원하는 이미지의 타입
    ///   - imageView: 사용할 이미지 뷰
    ///   - query: 이미지의 키워드
    func download(_ type: PlaceImageDataType, andUpdate imageView: UIImageView, with query: String) {
        /// 1. placeholder 이미지로 설정
        imageView.image = placeholderImage
        
        /// unsplash 이미지 정보 받아오기
        fetchUnsplashInfo(with: query) { info in
            
            /// 2. Blur Hash 이미지 생성 및 업데이트
            let blurImage = UIImage(blurHash: info.blur_hash, size: imageView.frame.size)
            imageView.image = blurImage
            
            /// 필요한 이미지의 타입에 따라 요청 url 설정
            var imageUrl: URL? = nil
            
            switch type {
            case .thumbnail:
                imageUrl = URL(string: info.urls.thumb)
            case .detailImage:
                imageUrl = URL(string: info.urls.small)
            default:
                break
            }
            
            guard let url = imageUrl else {
                #if DEBUG
                print("url -- nil or invalid url")
                #endif
                return
            }
            
            self.fetchImage(with: url) { image in
                /// 3. 원본 이미지로 image view 업데이트
                imageView.image = image
            }
        }
    }
    
}
