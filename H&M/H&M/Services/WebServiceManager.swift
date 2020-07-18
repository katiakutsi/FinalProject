//
//  WebServiceManager.swift
//  H&M
//
//  Created by katia kutsi on 7/5/20.
//  Copyright © 2020 TBC. All rights reserved.
//

import Foundation

class WebServiceManager {
    
    public static let shared = WebServiceManager()
    private init() {}
    
    typealias CompletionBlock<T: Codable> = (Result<T, Error>) -> ()
    
    enum HTTPMethod: String {
        case GET = "GET"
    }
    
    func get<T: Codable>(url: String, completion: @escaping CompletionBlock<T>) {
        
        let headers = [
            "x-rapidapi-host": "apidojo-hm-hennes-mauritz-v1.p.rapidapi.com",
            "x-rapidapi-key": "1349ecfbadmsh7f6537a0614dabbp18529djsn994ca43c6365"
        ]

        
        let request = NSMutableURLRequest(url: NSURL(string: url)! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        
        request.httpMethod = HTTPMethod.GET.rawValue
        request.allHTTPHeaderFields = headers
        
        URLSession.shared.dataTask(with: request as URLRequest){ (data, res, err) in
            
            if let err = err {
                completion(.failure(err))
            }
            
            do {
                guard let data = data else {return}
                let decoder = JSONDecoder()
                let decoded = try decoder.decode(T.self, from: data)
                
                completion(.success(decoded))
            } catch let err {
                completion(.failure(err))
            }
            
        }.resume()
    }
    
}
