//
//  ProductController.swift
//  H&M
//
//  Created by katia kutsi on 7/5/20.
//  Copyright © 2020 TBC. All rights reserved.
//

import UIKit

class ProductController: UIViewController {
    
    @IBOutlet weak var productImagesCollection: UICollectionView!
    @IBOutlet weak var productComposition: UILabel!
    @IBOutlet weak var productArticleNumber: UILabel!
    @IBOutlet weak var selectSize: UIButton!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var productDescription: UILabel!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var sizeView: UIView!
    @IBOutlet weak var ordersIcon: UIButton!
    @IBOutlet weak var favouriteIcon: UIButton!
    @IBOutlet weak var visualEffectView: UIVisualEffectView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var pageIndex = 0
    
    var product: DetailedProduct?
    var productCode: String?
    var productColor: String?
    var productImages = [GalleryDetails]()
    var productOnPage: [ArticlesList]?
    var heightConstraint : NSLayoutConstraint!
    var effect: UIVisualEffect!
    var sizeSelected = false
    var fetched = false
    var isFavorite = false
    
    override func loadView() {
        super.loadView()
        
        setUpConstraints()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBarController?.tabBar.isHidden = true
        
        scrollView.contentInsetAdjustmentBehavior = .never
        visualEffectView.isHidden = true
        effect = visualEffectView.effect
        visualEffectView.effect = nil
        
        productImagesCollection.isPagingEnabled = true
        productImagesCollection.showsHorizontalScrollIndicator = false
        
        productImagesCollection.delegate = self
        productImagesCollection.dataSource = self
        
        productImagesCollection.register(UINib(nibName: ProductImagesCell.identifier, bundle: Bundle.main), forCellWithReuseIdentifier: ProductImagesCell.identifier)
        
        selectSize.layer.borderWidth = 1
        selectSize.layer.borderColor = UIColor.darkGray.cgColor
        
        setUpHeightConstraint()
        
        productComposition.alpha = 0
        productArticleNumber.alpha = 0
        productName.alpha = 0
        productPrice.alpha = 0
        productDescription.alpha = 0
        
        ProductServiceManager.fetchDetailedProduct(code: productCode!) { (detailedProduct) in
            self.product = detailedProduct
            self.fetched = true
            DispatchQueue.main.async {
                if CoreDataHelper.fetchFavourites(email: UDManager.getUser()).contains(where: { $0.code == self.product?.product.code }) {
                    self.favouriteIcon.setImage(ImageName.fillHeart, for: .normal)
                    self.isFavorite = true
                }
                let productViewModel = ProductViewModel(product: self.product!)
                
                self.productComposition.text = productViewModel.productComposition
                self.productArticleNumber.text = productViewModel.productArticleNumber
                self.productName.text = productViewModel.productName
                self.productPrice.text = productViewModel.productPrice
                self.productDescription.text = productViewModel.productDescription
                
                self.productOnPage = self.product?.product.articlesList.filter{ $0.color.text == self.productColor}
                
                self.productImages.append(contentsOf: (self.productOnPage![0].galleryDetails))
                self.productImagesCollection.reloadData()
                
                self.pageControl.numberOfPages = self.productOnPage![0].galleryDetails.count
                
                UIView.animate(withDuration: 0.5) {
                    self.productComposition.alpha = 1
                    self.productArticleNumber.alpha = 1
                    self.productName.alpha = 1
                    self.productPrice.alpha = 1
                    self.productDescription.alpha = 1
                }
                
            }
        }
    }
    
    
    @IBAction func backButton(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func selectSizeButton(_ sender: UIButton) {
        self.heightConstraint.constant = 370
        visualEffectView.isHidden = false
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut, animations: {
            self.visualEffectView.effect = self.effect
            self.view.layoutIfNeeded()
        })
    }
    
