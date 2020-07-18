//
//  CustomAlert.swift
//  H&M
//
//  Created by katia kutsi on 7/10/20.
//  Copyright © 2020 TBC. All rights reserved.
//

import UIKit

class CustomAlert: UIView{
    
    let alertMessage: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.numberOfLines = 0
        l.font = Font.MontserratMedium
        l.textAlignment = .center
        return l
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        self.frame = CGRect(x: UIScreen.main.bounds.midX - 100, y: UIScreen.main.bounds.midY - 50, width: 200, height: 100)
        setUpLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.backgroundColor = .white
        setUpLayout()
    }
    
    func setMessage(message: String) {
        alertMessage.text = message
    }
    
    private func setUpLayout() {
        addSubview(alertMessage)
        
        NSLayoutConstraint.activate([
            self.heightAnchor.constraint(equalToConstant: 180),
            self.widthAnchor.constraint(equalToConstant: 300)
        ])
        
        
        NSLayoutConstraint.activate([
            alertMessage.centerYAnchor.constraint(equalTo: centerYAnchor),
            alertMessage.centerXAnchor.constraint(equalTo: centerXAnchor),
            alertMessage.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            alertMessage.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20)
        ])
    }
    
    
}
