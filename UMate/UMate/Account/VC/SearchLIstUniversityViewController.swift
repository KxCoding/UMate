//
//  SearchLIstUniversityViewController.swift
//  SearchLIstUniversityViewController
//
//  Created by 황신택 on 2021/08/06.
//

import UIKit

/// Create New Notification Name
extension Notification.Name {
    static let didTapSendUniversityName = Notification.Name("didTapSendUniversityName")
}

class SearchLIstUniversityViewController: UIViewController {
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var listTableView: UITableView!
    
    /// Stores the desired result value as array
    var searchCountry = [String]()
    /// Declaration Boolean property Because in some cases, we have to give different results.
    var searching = false
    /// Create userInfo Key
    static let universityNameTransitionKey = "universityNameTransitionKey"
    /// Back to previous View
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        
    }
    
    
    /// Create New Notification post To Delivery desired value as dictionary's key
    /// - Parameter sender: completeButton
    @IBAction func completeButton(_ sender: Any) {
        guard let searchBarText = searchBar.text else { return  }
        NotificationCenter.default.post(name: .didTapSendUniversityName, object: nil, userInfo: [SearchLIstUniversityViewController.universityNameTransitionKey: searchBarText])
        
        dismiss(animated: true, completion: nil)
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        listTableView.delegate = self
        listTableView.dataSource = self
        searchBar.delegate = self
        listTableView.isHidden = true
        
    }
    
}


extension SearchLIstUniversityViewController: UITableViewDataSource {
    
    /// If true, implement different number of cells depending on search results
    /// - Parameters:
    ///   - tableView: tableView
    ///   - section: searchCountry.count or universityList.count
    /// - Returns: Int
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searching {
            return searchCountry.count
        }
        
        return universityList.count
    }
    
    /// If true, cell content is implemented differently depending on search results
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.selectionStyle = .none
        if searching {
            cell.textLabel?.text = searchCountry[indexPath.row]
        } else {
            cell.textLabel?.text = universityList[indexPath.row]
        }
        
        return cell
    }
    
    
}

extension SearchLIstUniversityViewController: UITableViewDelegate {
    /// If true, the value will appear in the text field depending on the search result.
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if searching {
            searchBar.text = searchCountry[indexPath.row]
        } else {
            searchBar.text = universityList[indexPath.row]
        }
        
    }
    
}


extension SearchLIstUniversityViewController: UISearchBarDelegate {
    
    /// when user searching, Compare the number of characters in the prefix of universityList's array and the contents of the characters.
    /// - Parameters:
    ///   - searchBar: searchBar
    ///   - searchText: searchText
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searching = true
        searchCountry = universityList.filter{ $0.prefix(searchText.count) == searchText }
        
        listTableView.reloadData()
    }
    
    /// only when user didtap in searchBar, listTableView shown in addition to implement animation effect.
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
        listTableView.isHidden = false
    }
    
    /// Only by searching and didtap it was allowed to enter text.
    func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        return true
    }
    
    
    
}
