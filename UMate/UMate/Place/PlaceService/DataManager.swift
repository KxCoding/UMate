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
    
    
    // MARK: Data
    
    /// url에서 데이터를 가져와 리턴하는 메소드
    /// - Parameter url: url
    /// - Returns: url로 부터 데이터를 가져오는데 성공하면 해당 데이터를 리턴, 정상적인 결과를 가져올 수 없으면 nil
    func fetchData(with url: URL) -> Data? {
        var result: Data? = nil
        let session = URLSession.shared
        
        let task = session.dataTask(with: url) { data, response, error in
            /// 에러 확인
            if let error = error {
                #if DEBUG
                print(error)
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
            
            result = data
            return
        }
         
        return result
    }
    
    
    /// url에서 데이터를 가져와 리턴하는 메소드
    /// - Parameter urlString: 문자열 url
    /// - Returns: 문자열 url로 부터 데이터를 가져오는데 성공하면 해당 데이터를 리턴, 정상적인 결과를 가져올 수 없으면 nil
    func fetchData(with urlString: String) -> Data? {
        
        guard let url = URL(string: urlString) else {
            #if DEBUG
            print("fail converting stirng to url")
            #endif
            return nil
        }
        
        return fetchData(with: url)
    }
    
    
    // MARK: JSON
    
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
    
    
    // MARK: Image
    
    /// 이미지 캐시
    var imageCache = NSCache<NSURL, UIImage>()
    
    
    /// 주어진 url로부터 이미지를 가져오는 메소드
    /// - Parameter url: url
    /// - Returns: 캐시에 저장된 이미지가 있거나 url로 해당 이미지를 가져올 수 있으면 이미지를 리턴, 실패하면 nil
    func getImage(from url: URL) -> UIImage? {
        
        let nsUrl = url as NSURL
        
        /// 캐시에 이미지가 저장되었는지 확인
        if let image = imageCache.object(forKey: nsUrl) { return image } else {
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
    
    
    // MARK: Util Methods
    
    /// 주어진 문자열의 이름과 확장자를 가진 파일을  번들에서 찾아서 유효한 문자열이면 url을 제공하는 메소드
    /// - Parameter string: 찾는 리소스 파일의 문자열
    /// - Returns: 일치하는 리소스의 url
    func generateUrl(forFile string: String) -> URL? {
        
        let arr = string.components(separatedBy: ".")
        guard let fileName = arr.first,
              let extensionName = arr.last,
              fileName != extensionName else { return nil }
        
        guard let url = Bundle.main.url(forResource: "places", withExtension: "json") else {
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
