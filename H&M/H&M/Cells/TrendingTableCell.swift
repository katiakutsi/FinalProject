//
//  TrendingTableCell.swift
//  H&M
//
//  Created by katia kutsi on 7/4/20.
//  Copyright © 2020 TBC. All rights reserved.
//

import UIKit

class TrendingTableCell: UITableViewCell {
    
    public static let identifier = "TrendingTableCell"
    
    @IBOutlet weak var trendingCollection: UICollectionView!
    var didSelectItemAction: ((Product, TrendingCell) -> Void)?

    
    var products = [Product]()
    var selectedProductCode: String?
    var selectedProductColor: String?
    var delegate: CellDelegator!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        trendingCollection.delegate = self
        trendingCollection.dataSource = self
        trendingCollection.showsHorizontalScrollIndicator = false
        
        trendingCollection.register(UINib(nibName: TrendingCell.identifier, bundle: Bundle.main), forCellWithReuseIdentifier: TrendingCell.identifier)
        
        ProductServiceManager.fetchProducts { (productsResponse) in
            self.products.append(contentsOf: productsResponse.products)
            self.products.shuffle()
            DispatchQueue.main.async {
                self.trendingCollection.reloadData()
            }
        }
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}

extension TrendingTableCell : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: trendingCollection.frame.width / 3, height: trendingCollection.frame.height)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 31
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0)
    }
    
}

extension TrendingTableCell : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return products.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = trendingCollection.dequeueReusableCell(withReuseIdentifier: TrendingCell.identifier, for: indexPath) as! TrendingCell
        let product = products[indexPath.row]
        
        product.articles[0].logoPicture[0].url.downloadImage { (image) in
            DispatchQueue.main.async {
                cell.catPhoto.image = image
            }
        }
        cell.catName.text = product.categoryName
        cell.clotheName.text = product.name
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        cell.alpha = 0
        UIView.animate(withDuration: 0.5) {
            cell.alpha = 1
        }
    }
}

extension TrendingTableCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        didSelectItemAction?(products[indexPath.row], collectionView.cellForItem(at: indexPath) as! TrendingCell)
    }
}
