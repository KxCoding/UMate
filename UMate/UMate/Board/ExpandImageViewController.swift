//
//  ExpandImageViewController.swift
//  ExpandImageViewController
//
//  Created by 남정은 on 2021/08/11.
//

import UIKit

class ExpandImageViewController: UIViewController {

    @IBOutlet weak var imageCountLabel: UILabel!
    @IBOutlet weak var pager: UIPageControl!
    
    @IBOutlet weak var imageCollectionView: UICollectionView!
    
    @IBAction func controlPage(_ sender: UIPageControl) {
        let indexPath = IndexPath(item: sender.currentPage, section: 0)
        imageCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
    
    
    @IBAction func closeImageVC(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    var selectedPost: Post?
    var imageIndex: Int?
    var initiatedImage = true
    
    var token: NSObjectProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pager.configureStyle(with: [.pillShape])
        pager.backgroundColor = .black.withAlphaComponent(0.1)
        
        token = NotificationCenter.default.addObserver(forName: .sendImageView, object: nil, queue: .main) { noti in
            guard let post = noti.userInfo?["post"] as? Post else { return }
            guard let index = noti.userInfo?["index"] as? Int else { return }
            
            self.selectedPost = post
            self.imageIndex = index
            
            let images = post.images
            self.imageCountLabel.text = "\(index + 1) / \(images.count)"
           
            if images.count > 1 {
                self.pager.currentPage = index
                self.pager.numberOfPages = images.count
            } else {
                self.pager.isHidden = true
            }
            
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
   
        cell.expandImageView.image = images[indexPath.row]
        return cell
    }
}




extension ExpandImageViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        if initiatedImage {
            initiatedImage = false
            collectionView.scrollToItem(at: IndexPath(item: imageIndex ?? 0, section: 0), at: .centeredHorizontally, animated: false)
        }
    }
}




extension ExpandImageViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width
        let height = width * 1.65
        
        return CGSize(width: width, height: height)
    }
}




extension ExpandImageViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let x = scrollView.contentOffset.x
 
        let page = Int( x / scrollView.frame.width)
        
        guard let images = selectedPost?.images else { return }
        imageCountLabel.text = "\(page + 1) / \(images.count)"
        
        pager.currentPage = page
    }
}
