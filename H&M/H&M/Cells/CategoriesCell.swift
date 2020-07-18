//
//  CategoriesCell.swift
//  H&M
//
//  Created by katia kutsi on 7/5/20.
//  Copyright © 2020 TBC. All rights reserved.
//

import UIKit

class CategoriesCell: UITableViewCell {
    
    public static let identifier = "CategoriesCell"
    
    @IBOutlet weak var categoriesTable: UITableView!
    
    var didSelectItemAction: ((Category, CategoryCell) -> Void)?
    var delegate: CellDelegator!
    
    var categories = [Category]()
    var selectedCategory: Category?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        categoriesTable.delegate = self
        categoriesTable.dataSource = self
        categoriesTable.separatorStyle = .none
        categoriesTable.showsVerticalScrollIndicator = false
        
        ProductServiceManager.fetchCategories { (categoriesArray) in
            self.categories.append(contentsOf: categoriesArray)
            self.categories.removeLast(2)
            DispatchQueue.main.async {
                self.categoriesTable.reloadData()
            }
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}

extension CategoriesCell: UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        didSelectItemAction?(categories[indexPath.row], tableView.cellForRow(at: indexPath) as! CategoryCell)
    }
}
extension CategoriesCell: UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CategoryCell.identifier, for: indexPath) as! CategoryCell
        cell.categoryName.text = categories[indexPath.row].catName
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.alpha = 0
        UIView.animate(withDuration: 0.5) {
            cell.alpha = 1
        }
    }
}
