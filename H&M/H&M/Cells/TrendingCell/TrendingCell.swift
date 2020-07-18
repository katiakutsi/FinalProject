//
//  TrendingCell.swift
//  H&M
//
//  Created by katia kutsi on 7/4/20.
//  Copyright © 2020 TBC. All rights reserved.
//

import UIKit

class TrendingCell: UICollectionViewCell {
    
    public static let identifier = "TrendingCell"
    
    @IBOutlet weak var catPhoto: UIImageView!
    @IBOutlet weak var catName: UILabel!
    @IBOutlet weak var clotheName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        catPhoto.layer.cornerRadius = catPhoto.frame.width/2
        
    }

}
