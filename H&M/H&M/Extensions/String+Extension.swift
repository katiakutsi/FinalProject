//
//  String+Extension.swift
//  H&M
//
//  Created by katia kutsi on 7/5/20.
//  Copyright © 2020 TBC. All rights reserved.
//

import UIKit

extension String {
    
    func downloadImage(completion: @escaping (UIImage?) -> ()) {
        guard let url = URL(string: self) else {return}
        URLSession.shared.dataTask(with: url) { (data, res, err) in
            guard let data = data else {return}
            completion(UIImage(data: data))
        }.resume()
    }
    
    func fixUrl() -> String{
        return self.removingPercentEncoding! + "&call=url[file:/product/main]"
    }
    
}
