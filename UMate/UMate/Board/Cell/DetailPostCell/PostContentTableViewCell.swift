//
//  PostContentTableViewCell.swift
//  PostContentTableViewCell
//
//  Created by 남정은 on 2021/07/27.
//

import UIKit


/// 스크랩에대한 노티피케이션
/// - Author: 남정은(dlsl7080@gmail.com)
extension  Notification.Name {
    static let postDidScrap = Notification.Name("postDidScrap")
    static let postCancelScrap = Notification.Name("postCancelScrap")
    static let postAlreadyLiked = Notification.Name("postAlreadyLiked")
}



/// 게시글 작성자, 제목, 내용에 관한 테이블 뷰 셀
/// - Author: 남정은(dlsl7080@gmail.com)
class PostContentTableViewCell: UITableViewCell {
    /// 작성자 프로필 이미지 뷰
    @IBOutlet weak var userImageView: UIImageView!
    
    /// 작성자 이름 레이블
    @IBOutlet weak var userNameLabel: UILabel!
    
    /// 작성일 레이블
    @IBOutlet weak var dateLabel: UILabel!
    
    /// 게시글 제목 레이블
    @IBOutlet weak var postTitleLabel: UILabel!
    
    /// 게시글 내용 레이블
    @IBOutlet weak var postContentLabel: UILabel!
    
    /// 선택된 게시글
    var selectedPost: PostDtoResponseData.Post?
    
    /// 게시글 좋아요 여부
    var isLiked = false
    
