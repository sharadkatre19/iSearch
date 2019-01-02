//
//  UserDetailsView.swift
//  iSearch
//
//  Created by Sharad Katre on 31/12/18.
//  Copyright © 2018 Sharad Katre. All rights reserved.
//

import UIKit

class UserDetailsView: UIView {
    
    internal lazy var titleLable: UILabel = {
        let label = UILabel()
        label.frame = CGRect(x: 0, y: 0, width: 80 , height: 40)
        label.text = "Location: "
        label.textColor = UIColor.black
        label.textAlignment = .left
        return label
    }()

    internal lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.frame = CGRect(x: 80, y: 0, width: (self.frame.width / 2), height: 40)
        label.text = "San Martine"
        label.textColor = UIColor.lightGray
        label.textAlignment = .left
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUIComponents()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setupUIComponents() {
        self.addSubview(titleLable)
        self.addSubview(descriptionLabel)
    }
    
    func setData(_ title: String, description: String) {
        self.titleLable.text = title
        self.descriptionLabel.text = description
    }
}