    @IBAction func addButton(_ sender: UIButton) {
        if !UDManager.getSigned() {
            let customAlert = CustomAlert()
            customAlert.setMessage(message: "You Must Be Signed In To Add Product In Orders List")
            customAlert.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            customAlert.alpha = 0
            self.view.addSubview(customAlert)
            self.visualEffectView.isHidden = false
            UIView.animate(withDuration: 1, animations: {
                customAlert.transform = CGAffineTransform.identity
                customAlert.alpha = 1
                self.visualEffectView.effect = self.effect
            }) { (f) in
                UIView.animate(withDuration: 1, delay: 2, options: .curveEaseInOut, animations: {
                    
                    customAlert.alpha = 0
                    self.visualEffectView.effect = nil
                    
                }) {(f) in
                    self.visualEffectView.isHidden = true
                }
            }
            
        }
        else if sizeSelected {
            let productView = ProductView()
            let url = productOnPage![0].galleryDetails[0].url.fixUrl()
            productView.setValues(url: url, name: (product?.product.name)!)
            
            productView.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            productView.alpha = 0
            self.view.addSubview(productView)
            
            UIView.animate(withDuration: 0.5, animations: {
                productView.transform = CGAffineTransform.identity
                productView.alpha = 1
            }) { (f) in
                UIView.animate(withDuration: 1, delay: 1, options: .curveEaseInOut, animations: {
                    productView.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
                    productView.frame.origin.x = self.ordersIcon.frame.origin.x - 5
                    productView.frame.origin.y = self.ordersIcon.frame.origin.y + 15
                }) { (f) in
                    UIView.animate(withDuration: 0.5) {
                        productView.alpha = 0
                        Animation.pop(self.ordersIcon)
                    }
                }
            }
            saveOrders()
            
            
        } else {
            let customAlert = CustomAlert()
            customAlert.setMessage(message: "Please Select Size")
            customAlert.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            customAlert.alpha = 0
            self.view.addSubview(customAlert)
            self.visualEffectView.isHidden = false
            UIView.animate(withDuration: 0.5, animations: {
                customAlert.transform = CGAffineTransform.identity
                customAlert.alpha = 1
                self.visualEffectView.effect = self.effect
            }) { (f) in
                UIView.animate(withDuration: 1, delay: 2, options: .curveEaseInOut, animations: {
                    customAlert.alpha = 0
                    self.visualEffectView.effect = nil
                }) {(f) in
                    self.visualEffectView.isHidden = true
                }
            }
        }

    }
    
    @IBAction func xsSize(_ sender: UIButton) {
        hideSizeButton(sender: sender)
        self.visualEffectView.effect = nil
        self.visualEffectView.isHidden = true
        sizeSelected = true

    }
    @IBAction func sSize(_ sender: UIButton) {
        hideSizeButton(sender: sender)
        self.visualEffectView.effect = nil
        self.visualEffectView.isHidden = true
        sizeSelected = true

    }
    @IBAction func mSize(_ sender: UIButton) {
        hideSizeButton(sender: sender)
        self.visualEffectView.effect = nil
        self.visualEffectView.isHidden = true
        sizeSelected = true

    }
    @IBAction func lSize(_ sender: UIButton) {
        hideSizeButton(sender: sender)
        self.visualEffectView.effect = nil
        self.visualEffectView.isHidden = true
        sizeSelected = true

    }
    @IBAction func xlSize(_ sender: UIButton) {
        hideSizeButton(sender: sender)
        self.visualEffectView.effect = nil
        self.visualEffectView.isHidden = true
        sizeSelected = true

    }
    @IBAction func xxlSize(_ sender: UIButton) {
        hideSizeButton(sender: sender)
        self.visualEffectView.effect = nil
        self.visualEffectView.isHidden = true
        sizeSelected = true

    }
    
