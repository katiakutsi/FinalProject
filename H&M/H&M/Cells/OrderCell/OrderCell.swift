//
//  OrderCell.swift
//  H&M
//
//  Created by katia kutsi on 7/6/20.
//  Copyright © 2020 TBC. All rights reserved.
//

import UIKit

class OrderCell: UICollectionViewCell {
    
    public static let identifier = "OrderCell"
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var code: UILabel!
    @IBOutlet weak var color: UILabel!
    @IBOutlet weak var size: UILabel!
    @IBOutlet weak var total: UILabel!
    
    var delegate: DataCollectionProtocol?
    var index: IndexPath?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    @IBAction func deleteCell(_ sender: UIButton) {
        delegate?.deleteData(index: index!)
    }
}
