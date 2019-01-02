//
//  ViewController.swift
//  iSearch
//
//  Created by Sharad Katre on 31/12/18.
//  Copyright © 2018 Sharad Katre. All rights reserved.
//

import UIKit
import Alamofire
import KRProgressHUD

var BASE_URL = "https://api.github.com/search/users?q=<searchedText>&page=<offSet>"
class ViewController: UIViewController {
    
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var tableView: UITableView!
    
    var results: [Items] = [Items]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
    }
    
    func configureTableView() {
        tableView.isHidden = true
        tableView.estimatedRowHeight = 120
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorStyle = .none
        tableView.register(UINib(nibName: "UserTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "UserTableViewCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    func callGithubUsersAPIData(_ searchText: String, offset: Int) {
        KRProgressHUD.show()
        let updateSearchText = BASE_URL.replacingOccurrences(of: "<searchedText>", with: searchText)
        let updateOffSet = updateSearchText.replacingOccurrences(of: "<offSet>", with: "\(offset)")
        
        guard let url = URL(string: updateOffSet) else {
            return
        }
        
        Alamofire.request(url,
                          method: .get)
            .validate()
            .responseJSON { response in
                if response.result.isSuccess {
                    let json = response.data
                    do{
                        let decoder = JSONDecoder()
                        
                        let result = try decoder.decode(BaseModel.self, from: json!)
                        self.results = result.items ?? [Items]()
                        print(result)
                        print(self.results)
                        
                    }catch let err{
                        print(err)
                    }
                    self.tableView.reloadData()
                    self.tableView.isHidden = false
                    KRProgressHUD.dismiss()
                }
                if response.result.isFailure {
                    KRProgressHUD.dismiss()
                }
        }
    }
}

extension ViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        callGithubUsersAPIData(searchBar.text!, offset: 1)
        self.searchBar.resignFirstResponder()
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.count > 3 {
            callGithubUsersAPIData(searchBar.text!, offset: 1)
        }
        if searchText.count == 0 {
            self.results = [Items]()
            tableView.reloadData()
            tableView.isHidden = true
        }
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.results.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UserTableViewCell = tableView.dequeueReusableCell(withIdentifier: "UserTableViewCell") as! UserTableViewCell
        let searchResult = results[indexPath.row]
        cell.setData(searchResult)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyBoard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let viewController = storyBoard.instantiateViewController(withIdentifier: "UserDetailsViewController") as! UserDetailsViewController
        viewController.userDetails = self.results[indexPath.row]
        viewController.modalPresentationStyle = .currentContext
        viewController.modalTransitionStyle = .crossDissolve
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}
