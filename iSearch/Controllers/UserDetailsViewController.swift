//
//  UserDetailsViewController.swift
//  iSearch
//
//  Created by Sharad Katre on 31/12/18.
//  Copyright © 2018 Sharad Katre. All rights reserved.
//

import UIKit
import SDWebImage
import Alamofire
import KRProgressHUD
import TTTAttributedLabel

class UserDetailsViewController: UIViewController {

    @IBOutlet var userIdLabel: UILabel!
    @IBOutlet var userImageView: UIImageView!
    @IBOutlet var userNameLabel: UILabel!
    @IBOutlet var tableView: UITableView!
    
    @IBOutlet var titleLabel1: UILabel!
    @IBOutlet var titleLabel2: UILabel!
    @IBOutlet var titleLabel3: UILabel!
    @IBOutlet var descriptionLabel1: TTTAttributedLabel!
    @IBOutlet var descriptionLabel2: TTTAttributedLabel!
    @IBOutlet var descriptionLabel3: TTTAttributedLabel!
    
    var userDetails: Items?
    var followers: [Items] = [Items]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        callGithubUsersFollowersAPIData()
    }
    
    func configureUI() {
        userImageView.layer.cornerRadius = self.userImageView.bounds.width / 2
        self.navigationController?.navigationBar.prefersLargeTitles = false
        configureTableView()
        configureLabels()
        setData()
    }
    
    func configureLabels() {
        titleLabel1.isHidden = true
        titleLabel2.isHidden = true
        titleLabel3.isHidden = true
        descriptionLabel1.isHidden = true
        descriptionLabel2.isHidden = true
        descriptionLabel3.isHidden = true
        descriptionLabel1.delegate = self
        descriptionLabel2.delegate = self
        descriptionLabel3.delegate = self
    }
    
    func configureTableView() {
        tableView.isHidden = true
        tableView.estimatedRowHeight = 120
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorStyle = .none
        tableView.layer.cornerRadius = 12.0
        tableView.register(UINib(nibName: "UserTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "UserTableViewCell")
    }
    
    func setData() {
        if let user = userDetails {
            self.userIdLabel.text = "\(user.id!)"
            self.userNameLabel.text = user.login
            if let userUrl: NSString = user.html_url as NSString? {
                self.titleLabel1.isHidden = false
                self.titleLabel1.text = "GitHub Link: "
                self.descriptionLabel1.text = userUrl
                let range : NSRange = userUrl.range(of: userUrl as String)
                self.descriptionLabel1.addLink(to: URL(string: userUrl as String), with: range)
                self.descriptionLabel1.isHidden = false
            }

            if let repos: NSString = user.repos_url as NSString? {
                self.titleLabel2.isHidden = false
                self.titleLabel2.text = "GitHub Repos: "
                self.descriptionLabel2.text = repos
                let range : NSRange = repos.range(of: repos as String)
                self.descriptionLabel2.addLink(to: URL(string: repos as String), with: range)
                self.descriptionLabel2.isHidden = false
            }

            let url = URL.init(string: user.avatar_url!)
            self.userImageView!.sd_setImage(with: url, placeholderImage: nil, options: .refreshCached, completed: nil)
        }
    }
    
    func callGithubUsersFollowersAPIData() {
        KRProgressHUD.show()
        
        guard let url = URL(string: (userDetails?.followers_url)!) else {
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
                        
                        let result = try decoder.decode([Items].self, from: json!)
                        self.followers = result
                        print(result)
                        print(self.followers)
                        
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

extension UserDetailsViewController: TTTAttributedLabelDelegate {
    func attributedLabel(_ label: TTTAttributedLabel!, didSelectLinkWith url: URL!) {
        UIApplication.shared.open(url, options: [: ], completionHandler: nil)
    }
}

extension UserDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.followers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UserTableViewCell = tableView.dequeueReusableCell(withIdentifier: "UserTableViewCell") as! UserTableViewCell
        let searchResult = self.followers[indexPath.row]
        cell.setData(searchResult)
        return cell
    }
}
