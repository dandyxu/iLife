//
//  articlesource.swift
//  iLifeApp
//
//  Created by Wenqian Xu on 01/10/2015.
//  Copyright (c) 2015 Wenqian Xu. All rights reserved.
//

import UIKit

class articlesource {
    
    var article_id: Int?
    var article_title: String?
    var article_icon: String?
    var is_top: Int?
    var created_at: String?
    var updated_at: String?
    
    init(json:NSDictionary) {
        
        self.article_id = json["article_id"] as? Int
        self.article_title = json["title"] as? String
        self.article_icon = json["image_url"] as? String
        self.is_top = json["is_top"] as? Int
        self.created_at = json["created_at"] as? String
        self.updated_at = json["updated_at"] as? String
        
    }
}