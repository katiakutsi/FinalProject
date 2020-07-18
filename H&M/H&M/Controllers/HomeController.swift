//
//  HomeController.swift
//  H&M
//
//  Created by katia kutsi on 7/4/20.
//  Copyright © 2020 TBC. All rights reserved.
//

import UIKit

class HomeController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var mainPoster: DetailedProduct?
    var products = [Product]()
    var selectedProductCode: String?
    var selectedProductColor: String?
    var selectedTrendingCell: TrendingCell?
    var selectedCategoryCell: CategoryCell?
    var selectedCategory: Category?
    
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(UDManager.getUser())
        print(UDManager.getSigned())
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
                
        ProductServiceManager.fetchProducts { (productsResponse) in
            self.products.append(contentsOf: productsResponse.products)
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        
        ProductServiceManager.fetchDetailedProduct(code: "0889370002") { (detailedProduct) in
            DispatchQueue.main.async {
                self.mainPoster = detailedProduct
                self.tableView.reloadData()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    
    @IBAction func showLocations(_ sender: UIButton) {
        performSegue(withIdentifier:SegueIdentifier.SecondMapSegue, sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier, identifier == SegueIdentifier.ProductSegue {
            if let ProductVC = segue.destination as? ProductController {
                ProductVC.productCode = selectedProductCode
                ProductVC.productColor = selectedProductColor
            }
        }
        
        if let identifier = segue.identifier, identifier == SegueIdentifier.ProductsSegue {
            if let ProductsVC = segue.destination as? ProductsController {
                ProductsVC.selectedCategory = selectedCategory
            }
        }
    }
}

extension HomeController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0{
            return 390
        }
        if indexPath.row == 1{
            return 230
        }
        if indexPath.row == 2 {
            return 415
        }
        return 414
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            selectedProductCode = "0889370002"
            selectedProductColor = mainPoster?.product.articlesList[0].color.text
        }
        if indexPath.row > 2 {
            selectedProductCode = products[indexPath.row].articles[0].code
            selectedProductColor = products[indexPath.row].articles[0].color.text
        }
        performSegue(withIdentifier: SegueIdentifier.ProductSegue, sender: nil)

    }
}

extension HomeController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: HeaderCell.identifier, for: indexPath) as! HeaderCell
            
            if let posterName = mainPoster?.product.name {
                cell.catName.text = posterName
            }
            
            let fixedUrl = mainPoster?.product.articlesList[0].galleryDetails[0].url.fixUrl()
            
            fixedUrl?.downloadImage(completion: { (image) in
                DispatchQueue.main.async {
                    cell.catPhoto.image = image
                }
            })
            
            
            return cell
        }
        
        if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: TrendingTableCell.identifier, for: indexPath) as! TrendingTableCell
            
            cell.didSelectItemAction = { [weak self] product, trendingCell in
                self?.selectedProductCode = product.articles[0].code
                self?.selectedProductColor = product.articles[0].color.text
                self?.selectedTrendingCell = trendingCell
                self?.performSegue(withIdentifier: SegueIdentifier.ProductSegue, sender: nil )
                
            }
            return cell
        }
        
        if indexPath.row == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: CategoriesCell.identifier, for: indexPath) as! CategoriesCell
            
            cell.didSelectItemAction = { [weak self] category, categoryCell in
                self?.selectedCategory = category
                self?.selectedCategoryCell = categoryCell
                self?.performSegue(withIdentifier: SegueIdentifier.ProductsSegue, sender: nil )
            }
            
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: ClotheCell.identifier, for: indexPath) as! ClotheCell
        let product = products[indexPath.row]
        cell.clotheName.text = product.name
        product.articles[0].logoPicture[0].url.downloadImage { (image) in
            DispatchQueue.main.async {
                cell.clothePhoto.image = image
            }
        }
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.alpha = 0
        UIView.animate(withDuration: 0.5) {
            cell.alpha = 1
        }
    }
}

