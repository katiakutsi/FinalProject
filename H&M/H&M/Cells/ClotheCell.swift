//
//  ClotheCell.swift
//  H&M
//
//  Created by katia kutsi on 7/5/20.
//  Copyright © 2020 TBC. All rights reserved.
//

import UIKit

class ClotheCell: UITableViewCell {
    
    public static let identifier = "ClotheCell"

    @IBOutlet weak var clothePhoto: UIImageView!
    @IBOutlet weak var clotheName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
