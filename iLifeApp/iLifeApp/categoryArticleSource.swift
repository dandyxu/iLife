//
//  categoryArticleSource.swift
//  iLifeApp
//
//  Created by Wenqian Xu on 12/10/2015.
//  Copyright (c) 2015 Wenqian Xu. All rights reserved.
//

import UIKit

class categoryArticleSource {
    
    var article_id: Int?
    var article_title: String?
    
//    func initModel(json:NSDictionary) -> AnyObject {

//        article_id = json.objectForKey("article_id") as? Int
//        article_title = json.objectForKey("article_title") as? String
//        return self
//    }
    init(json:NSDictionary){
        article_id = json["article_id"] as? Int
        article_title = json["article_title"] as? String
    }
}
