//
//  ProductsController.swift
//  H&M
//
//  Created by katia kutsi on 7/8/20.
//  Copyright © 2020 TBC. All rights reserved.
//

import UIKit

class ProductsController: UIViewController {
    @IBOutlet weak var categoryLabel: UILabel!
    
    @IBOutlet weak var productsCollection: UICollectionView!
    
    var products = [Product]()
    var filteredProducts = [Product]()
    var selectedCategory: Category?
    var selectedProductCode: String?
    var selectedProductColor: String?
    var catName: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        categoryLabel.text = selectedCategory?.catName
        
        if self.selectedCategory?.catName == "Women" {
            catName = "Ladies"
        }else {
            catName = self.selectedCategory!.catName
        }
                
        ProductServiceManager.fetchProducts { (productsResponse) in
            self.products.append(contentsOf: productsResponse.products)
            DispatchQueue.main.async {
                
                self.filteredProducts = self.products.filter{$0.categoryName == self.catName}
                self.productsCollection.reloadData()
            }
        }
        
        productsCollection.register(UINib(nibName: ProductCell.identifier, bundle: Bundle.main), forCellWithReuseIdentifier: ProductCell.identifier)
        
        productsCollection.delegate = self
        productsCollection.dataSource = self
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
    
    @IBAction func backButton(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier, identifier == SegueIdentifier.DetailedProductSegue {
            if let ProductVC = segue.destination as? ProductController {
                ProductVC.productCode = selectedProductCode
                ProductVC.productColor = selectedProductColor
            }
        }
    }
}

extension ProductsController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: productsCollection.frame.width/2 - 50, height: 340)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 20, bottom: 0, right: 20)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedProductCode = filteredProducts[indexPath.row].articles[0].code
        selectedProductColor = filteredProducts[indexPath.row].articles[0].color.text
        performSegue(withIdentifier: SegueIdentifier.DetailedProductSegue, sender: nil)
    }
}

extension ProductsController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredProducts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = productsCollection.dequeueReusableCell(withReuseIdentifier: ProductCell.identifier, for: indexPath) as! ProductCell
        let product = filteredProducts[indexPath.row]
        
        cell.productName.text = product.name
        cell.productPrice.text = "$\(product.price.value)"
        
        product.articles[0].logoPicture[0].url.downloadImage { (image) in
            DispatchQueue.main.async {
                cell.productImage.image = image
            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        cell.alpha = 0
        UIView.animate(withDuration: 0.5) {
            cell.alpha = 1
        }
    }
}
