//
//  Product.swift
//  H&M
//
//  Created by katia kutsi on 7/5/20.
//  Copyright © 2020 TBC. All rights reserved.
//

import Foundation

struct Product: Codable {
    let name: String
    let images: [Images]
    let categoryName: String?
    let articles: [Articles]
    let price: Price
}

struct Images: Codable {
    let url: String
}

struct ProductsResponse: Codable{
    let products: [Product]
    
    enum CodingKeys: String, CodingKey {
        case products = "results"
    }
}
struct Articles: Codable {
    let code: String
    let color: Color
    let logoPicture: [Images]
}

struct Color: Codable {
    let text: String
}
struct Price: Codable {
    let value: Double
}
