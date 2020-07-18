//
//  SettingsController.swift
//  H&M
//
//  Created by katia kutsi on 7/5/20.
//  Copyright © 2020 TBC. All rights reserved.
//

import UIKit

class SettingsController: UIViewController {
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var firstName: UILabel!
    @IBOutlet weak var lastName: UILabel!
    
    var signedUser: User?


    override func viewDidLoad() {
        super.viewDidLoad()
        let user = CoreDataHelper.fetchUsers().filter{$0.email == UDManager.getUser()}
        
        
        
        email.text = user[0].email
        firstName.text = user[0].firstName
        lastName.text = user[0].lastName
    }
    
    @IBAction func logOut(_ sender: UIButton) {
        UDManager.setSigned(value: false)
        UDManager.setUser(value: "NO USER")
        NotificationCenter.default.post(name: .SignOutID, object: nil)
    }
    
   
}
