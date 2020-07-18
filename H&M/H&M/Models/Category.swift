//
//  Category.swift
//  H&M
//
//  Created by katia kutsi on 7/5/20.
//  Copyright © 2020 TBC. All rights reserved.
//

import Foundation

struct Category: Codable {
    let catName, categoryValue: String
    let categoriesArray: [Category]?
    let tagCodes: [String]

    enum CodingKeys: String, CodingKey {
        case catName = "CatName"
        case categoryValue = "CategoryValue"
        case categoriesArray = "CategoriesArray"
        case tagCodes
    }
}
