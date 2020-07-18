//
//  CustomCategoryCell.swift
//  H&M
//
//  Created by katia kutsi on 7/7/20.
//  Copyright © 2020 TBC. All rights reserved.
//

import UIKit

class CustomCategoryCell: UITableViewCell {
    
    public static let identifier = "CustomCategoryCell"

    @IBOutlet weak var cutsomCategory: UILabel!
        
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
