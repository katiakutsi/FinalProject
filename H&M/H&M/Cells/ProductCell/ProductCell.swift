//
//  ProductCell.swift
//  H&M
//
//  Created by katia kutsi on 7/8/20.
//  Copyright © 2020 TBC. All rights reserved.
//

import UIKit

class ProductCell: UICollectionViewCell {
    
    public static let identifier = "ProductCell"

    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

}
