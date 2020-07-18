//
//  SignInController.swift
//  H&M
//
//  Created by katia kutsi on 7/5/20.
//  Copyright © 2020 TBC. All rights reserved.
//

import UIKit
import CoreData

class SignInController: UIViewController {
    
    @IBOutlet weak var inputEmail: UITextField!
    @IBOutlet weak var inputPassword: UITextField!
    @IBOutlet weak var becomeMember: UIButton!
    @IBOutlet weak var visualEffectView: UIVisualEffectView!
    
    var user: User?
    var hidden = true
    var effect: UIVisualEffect!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        becomeMember.layer.borderColor = UIColor.black.cgColor
        becomeMember.layer.borderWidth = 2
        
        inputPassword.setRightView(size: 55)
        inputEmail.setLeftView(size: 10)
        inputPassword.setLeftView(size: 10)
        
        visualEffectView.isHidden = true
        effect = visualEffectView.effect
        visualEffectView.effect = nil
    }
    
    @IBAction func signInButton(_ sender: UIButton) {
        var userExist = false
        
        for item in CoreDataHelper.fetchUsers(){
            if item.email == self.inputEmail.text && item.password == self.inputPassword.text{
                UDManager.setSigned(value: true)
                if let e = inputEmail.text {
                    UDManager.setUser(value: e)
                }
                inputPassword.text = ""
                inputEmail.text = ""
                userExist = true
                NotificationCenter.default.post(name: .SignInID, object: nil)
                break
            }
        }
        if inputEmail.text!.isEmpty || inputPassword.text!.isEmpty{
            annimation(message: "Please, Fill all Fields ... ")
        }else if !userExist{
            annimation(message: "Email Or Password Is Incorrect :(")
        }
        
        
        
        inputEmail.text = ""
        inputPassword.text = ""
    }
    
    @IBAction func signUpButton(_ sender: UIButton) {
    }
    
    @IBAction func showAndHide(_ sender: UIButton) {
        if !hidden {
            sender.setTitle("SHOW", for: .normal)
            inputPassword.isSecureTextEntry = true
            hidden = true
        } else {
            sender.setTitle("HIDE", for: .normal)
            inputPassword.isSecureTextEntry = false
            hidden = false
        }
    }
    
    private func annimation(message: String) {
        let customAlert = CustomAlert()
        customAlert.setMessage(message: message)
        customAlert.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        customAlert.alpha = 0
        self.view.addSubview(customAlert)
        self.visualEffectView.isHidden = false
        UIView.animate(withDuration: 0.5, animations: {
            customAlert.transform = CGAffineTransform.identity
            customAlert.alpha = 1
            self.visualEffectView.effect = self.effect
        }) { (f) in
            UIView.animate(withDuration: 0.5, delay: 0.5, options: .curveEaseInOut, animations: {
                
                customAlert.alpha = 0
                self.visualEffectView.effect = nil
                
            }) {(f) in
                self.visualEffectView.isHidden = true
            }
        }
    }
}
