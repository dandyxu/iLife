//
//  articlesource.swift
//  iLifeApp
//
//  Created by Wenqian Xu on 01/10/2015.
//  Copyright (c) 2015 Wenqian Xu. All rights reserved.
//

import UIKit

class articlesource {
    
    var article_id: String?
    var article_title: String?
    var article_icon: String?
    
    init(json:NSDictionary) {
        self.article_id = json["id"] as? String
        self.article_title = json["title"] as? String
        self.article_icon = json["title_icon"] as? String
    }
}