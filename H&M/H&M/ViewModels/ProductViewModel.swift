//
//  ProductViewModel.swift
//  H&M
//
//  Created by katia kutsi on 7/6/20.
//  Copyright © 2020 TBC. All rights reserved.
//

import Foundation

struct ProductViewModel {
        
    var productComposition: String
    var productArticleNumber: String
    var productName: String
    var productPrice: String
    var productDescription: String
    
    init(product: DetailedProduct) {
        
        let materialName = product.product.articlesList[0].compositions[0].materials[0].name
        let materialPercentage = product.product.articlesList[0].compositions[0].materials[0].percentage
        let productCode = product.product.code
        let productName = product.product.name
        let price = product.product.whitePrice.price
        
        productComposition = "Composition - \(materialName) \(materialPercentage)%"
        productArticleNumber = "Article Number - \(productCode)"
        self.productName = productName
        productPrice = "$\(price)"
        productDescription = product.product.description
    }
    
}