    @IBAction func favouritesButton(_ sender: UIButton) {
        if !isFavorite {
            
            UIView.animate(withDuration: 0.6, animations: {
                Animation.squeeze(sender)
            }) { (f) in
                UIView.animate(withDuration: 0.5) {
                    sender.setImage(ImageName.fillHeart, for: .normal)
                }
            }
            saveFavourites()
            
        } else {
            UIView.animate(withDuration: 0.6, animations: {
                Animation.squeeze(sender)
            }) { (f) in
                UIView.animate(withDuration: 0.5) {
                    sender.setImage(ImageName.heart, for: .normal)
                }
            }
            for fav in CoreDataHelper.fetchFavourites(email: UDManager.getUser()) {
                if fav.code == product?.product.code {
                    CoreDataHelper.removeFavourite(order: fav)
                }
            }
            
        }
    }

    private func setUpConstraints() {

        sizeView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            sizeView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            sizeView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            sizeView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
        ])
    }

    private func setUpHeightConstraint(){

        heightConstraint = NSLayoutConstraint(item: sizeView as Any, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 0)
        self.view.addConstraint(heightConstraint)
    }
    
    private func hideSizeButton(sender: UIButton) {
        
        self.heightConstraint.constant = 0
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut, animations: {
            self.view.layoutIfNeeded()
        })
        selectSize.setTitle(sender.currentTitle, for: .normal)
    }
    
    
    private func saveOrders(){
        let context = AppDelegate.coreDataContainer.viewContext
        let orderProduct = OrderProduct(context: context)
        
        var user: User?
        
        for u in CoreDataHelper.fetchUsers(){
            if u.email == UDManager.getUser() {
                user = u
            }
        }
        
        orderProduct.code = product?.product.code
        orderProduct.name = product!.product.name
        orderProduct.color = productOnPage![0].color.text
        orderProduct.price = productPrice.text
        orderProduct.size = selectSize.currentTitle
        orderProduct.photo = productOnPage![0].galleryDetails[0].url.fixUrl()
        orderProduct.ownerOrd = user
        
        do{
            try context.save()
        }catch {}
        
    }
    
    private func saveFavourites(){
        
        if CoreDataHelper.fetchFavourites(email: UDManager.getUser()).contains(where: { $0.code == product?.product.code }) || !fetched {
            return
        }
        let context = AppDelegate.coreDataContainer.viewContext
        let favouriteProduct = FavouriteProduct(context: context)
        
        var user: User?
        
        for u in CoreDataHelper.fetchUsers(){
            if u.email == UDManager.getUser() {
                user = u
            }
        }
        
        favouriteProduct.code = product?.product.code
        favouriteProduct.name = product!.product.name
        favouriteProduct.color = productOnPage![0].color.text
        favouriteProduct.price = productPrice.text
        favouriteProduct.size = selectSize.currentTitle
        favouriteProduct.photo = productOnPage![0].galleryDetails[0].url.fixUrl()
        favouriteProduct.ownerFav = user
        
        do{
            try context.save()
        }catch {}
        
    }
    
}

extension ProductController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: productImagesCollection.frame.width, height: productImagesCollection.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

extension ProductController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return productImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = productImagesCollection.dequeueReusableCell(withReuseIdentifier: ProductImagesCell.identifier, for: indexPath) as! ProductImagesCell
        
        let fixedUrl = productOnPage![0].galleryDetails[indexPath.row].url.fixUrl()
        
        fixedUrl.downloadImage(completion: { (image) in
            DispatchQueue.main.async {
                cell.productImage.image = image
            }
        })
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        cell.alpha = 0
        UIView.animate(withDuration: 0.5) {
            cell.alpha = 1
        }
    }
}

extension ProductController: UIScrollViewDelegate{
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let offset = targetContentOffset.pointee
        let x = offset.x
        pageIndex = Int(x / productImagesCollection.frame.width)
        
        if x > productImagesCollection.frame.width{
            pageControl.currentPage = Int(pageIndex + 1)
            pageIndex += 1
        } else{
            pageControl.currentPage = Int(pageIndex)
        }
    }
    
}
