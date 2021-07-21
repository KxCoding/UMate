//
//  FreeBoardViewController.swift
//  FreeBoardViewController
//
//  Created by 남정은 on 2021/07/21.
//

import UIKit

class FreeBoardViewController: UIViewController {

    var selectedBoard: Board?
       
       override func viewDidLoad() {
           super.viewDidLoad()

       }
   }



   extension FreeBoardViewController: UITableViewDataSource {
       func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
           return selectedBoard?.posts.count ?? 0
       }
       
       func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
           let cell = tableView.dequeueReusableCell(withIdentifier: "FreeBoardTableViewCell", for: indexPath) as! FreeBoardTableViewCell
           guard let post = selectedBoard?.posts[indexPath.row] else { return cell }
           
           cell.configure(post: post)
           return cell
       }
   }
