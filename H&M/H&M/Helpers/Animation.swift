//
//  Animations.swift
//  H&M
//
//  Created by katia kutsi on 7/7/20.
//  Copyright © 2020 TBC. All rights reserved.
//

import UIKit

struct Animation {
    public static func pop(_ item : UIButton){
        item.transform = CGAffineTransform(scaleX: 0.8, y: 1.2)
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.1, initialSpringVelocity: 15, options: [],  animations: {
            item.transform = .identity
        })
    }
    
    public static func squeeze(_ item: UIButton){
        UIView.animate(withDuration: 0.3,
                       animations: {
                        item.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
        },
                       completion: { _ in
                        UIView.animate(withDuration: 0.3) {
                            item.transform = CGAffineTransform.identity
                        }
        })
    }
}
