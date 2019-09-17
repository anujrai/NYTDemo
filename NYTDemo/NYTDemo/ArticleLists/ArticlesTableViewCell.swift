//
//  ArticlesTableViewCell.swift
//  NYTDemo
//
//  Created by Anuj Rai on 17/09/19.
//  Copyright © 2019 Anuj Rai. All rights reserved.
//

import UIKit

class ArticlesTableViewCell: UITableViewCell {
    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var datePublishedLabel: UILabel!
    
    func configure(title: String?, date: String?) {
        self.titleLabel.text = title
        self.datePublishedLabel.text = date
    }
}
