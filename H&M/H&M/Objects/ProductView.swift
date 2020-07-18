//
//  ProductView.swift
//  H&M
//
//  Created by katia kutsi on 7/6/20.
//  Copyright © 2020 TBC. All rights reserved.
//

import UIKit

class ProductView: UIView {
    
    let imageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    let productName: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.text = "Full Name"
        l.numberOfLines = 0
        l.font = Font.MontserratMedium
        return l
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        self.frame = CGRect(x: UIScreen.main.bounds.midX - 175, y: UIScreen.main.bounds.midY - 115, width: 350, height: 230)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.backgroundColor = .white
        self.frame = CGRect(x: UIScreen.main.bounds.midX - 175, y: UIScreen.main.bounds.midY - 115, width: 350, height: 230)
        setupLayout()
    }
    
    private func setupLayout() {
        addSubview(imageView)
        addSubview(productName)
        
        NSLayoutConstraint.activate([
            self.heightAnchor.constraint(equalToConstant: 180),
            self.widthAnchor.constraint(equalToConstant: 300)
        ])
        
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: 128),
            imageView.heightAnchor.constraint(equalToConstant: 195),
            imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            imageView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            productName.centerYAnchor.constraint(equalTo: centerYAnchor),
            productName.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 20),
            productName.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20)
        ])
        
        
    }
    
    func setValues(url: String, name: String) {
        url.downloadImage(completion: { (image) in
            DispatchQueue.main.async {
                self.imageView.image = image
            }
        })
        
        self.productName.text = name

    }
    
}
