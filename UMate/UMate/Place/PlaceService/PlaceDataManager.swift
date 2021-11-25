//
//  DataManager.swift
//  UMate
//
//  Created by Effie on 2021/08/29.
//

import UIKit

enum HTTPMethod {
    case get
    case post
    case put
    case delete
}

/// Place 데이터 관리 객체
///
/// - Author: 박혜정(mailmelater11@gmail.com)
class PlaceDataManager {
    
    // MARK: Properties
    
    /// singleton instance
    static let shared = PlaceDataManager()
    private init() { }
    
    
    // MARK: - Data
    
    /// 공유 URLSession 객체
    let session = URLSession.shared
    
    /// 전달된 URL로 요청을 실행하고, 요청 후 전달한 작업을 실행합니다.
    ///
    /// 데이터를 가져온 다음 json 데이터를 완료 블록으로 전달합니다.
    /// - Parameters:
    ///   - url: 상점이나 리뷰 데이터를 가져오는 url
    ///   - completion: 완료 블록. 디코딩 되지 않은 json 데이터가 전달됩니다.
    /// - Author: 박혜정(mailmelater11@gmail.com)
    func fetchData(with url: URL, completion: ((Data) -> ())?) {
        session.dataTask(with: url) { data, response, error in
            
            if let error = error {
                #if DEBUG
                print("datatask error", error)
                #endif
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                  httpResponse.statusCode == 200 else {
                #if DEBUG
                print((response as? HTTPURLResponse)?
                        .statusCode ?? "can't get status code")
                #endif
                return
            }
            
            guard let data = data else {
                #if DEBUG
                print("data == nil ")
                #endif
                return
            }
            
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
    /// - Author: 박혜정(mailmelater11@gmail.com)
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
    ///
    /// ISO8601 날짜 문자열을 디코딩하기 위해 사용합니다.
    /// - Author: 박혜정(mailmelater11@gmail.com)
    private let jsonDecoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }()
    
    
    /// json 데이터를 디코딩합니다.
    /// - Parameters:
    ///   - type: 파싱할 데이터 타입
    ///   - data: json 데이터
    /// - Returns: 디코딩에 성공하면 지정한 타입의 객체를 리턴, 실패하면 nil을 리턴합니다.
    /// - Author: 박혜정(mailmelater11@gmail.com)
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
    ///
    /// 키로 NSURL 타입 객체를 저장합니다.
    var nsUrlImageCache = NSCache<NSURL, UIImage>()
    
    /// 이미지 캐시
    ///
    /// 키로 문자열 타입 객체를 저장합니다.
    var stringImageCache = NSCache<NSString, UIImage>()
    
    /// 이미지를 다운로드 합니다.
    ///
    /// url을 기준으로 캐시에 저장합니다.
    /// - Parameter url: 이미지 url
    /// - Returns: 캐시에 저장된 이미지가 있거나 url로 해당 이미지를 가져올 수 있으면 이미지를 리턴하고, 나머지 경우 nil을 합니다.
    /// - Author: 박혜정(mailmelater11@gmail.com)
    func getImage(from url: URL) -> UIImage? {
        
        var result: UIImage? = nil
        
        let nsUrl = url as NSURL
        
        if let image = nsUrlImageCache.object(forKey: nsUrl) {
            result = image
        } else {
            #if DEBUG
            print("can't get data from cache")
            #endif
            
            /// 이미지 다운로드
            fetchData(with: url) { data in
                guard let image = UIImage(data: data) else {
                    print("cannot convert data to image")
                    return
                }
                
                self.nsUrlImageCache.setObject(image, forKey: nsUrl)
                
                result = image
            }
        }
        
        return result
    }
    
    
    /// 이미지를 다운로드합니다.
    /// - Parameter urlString: 문자열 이미지 url
    /// - Returns: 캐시에 저장된 이미지가 있거나 url로 해당 이미지를 가져올 수 있으면 이미지를 리턴하고, 실패하면 nil을 리턴합니다.
    /// - Author: 박혜정(mailmelater11@gmail.com)
    func getImage(with urlString: String) -> UIImage? {
        
        guard let url = URL(string: urlString) else {
            return nil
        }
        
        return getImage(from: url)
    }
    
    
    /// 이미지를 다운로드 합니다.
    /// - Parameters:
    ///   - url: url
    ///   - completion: 완료 블록. 다운로드된 이미지가 전달됩니다.
    /// - Author: 박혜정(mailmelater11@gmail.com)
    func getImage(with url: URL, completion: ((UIImage) -> ())?) {
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
    
    
    /// 이미지를 다운로드 합니다.
    /// - Parameters:
    ///   - urlString: url 문자열
    ///   - imageView: 사용할 이미지 뷰
    func getImage(with urlString: String, andUpdate imageView: UIImageView) {
        let nsUrl = NSString(string: urlString)
        
        if let image = stringImageCache.object(forKey: nsUrl) {
            imageView.image = image
        } else {
            imageView.image = placeholderImage
            
            guard let url = URL(string: urlString) else { return }
            
            getImage(with: url) { downloadedImage in
                self.stringImageCache.setObject(downloadedImage, forKey: nsUrl)
                imageView.image = downloadedImage
            }
            
        }
    }
    
    
    
    // MARK: - Unsplash API
    
    /// Unsplash API 키
    ///
    /// Demo - 50 request / hour
    let unsplashKey = "eNywpJFfd0G8603Gm0qmjiM4Dp5TS8OJ4APXjCq3pfs"
    
    
    /// 키워드로 이미지를 요청합니다.
    /// - Parameters:
    ///   - query: 키워드(쿼리)
    ///   - completion: 완료 블록. 이미지 정보를 담고 있는 객체가 전달됩니다.
    /// - Author: 박혜정(mailmelater11@gmail.com)
    func fetchUnsplashInfo(with query: String, completion: ((UnsplashImagesInfo) -> ())?) {
        
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
            
            guard let imagesInfo = self.decodeJson(type: [UnsplashImagesInfo].self,
                                                   fromJson: data) else {
                #if DEBUG
                print("or maybe it's error invalid api key or query")
                #endif
                return
            }
            
            // 항상 하나의 이미지가 배열에 저장되므로, 첫번째 항목을 언래핑.
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
    /// 파일 경로에서 URL을 생성합니다.
    /// - Parameter string: 확장자가 포함된 파일의 이름
    /// - Returns: 리소스 url
    /// - Author: 박혜정(mailmelater11@gmail.com)
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
    
    
    /// json 파일을 파싱합니다.
    /// - Parameters:
    ///   - type: 결과 타입
    ///   - fileName: json 파일 이름
    /// - Returns: 파싱된 객체. 파싱에 실패하면 nil을 리턴합니다.
    /// - Author: 박혜정(mailmelater11@gmail.com)
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
    
    
    /// Unsplash 이미지를 다운로드한 다음 대상 이미지 뷰를 업데이트 합니다.
    ///
    /// 이미지 캐시에 전달받은 쿼리로 저장된 이미지가 있다면 해당 이미지로 이미지 뷰를 업데이트 합니다.
    /// 캐시에 이미지가 저장되어 있지 않다면 다운로드하고, 이미지 뷰에 기본 placeholder 이미지  > blur hash 이미지 > 최종 이미지가 순서대로 적용됩니다.
    /// - Parameters:
    ///   - type: 원하는 이미지의 타입
    ///   - imageView: 사용할 이미지 뷰
    ///   - query: 검색 키워드
    /// - Author: 박혜정(mailmelater11@gmail.com)
    func download(_ type: PlaceImageDataType, andUpdate imageView: UIImageView, with query: String) {
        let nsQuery = NSString(string: query)
        
        if let image = stringImageCache.object(forKey: nsQuery) {
            imageView.image = image
        } else {
            imageView.image = placeholderImage
            
            fetchUnsplashInfo(with: query) { info in
                
                let blurImage = UIImage(blurHash: info.blur_hash, size: imageView.frame.size)
                imageView.image = blurImage
                
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
                
                self.getImage(with: url) { image in
                    self.stringImageCache.setObject(image, forKey: nsQuery)
                    imageView.image = image
                }
            }
        }
    }
    
    // MARK: 서버 관련 코드
    
    /// 임시 토큰
    let tempToken = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJodHRwOi8vc2NoZW1hcy54bWxzb2FwLm9yZy93cy8yMDA1LzA1L2lkZW50aXR5L2NsYWltcy9uYW1lIjoiNTQ0M2ZiYTYtNzJiYy00YTkzLTk3ZTktOWEyN2YzYTFlOTMyIiwiaHR0cDovL3NjaGVtYXMueG1sc29hcC5vcmcvd3MvMjAwNS8wNS9pZGVudGl0eS9jbGFpbXMvbmFtZWlkZW50aWZpZXIiOiI1NDQzZmJhNi03MmJjLTRhOTMtOTdlOS05YTI3ZjNhMWU5MzIiLCJodHRwOi8vc2NoZW1hcy54bWxzb2FwLm9yZy93cy8yMDA1LzA1L2lkZW50aXR5L2NsYWltcy9lbWFpbGFkZHJlc3MiOiJ0ZXN0MUB0ZXN0LmNvbSIsImV4cCI6MTYzODMwNjc3MiwiaXNzIjoiaHR0cHM6Ly9sb2NhbGhvc3Q6NTU0MTUiLCJhdWQiOiJodHRwczovL2xvY2FsaG9zdDo1NTQxNSJ9.tPj34LMEChrZ9oCVIgKzn4GbALjdfxAq6u_LXS4kF5E"
    
    /// json 인코더
    let jsonEncoder = JSONEncoder()
    

    /// 서버에 데이터 등록을 요청합니다.
    ///
    /// - Parameters:
    ///   - bodyData: 요청 body 데이터
    ///   - url: url
    ///   - vc: 처리 실패시 alert를 표시할 view controller
    ///   - completion: 응답과 함께 처리할 작업
    /// - Author: 박혜정(mailmelater11@gmail.com)
    func post<RequestDataType: Codable, ResponseDataType: PlaceResponseType>(_ bodyData: RequestDataType, with url: URL, on vc: UIViewController, completion: ((ResponseDataType) -> Void)?) {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("Bearer \(tempToken)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        do {
            request.httpBody = try jsonEncoder.encode(bodyData)
        } catch {
            #if DEBUG
            print(error)
            #endif
        }

        session.dataTask(with: request) { [weak self] data, response, error in
            guard let self = self else { return }

            if let error = error {
                #if DEBUG
                print("datatask error", error)
                #endif
                return
            }

            guard let httpResponse = response as? HTTPURLResponse,
                  httpResponse.statusCode == 200 else {
                #if DEBUG
                print((response as? HTTPURLResponse)?
                        .statusCode ?? "can't get status code")
                #endif
                return
            }

            guard let data = data else {
                #if DEBUG
                print("data == nil ")
                #endif
                return
            }

            guard let responseData = self.decodeJson(type: ResponseDataType.self, fromJson: data) else {
                #if DEBUG
                print("cannot decode data to the type")
                #endif
                return
            }

            self.handle(responseData, alertOn: vc, orCompleteWith: completion)

        }.resume()

    }
    
    
    /// 서버에 데이터를 요청합니다.
    ///
    /// - Parameters:
    ///   - url: url
    ///   - vc: 처리 실패시 alert를 표시할 view controller
    ///   - completion: 응답과 함께 처리할 작업
    /// - Author: 박혜정(mailmelater11@gmail.com)
    func get<T: Codable & PlaceResponseType>(with url: URL, on vc: UIViewController, completion: ((T) -> Void)?) {
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("Bearer \(tempToken)", forHTTPHeaderField: "Authorization")

        session.dataTask(with: request) { [weak self] data, response, error in
            guard let self = self else { return }
            
            if let error = error {
                #if DEBUG
                print("datatask error", error)
                #endif
                return
            }

            guard let httpResponse = response as? HTTPURLResponse,
                  httpResponse.statusCode == 200 else {
                #if DEBUG
                print((response as? HTTPURLResponse)?
                        .statusCode ?? "can't get status code")
                #endif
                return
            }

            guard let data = data else {
                #if DEBUG
                print("data == nil ")
                #endif
                return
            }

            guard let responseData = self.decodeJson(type: T.self, fromJson: data) else {
                #if DEBUG
                print("cannot decode data to the type")
                #endif
                return
            }
            
            self.handle(responseData, alertOn: vc, orCompleteWith: completion)

        }.resume()
    }
    
    
    /// 서버에 데이터 삭제를 요청합니다.
    /// - Parameters:
    ///   - url: url
    ///   - vc: 처리 실패시 alert를 표시할 view controller
    ///   - completion: 응답과 함께 처리할 작업
    /// - Author: 박혜정(mailmelater11@gmail.com)
    func delete(with url: URL, on vc: UIViewController, completion: ((PlaceCommonResponse) -> Void)?) {
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.addValue("Bearer \(tempToken)", forHTTPHeaderField: "Authorization")
        
        session.dataTask(with: request) { [weak self] data, response, error in
            guard let self = self else { return }
            
            if let error = error {
                #if DEBUG
                print("datatask error", error)
                #endif
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                  httpResponse.statusCode == 200 else {
                #if DEBUG
                print((response as? HTTPURLResponse)?
                        .statusCode ?? "can't get status code")
                #endif
                return
            }
            
            guard let data = data else {
                #if DEBUG
                print("data == nil")
                #endif
                return
            }
            
            guard let responseData = self.decodeJson(type: PlaceCommonResponse.self, fromJson: data) else {
                #if DEBUG
                print("cannot decode data to common response type")
                #endif
                return
            }
                        
            self.handle(responseData, alertOn: vc, orCompleteWith: completion)
                        
        }.resume()
    }
    
    
    /// 응답 데이터를 처리합니다.
    /// - Parameters:
    ///   - response: 응답 데이터
    ///   - vc: 정상 처리 실패시 alert를 표시할 view controller
    ///   - completion: 처리 성공시 응답과 함께 처리할 작업
    /// - Author: 박혜정(mailmelater11@gmail.com)
    private func handle<T: PlaceResponseType>(_ response: T, alertOn vc: UIViewController, orCompleteWith completion: ((T) -> Void)?) {
        if response.code != PlaceResultCode.ok.rawValue {
            DispatchQueue.main.async { [weak vc] in
                guard let vc = vc else { return }
                vc.alert(title: "네트워크 오류", message: response.clientAlertMessage ?? "")
            }
        } else {
            if let completion = completion {
                DispatchQueue.main.async { completion(response) }
            }
        }
    }
    
}
