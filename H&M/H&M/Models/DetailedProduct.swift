//
//  DetailedProduct.swift
//  H&M
//
//  Created by katia kutsi on 7/5/20.
//  Copyright © 2020 TBC. All rights reserved.
//

import Foundation

struct DetailedProduct: Codable {
    let product: ProductField
}

struct ProductField: Codable {
    let code: String
    let whitePrice: WhitePrice
    let name: String
    let description: String
    let articlesList: [ArticlesList]
}

struct WhitePrice: Codable {
    let price: Double
}

struct ArticlesList: Codable {
    let color: Color
    let galleryDetails: [GalleryDetails]
    let variantsList: [VariantList]
    let compositions: [Compositions]
}

struct GalleryDetails: Codable{
    let url: String
}

struct VariantList: Codable{
    let size: Size?
}

struct Size: Codable{
    let name: String
}

struct Compositions: Codable{
    let materials: [Materials]
}

struct Materials: Codable{
    let name: String
    let percentage: String
}
