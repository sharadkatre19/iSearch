//
//  UserTableViewCell.swift
//  iSearch
//
//  Created by Sharad Katre on 31/12/18.
//  Copyright © 2018 Sharad Katre. All rights reserved.
//

import UIKit
import SDWebImage

class UserTableViewCell: UITableViewCell {

    @IBOutlet var userImageView: UIImageView!
    @IBOutlet var userNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        userImageView.layer.cornerRadius = self.userImageView.bounds.width / 2
        self.selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setData(_ searchedResult: Items) {
        self.userNameLabel.text = searchedResult.login
        let url = URL.init(string: searchedResult.avatar_url!)
        self.userImageView!.sd_setImage(with: url, placeholderImage: nil, options: .refreshCached, completed: nil)
    }
    
}
