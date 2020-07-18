//
//  TabBarController.swift
//  H&M
//
//  Created by katia kutsi on 7/10/20.
//  Copyright © 2020 TBC. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController, UITabBarControllerDelegate {
    
    var first = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        updateSettingsTab()
//        updateSignInTab()
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(didRecieveSignedIn(with:)),
            name: .SignInID,
            object: nil)
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(didRecieveSignedOut(with:)),
            name: .SignOutID,
            object: nil)
    }
    
    @objc func didRecieveSignedIn(with notification: Notification) {
        updateSettingsTab()
    }
    @objc func didRecieveSignedOut(with notification: Notification) {
        updateSignInTab()
    }
    
    func updateSettingsTab() {
        if UDManager.getSigned() {
            if let viewControllers = self.viewControllers as Array? {
                var controllers = viewControllers
                controllers.removeLast()
                
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let settingsVC = storyboard.instantiateViewController(withIdentifier: StoryboardID.SettingsPage) as! SettingsController
                controllers.append(settingsVC)
                self.setViewControllers(controllers, animated: true)
                let tabBarItem = UITabBarItem(title: "", image: ImageName.profile, selectedImage: ImageName.profile)
                settingsVC.tabBarItem = tabBarItem
            }
        }
    }
    
    func updateSignInTab() {
        if !UDManager.getSigned() {
            if let viewControllers = self.viewControllers as Array? {
                var controllers = viewControllers
                controllers.removeLast()
                
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let signInVC = storyboard.instantiateViewController(withIdentifier: StoryboardID.SignInPage) as! SignInController
                controllers.append(signInVC)
                self.setViewControllers(controllers, animated: true)
                let tabBarItem = UITabBarItem(title: "", image: ImageName.profile, selectedImage: ImageName.profile)
                signInVC.tabBarItem = tabBarItem
            }
        }
    }
    
}
