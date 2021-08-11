//
//  ExpandImageViewController.swift
//  ExpandImageViewController
//
//  Created by 남정은 on 2021/08/11.
//

import UIKit

class ExpandImageViewController: UIViewController {

    @IBOutlet weak var imageCountLabel: UILabel!
    
    @IBAction func closeImageVC(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    var selectedPost: Post?
    var imageIndex: Int?
    
    var token: NSObjectProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        token = NotificationCenter.default.addObserver(forName: .sendImageView, object: nil, queue: .main) { noti in
            guard let post = noti.userInfo?["post"] as? Post else { return }
            guard let index = noti.userInfo?["index"] as? Int else { return }
            
            self.selectedPost = post
            self.imageIndex = index
            
            let images = post.images
            self.imageCountLabel.text = "\(index + 1) / \(images.count)"
        }
    }
    
    
    deinit {
        if let token = token {
            NotificationCenter.default.removeObserver(token)
        }
    }
}




extension ExpandImageViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return selectedPost?.images.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "postImageCell", for: indexPath) as! ExpandPostImageCollectionViewCell
        
        guard let images = selectedPost?.images else { return cell }
   
        
        //일단 이미지 배열을 모두 넣어줌.
        //선택된 이미지 인덱스의 이미지를 보여주어야 함.
        cell.expandImageView.image = images[indexPath.row]
        return cell
    }
}




extension ExpandImageViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width
        let height = width * 1.5
        
        return CGSize(width: width, height: height)
    }
}




extension ExpandImageViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let x = scrollView.contentOffset.x
        
        let page = Int(x / scrollView.frame.width) + 1
        
        guard let images = selectedPost?.images else { return }
        imageCountLabel.text = "\(page) / \(images.count)"
    }
}
