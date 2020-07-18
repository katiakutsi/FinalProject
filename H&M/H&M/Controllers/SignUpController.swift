//
//  SignUpController.swift
//  H&M
//
//  Created by katia kutsi on 7/5/20.
//  Copyright © 2020 TBC. All rights reserved.
//

import UIKit

class SignUpController: UIViewController {
    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    
    var hidden = true

    
    override func viewDidLoad() {
        super.viewDidLoad()
        password.setRightView(size: 55)
        firstName.setLeftView(size: 10)
        lastName.setLeftView(size: 10)
        email.setLeftView(size: 10)
        password.setLeftView(size: 10)
        
        print(try! FileManager.default.url(for: .documentationDirectory, in: .allDomainsMask, appropriateFor: nil, create: false))

    }
    
    @IBAction func backButton(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func signUpButton(_ sender: UIButton) {
        saveUser()
        UDManager.setSigned(value: true)
        if let e = email.text {
            UDManager.setUser(value: e)
        }

        NotificationCenter.default.post(name: .SignInID, object: nil)
    }
    @IBAction func showAndHide(_ sender: UIButton) {
        if !hidden {
            sender.setTitle("SHOW", for: .normal)
            password.isSecureTextEntry = true
            hidden = true
        } else {
            sender.setTitle("HIDE", for: .normal)
            password.isSecureTextEntry = false
            hidden = false
        }
    }
    
    private func saveUser(){
        let context = AppDelegate.coreDataContainer.viewContext
        let user = User(context: context)
        user.firstName = firstName.text
        user.lastName = lastName.text
        user.email = email.text
        user.password = password.text
        
        do{
            try context.save()
        }catch {}
    }
    
}
