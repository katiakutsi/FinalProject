//
//  ProductServiceManager.swift
//  H&M
//
//  Created by katia kutsi on 7/5/20.
//  Copyright © 2020 TBC. All rights reserved.
//

import Foundation

class ProductServiceManager {
    
    static func fetchCategories(completion: @escaping ([Category]) -> ()){
        fetchCat { categories in
            completion(categories)
        }
    }
    
    static func fetchCat(completion: @escaping ([Category]) -> ()) {
        WebServiceManager.shared.get(url: "https://apidojo-hm-hennes-mauritz-v1.p.rapidapi.com/categories/list?country=us&lang=en") { (result: Result<[Category], Error>) in
            switch result {
            case .success(let categories):
                completion(categories)
            case .failure(let err):
                
                if (err as NSError).code == 4864 {
                    self.fetchCat { categories in
                        completion(categories)
                    }
                }
            }
        }
    }
    
    static func fetchProducts(completion: @escaping (ProductsResponse) -> ()) {
        WebServiceManager.shared.get(url: "https://apidojo-hm-hennes-mauritz-v1.p.rapidapi.com/products/list?country=us&lang=en&currentpage=0&pagesize=30") { (result: Result<ProductsResponse, Error>) in
            switch result {
            case .success(let productResponse):
                completion(productResponse)
            case .failure:
                print("second try")
                WebServiceManager.shared.get(url: "https://apidojo-hm-hennes-mauritz-v1.p.rapidapi.com/products/list?country=us&lang=en&currentpage=0&pagesize=30") { (result: Result<ProductsResponse, Error>) in
                    switch result {
                    case .success(let productResponse):
                        completion(productResponse)
                    case .failure(let err):
                        print("meorejerac ver shedzlo :( : \(err)")                    }
                }
            }
        }
    }
    
    static func fetchDetailedProduct(code: String, completion: @escaping (DetailedProduct) ->()) {
        WebServiceManager.shared.get(url: "https://apidojo-hm-hennes-mauritz-v1.p.rapidapi.com/products/detail?country=us&lang=en&productcode=\(code)") { (result: Result<DetailedProduct,Error>) in
            switch result {
            case .success(let detailedProduct):
                completion(detailedProduct)
            case .failure:
                print("second try")
                WebServiceManager.shared.get(url: "https://apidojo-hm-hennes-mauritz-v1.p.rapidapi.com/products/detail?country=us&lang=en&productcode=\(code)") { (result: Result<DetailedProduct, Error>) in
                    switch result {
                    case .success(let detailedProduct):
                        completion(detailedProduct)
                    case .failure(let err):
                        print("meorejerac ver shedzlo :( : \(err)")                    }
                }
            }
        }
    }
    
}
