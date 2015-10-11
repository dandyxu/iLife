//
//  CategoryTableViewCell.swift
//  iLifeApp
//
//  Created by Wenqian Xu on 10/10/2015.
//  Copyright (c) 2015 Wenqian Xu. All rights reserved.
//

import UIKit

class CategoryTableViewCell: UITableViewCell{
    
    @IBOutlet weak var category_name_title: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        //configure the view for selected state
    }
}
