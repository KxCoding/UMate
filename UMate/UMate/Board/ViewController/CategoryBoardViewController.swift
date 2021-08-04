//
//  CategoryBoardViewController.swift
//  CategoryBoardViewController
//
//  Created by 남정은 on 2021/08/03.
//


import UIKit

class CategoryBoardViewController: UIViewController {

    var selectedBoard: Board?
    
    var filteredPostList: [Post] = []
    var nonCliked = true
    
    @IBOutlet weak var categoryListCollectionView: UICollectionView!
    
    @IBOutlet weak var categoryListTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        filteredPostList = selectedBoard?.posts ?? []
    }
}


extension CategoryBoardViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return selectedBoard?.categories.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //viewDidLoad처럼 처음 화면 구성할 때만 셀갯수만큼 호출됨.
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryBoardCollectionViewCell", for: indexPath) as! CategoryBoardCollectionViewCell
        guard let cateigories = selectedBoard?.categories else { return cell }
        if indexPath.row == 0 {
            if nonCliked {
                cell.categoryView.backgroundColor = .black
            } else {
                cell.categoryView.backgroundColor = .white
            }
        }
        cell.configure(categories: cateigories, indexPath: indexPath)
        return cell
    }
}



extension CategoryBoardViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        if nonCliked {
            nonCliked = false
            collectionView.reloadItems(at: [IndexPath(item: 0, section: 0)])
        }
        
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        filteredPostList.removeAll()
        
        guard let posts = selectedBoard?.posts else {
            return }
        
        var isFiltering: Bool {
            let categoryFiltering = indexPath.row != 0
            return categoryFiltering
        }
        
        if isFiltering {
            filterPostByCategory(with: posts, indexPath: indexPath)
        } else {
            filteredPostList = posts
        }
       
        categoryListTableView.reloadData()
    }
 
    private func filterPostByCategory(with posts: [Post], indexPath: IndexPath) {
        
        if posts.first?.publicity != nil {
            filteredPostList = posts.filter{ post in
                return post.publicity?.rawValue == selectedBoard?.categories[indexPath.row]
            }
        } else if posts.first?.club != nil {
            filteredPostList = posts.filter{ post in
                return post.club?.rawValue == selectedBoard?.categories[indexPath.row]
            }
          
        } else if posts.first?.career != nil {
            filteredPostList = posts.filter{ post in
                return post.career?.rawValue == selectedBoard?.categories[indexPath.row]
            }
        }
    }
}



extension CategoryBoardViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredPostList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FreeBoardTableViewCell", for: indexPath) as! FreeBoardTableViewCell
        
        let post = filteredPostList[indexPath.row]
        
        cell.configure(post: post)
        return cell
    }
}
