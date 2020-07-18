//
//  OrdersController.swift
//  H&M
//
//  Created by katia kutsi on 7/6/20.
//  Copyright © 2020 TBC. All rights reserved.
//

import UIKit
import CoreData

class OrdersController: UIViewController {
    
    @IBOutlet weak var ordersCollection: UICollectionView!
    
    var products = [OrderProduct]()
    var selectedProductCode: String?
    var selectedProductColor: String?
    
    var emptyAdded = false
    let empty = EmptyAlert()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBarController?.tabBar.isHidden = false
        
        ordersCollection.register(UINib(nibName: OrderCell.identifier, bundle: Bundle.main), forCellWithReuseIdentifier: OrderCell.identifier)
        
        ordersCollection.delegate = self
        ordersCollection.dataSource = self
        
        ordersCollection.showsVerticalScrollIndicator = false
        
        products = CoreDataHelper.fetchOrders(email: UDManager.getUser())
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        products.removeAll()
        products = CoreDataHelper.fetchOrders(email: UDManager.getUser())
        emptyAlert()
        ordersCollection.reloadData()
        self.tabBarController?.tabBar.isHidden = false
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier, identifier == SegueIdentifier.OrderToProductSegue{
            if let ProductVC = segue.destination as? ProductController {
                ProductVC.productCode = selectedProductCode
                ProductVC.productColor = selectedProductColor
            }
        }
        
    }
    
    
    private func emptyAlert() {
        if products.isEmpty && !emptyAdded {
            empty.isHidden = false
            empty.setMessage(message: "Your shopping bag is empty ")
            empty.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            empty.alpha = 0
            self.view.addSubview(empty)
            UIView.animate(withDuration: 0.5, animations: {
                self.empty.transform = CGAffineTransform.identity
                self.empty.alpha = 1
            })
            
        }else{
            empty.isHidden = true
        }
    }
    
}

extension OrdersController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: ordersCollection.frame.width, height: 177)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 30
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedProductCode = products[indexPath.row].code
        selectedProductColor = products[indexPath.row].color
        performSegue(withIdentifier: SegueIdentifier.OrderToProductSegue, sender: nil)
    }
}
extension OrdersController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return products.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = ordersCollection.dequeueReusableCell(withReuseIdentifier: OrderCell.identifier, for: indexPath) as! OrderCell
        let product = products[indexPath.row]
        cell.code.text = product.code
        cell.color.text = product.color
        cell.price.text = product.price
        cell.total.text = product.price
        cell.productName.text = product.name
        cell.size.text = product.size
        product.photo?.downloadImage(completion: { (image) in
            DispatchQueue.main.async {
                cell.productImage.image = image
            }
        })
        cell.index = indexPath
        cell.delegate = self
        cell.backgroundColor = .white
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        cell.alpha = 0
        UIView.animate(withDuration: 0.5) {
            cell.alpha = 1
        }
    }
}


extension OrdersController: DataCollectionProtocol {
    func deleteData(index: IndexPath) {
        CoreDataHelper.removeOrder(order: products[index.row])
        self.products.remove(at: index.row)
        ordersCollection.deleteItems(at: [index])
        ordersCollection.reloadSections([0])
        emptyAlert()
    }
}
