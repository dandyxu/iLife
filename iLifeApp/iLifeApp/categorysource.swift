//
//  categorysource.swift
//  iLifeApp
//
//  Created by Wenqian Xu on 30/09/2015.
//  Copyright (c) 2015 Wenqian Xu. All rights reserved.
//

import UIKit

class categorysource {
    
    var category_id: Int?
    var category_name: String?
    
    init(json:NSDictionary) {
        self.category_id = json["id"] as? Int
        self.category_name = json["name"] as? String
    }
}
