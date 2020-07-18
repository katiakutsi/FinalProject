//
//  SearchController.swift
//  H&M
//
//  Created by katia kutsi on 7/8/20.
//  Copyright © 2020 TBC. All rights reserved.
//

import UIKit

class SearchController: UIViewController {

    @IBOutlet weak var searchedProductsCollection: UICollectionView!
    @IBOutlet weak var searchField: UITextField!
    
    var products = [Product]()
    var filteredProducts = [Product]()
    var selectedProductCode: String?
    var selectedProductColor: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchField.addTarget(self, action: #selector(editingChangedForSearchField(_:)), for: .editingChanged)
        
        searchedProductsCollection.delegate = self
        searchedProductsCollection.dataSource = self
        
        ProductServiceManager.fetchProducts { (productsResponse) in
            self.products.append(contentsOf: productsResponse.products)
            self.filteredProducts = self.products
            DispatchQueue.main.async {
                self.searchedProductsCollection.reloadData()
            }
        }
        
        searchedProductsCollection.register(UINib(nibName: ProductCell.identifier, bundle: Bundle.main), forCellWithReuseIdentifier: ProductCell.identifier)
        
        
        
    }

    @IBAction func showLocations(_ sender: UIButton) {
        performSegue(withIdentifier: SegueIdentifier.MapSegue, sender: nil)
    }
    
    @objc func editingChangedForSearchField(_ sender: UITextField) {

        guard let searchText = sender.text else {return}
        if searchText.isEmpty == false {
            filteredProducts = products.filter{$0.name.lowercased().contains(searchText.lowercased())}
            searchedProductsCollection.reloadData()
        }else {
            filteredProducts = products
            searchedProductsCollection.reloadData()
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier, identifier == SegueIdentifier.SearchSegue {
            if let ProductVC = segue.destination as? ProductController {
                ProductVC.productCode = selectedProductCode
                ProductVC.productColor = selectedProductColor
            }
        }
    }
    
}

extension SearchController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: searchedProductsCollection.frame.width/2 - 50, height: 340)
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
        performSegue(withIdentifier: SegueIdentifier.SearchSegue, sender: nil)
    }
}

extension SearchController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredProducts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = searchedProductsCollection.dequeueReusableCell(withReuseIdentifier: ProductCell.identifier, for: indexPath) as! ProductCell
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