    /// 게시글 스크랩 여부
    var isScrapped = false
    
    
    // MARK: 공감 버튼
    /// 하트 이미지 뷰
    @IBOutlet weak var likeImageView: UIImageView!
    
    
    /// 하트 버튼을 눌렀을 때 하트 이미지의 색상이 변경됩니다.
    /// - Parameter sender: 하트 버튼
    /// - Author: 남정은(dlsl7080@gmail.com)
    @IBAction func toggleLikeButton(_ sender: UIButton) {
        guard let post = selectedPost else { return }
        
        if isLiked {
            NotificationCenter.default.post(name: .postAlreadyLiked, object: nil)
        }
        
        likeImageView.image = UIImage(named: "heart2.fill")
        likeImageView.tintColor = UIColor.init(named: "blackSelectedColor")
        
        guard let url = URL(string: "https://board1104.azurewebsites.net/api/likePost") else { return }
        
        let dateStr = BoardDataManager.shared.postDateFormatter.string(from: Date())
        #warning("사용자 수정")
        let likePostdata = LikePostData(userId: "6c1c72d6-fa9b-4af6-8730-bb98fded0ad8", postId: post.postId, createdAt: dateStr)
        
        let body = try? BoardDataManager.shared.encoder.encode(likePostdata)
        
        sendScrapOrLikePostRequest(url: url, httpMethod: "POST", httpBody: body)
        isLiked = true
    }
    
    
    // MARK: 스크랩 버튼
    /// 스크랩 이미지 뷰
    @IBOutlet weak var scrapImageView: UIImageView!
    @IBOutlet weak var scrapButton: UIButton!
    
    
    /// 스크랩 버튼을 눌렀을 때 스크랩 이미지 색상이 변경됩니다.
    /// - Parameter sender: 스크랩 버튼
    /// - Author: 남정은(dlsl7080@gmail.com)
    @IBAction func toggleScrapButton(_ sender: UIButton) {
        guard let post = selectedPost else { return }
        let scrapPostId = sender.tag
    
        if isScrapped {
            isScrapped = false
            scrapImageView.image = UIImage(named: "bookmark64")
            scrapImageView.tintColor = UIColor.init(named: "darkGraySubtitleColor")
            scrapImageView.alpha = 0.9
            
            deleteScrapPost(scrapPostId: scrapPostId)
            NotificationCenter.default.post(name: .postCancelScrap, object: nil, userInfo: ["postId":post.postId])
            
        } else {
            isScrapped = true
            scrapImageView.image = UIImage(named: "bookmark64.fill")
            scrapImageView.tintColor = UIColor.init(named: "blackSelectedColor")
            scrapImageView.alpha = 1
            
            guard let url = URL(string: "https://board1104.azurewebsites.net/api/scrapPost") else { return }
            
            let dateStr = BoardDataManager.shared.postDateFormatter.string(from: Date())
            #warning("사용자 수정")
            let scrapPostData = ScrapPostData(userId: "6c1c72d6-fa9b-4af6-8730-bb98fded0ad8", postId: post.postId, createdAt: dateStr)
            let body = try? BoardDataManager.shared.encoder.encode(scrapPostData)
            
            sendScrapOrLikePostRequest(url: url, httpMethod: "POST", httpBody: body)
        }
    }
    
    
    /// 신고 혹은 게시글 수정, 삭제를 actionSheet로 나타냅니다.
    /// - Parameter sender: 햄버거 버튼
    /// - Author: 남정은(dlsl7080@gmail.com)
    @IBAction func showMenu(_ sender: Any) {
        NotificationCenter.default.post(name: .sendAlert, object: nil)
    }
    
    
    /// 게시물을 스크랩 또는 '좋아'합니다.
    /// - Parameters:
    ///   - url: 요청할 url
    ///   - httpMethod: api 메소드
    ///   - httpBody: 게시글 스크랩, 좋아요 데이터
    ///   - Author: 남정은(dlsl7080@gmail.com)
    private func sendScrapOrLikePostRequest(url: URL, httpMethod: String, httpBody: Data?) {
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod
        request.httpBody = httpBody
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        
        BoardDataManager.shared.session.dataTask(with: request, completionHandler: { data, response, error in
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
                let res = try decoder.decode(SaveScrapPostPostResponse.self, from: data)
            
                switch res.resultCode {
                case ResultCode.ok.rawValue:
                    DispatchQueue.main.async {
                        self.scrapButton.tag = res.scrapPost?.scrapPostId ?? 0
                    }
                    
                    #if DEBUG
                    print("추가 성공")
                    #endif
                case ResultCode.fail.rawValue:
                    #if DEBUG
                    print("이미 존재함")
                    #endif
                default:
                    break
                }
            } catch {
                print(error)
            }
        }).resume()
    }
    
    
    /// 게시물 스크랩을 취소합니다.
    /// - Parameter scrapPostId: 스크랩 Id
    /// - Author: 남정은(dlsl7080@gmail.com)
    private func deleteScrapPost(scrapPostId: Int) {
        guard let url = URL(string: "https://board1104.azurewebsites.net/api/scrapPost/\(scrapPostId)") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        
        BoardDataManager.shared.session.dataTask(with: request) { data, response, error in
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
                
                switch res.resultCode {
                case ResultCode.ok.rawValue:
                    #if DEBUG
                    print("삭제 성공")
                    #endif
                case ResultCode.fail.rawValue:
                    #if DEBUG
                    print("삭제 실패")
                    #endif
                default:
                    break
                }
            } catch {
                print(error)
            }
        }.resume()
    }
    

    override func awakeFromNib() {
        super.awakeFromNib()
        
        // 사용자 이미지 모서리 깎기
        userImageView.layer.cornerRadius = userImageView.frame.height / 2
    }
    
  
    /// 작성자, 제목, 내용을 나타내는 셀을 초기화합니다.
    /// - Parameters:
    ///   - post: 선택된 post
    ///   - isLiked: 사용자의 게시물 좋아요 여부
    ///   - isScrapped: 사용자의 게시물 스크랩 여부
    ///   - scrapPostId: 스크랩 Id, 사용자가 스크랩하지 않은 경우는 0이 전달됩니다.
    /// - Author: 남정은(dlsl7080@gmail.com)
    func configure(post: PostDtoResponseData.Post, isLiked: Bool, isScrapped: Bool, scrapPostId: Int) {
    
        if isScrapped {
            scrapImageView.image = UIImage(named: "bookmark64.fill")
            scrapImageView.tintColor = UIColor.init(named: "blackSelectedColor")
            scrapImageView.alpha = 1
        } else {
            scrapImageView.image = UIImage(named: "bookmark64")
            scrapImageView.tintColor = UIColor.init(named: "darkGraySubtitleColor")
            scrapImageView.alpha = 0.9
        }
        
        
        if isLiked {
            likeImageView.image = UIImage(named: "heart2.fill")
            likeImageView.tintColor = UIColor.init(named: "blackSelectedColor")
        } else {
            likeImageView.image = UIImage(named: "heart2")
            likeImageView.tintColor = UIColor.init(named: "darkGraySubtitleColor")
        }
        
        userNameLabel.text = post.userId
        dateLabel.text = post.createdAt
        postTitleLabel.text = post.title
        postContentLabel.text = post.content
    
        // 게시글을 셀 클래스에서 사용하기위해 저장
        selectedPost = post
        self.isLiked = isLiked
        self.isScrapped = isScrapped
        scrapButton.tag = scrapPostId
    }
}



