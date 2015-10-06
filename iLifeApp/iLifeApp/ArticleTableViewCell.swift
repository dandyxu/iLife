//
//  ArticleTableViewCell.swift
//  iLifeApp
//
//  Created by Wenqian Xu on 06/10/2015.
//  Copyright (c) 2015 Wenqian Xu. All rights reserved.
//

import UIKit

class ArticleTableViewCell:UITableViewCell {
    
    @IBOutlet weak var title_icon: UIImageView!
    
    @IBOutlet weak var title: UILabel!
    
    @IBOutlet weak var created_at: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        //configure the view for selected state
    }
    
}
