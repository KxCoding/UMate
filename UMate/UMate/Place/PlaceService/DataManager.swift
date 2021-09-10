//
//  DataManager.swift
//  UMate
//
//  Created by Effie on 2021/08/29.
//

import UIKit

class DataManager {
    
    /// singleton instance
    static let shared = DataManager()
    private init() { }
    
    let session = URLSession.shared
    
    // MARK: - Data
    
    /// 전달된 URL로 요청을 실행하고, 요청 후 전달한 handler 를 실행하는 메소드
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
    
    
    /// 전달된 문자열로 URL을 생성해 요청을 실행하고, 요청 이후 전달한 handler 를 실행하는 메소드
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
    
    
    /// 주어진 url로부터 이미지를 가져오는 메소드
    /// - Parameter url: url
    /// - Returns: 캐시에 저장된 이미지가 있거나 url로 해당 이미지를 가져올 수 있으면 이미지를 리턴, 실패하면 nil
    func getImage(from url: URL) -> UIImage? {
        
        let nsUrl = url as NSURL
        
        /// 캐시에 이미지가 저장되었는지 확인
        if let image = imageCache.object(forKey: nsUrl) {
            return image
        } else {
            
            #if DEBUG
            print("can't get data from cache")
            #endif
            
            
            guard let data = try? Data(contentsOf: nsUrl as URL) else {
                #if DEBUG
                print("can't get data from url")
                #endif
                
                return nil
            }
            
            #if DEBUG
            print("downloaded successfully")
            #endif
            
            guard let image = UIImage(data: data) else {
                #if DEBUG
                print("can't initialize image from data")
                #endif
                
                return nil
            }
            
            #if DEBUG
            print("image initialized successfully")
            #endif
            
            // 캐시에 이미지 저장
            imageCache.setObject(image, forKey: nsUrl)
            
            return image
            
            /*
            
             guard let data = fetchData(with: url) else { return nil }
             
             guard let image = UIImage(data: data) else {
             #if DEBUG
             print("cannot convert data to image")
             #endif
             
             return nil
             }
             
             imageCache.setObject(image, forKey: nsUrl)
             
             return image
             
 */
        }
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
    
    
    // MARK: - Unsplash API
    
    /// Demo 앱으로 등록, 50 request / hour
    let unsplashKey = "RZoyv1JUGLzedP_O6q1OBthZTnne2ME7lwkE_gDZmOI"
    
    func lazyUpdate(_ type: PlaceImageDataType, of imageView: UIImageView, with query: String) {
        /// info  데이터 요청
        let count = 1
        let orientation = "landscape"
        guard let url = URL(string: "https://api.unsplash.com/photos/random?client_id=\(unsplashKey)&query=\(query)&count=\(count)&orientation=\(orientation)") else { return }
        
        session.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self else { return }
            
            if let error = error {
                print(error)
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                  httpResponse.statusCode == 200 else {
                print((response as? HTTPURLResponse)?.statusCode)
                print("info 응답 코드가 없거나 정상 응답 아님")
                return
            }
            
            /// 데이터가 있으면
            guard let data = data else {
                print("data 없음")
                return
            }
            /// 디코딩
            guard let imagesInfo = DataManager.shared.decodeJson(type: [UnsplashImagesInfo].self,
                                                                 fromJson: data) else {
                print("디코딩 실패")
                return
            }
            guard let item = imagesInfo.first else {
                print("아이템이 하나도 없음")
                return
            }
            
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                
                let blurHash = item.blur_hash
                let image = UIImage(blurHash: blurHash, size: imageView.frame.size)
                imageView.image = image
            }
            
            var url = tempUrl
            
            if type == .thumbnail {
                guard let thumbnailUrl = URL(string: item.urls.thumb) else {
                    print("url 변환 실패")
                    return
                }
                url = thumbnailUrl
            } else if type == .detail {
                guard let smallUrl = URL(string: item.urls.small) else {
                    print("url 변환 실패")
                    return
                }
                url = smallUrl
            }
            
            self.session.dataTask(with: url) { [weak self] data, response, error in
                guard let self = self else { return }
                if let error = error {
                    print(error)
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse,
                      httpResponse.statusCode == 200 else {
                    print((response as? HTTPURLResponse)?.statusCode)
                    print("응답 코드가 없거나 정상 응답 아님")
                    return
                }
                
                guard let data = data else {
                    print("data 없음")
                    return
                }
                
                guard let image = UIImage(data: data) else {
                    print("이미지 변환 실패")
                    return
                }
                
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    
                    UIView.animate(withDuration: 0.3) {
                        imageView.image = image
                    }
                    
                }
                
                
                
            }.resume()
            
//            fetchData(with: <#T##URL#>, completion: <#T##((Data?) -> ())?##((Data?) -> ())?##(Data?) -> ()#>)
            
            
        }.resume()
        
        
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
    
}




enum PlaceImageDataType {
    /// used on Place
    case placeholder
    case blurHash
    case thumbnail
    case detail
}
