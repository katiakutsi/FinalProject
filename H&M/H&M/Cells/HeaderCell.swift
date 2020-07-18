//
//  HeaderCell.swift
//  H&M
//
//  Created by katia kutsi on 7/4/20.
//  Copyright © 2020 TBC. All rights reserved.
//

import UIKit

class HeaderCell: UITableViewCell {
    
    public static let identifier = "HeaderCell"
    
    @IBOutlet weak var catPhoto: UIImageView!
    @IBOutlet weak var catName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
