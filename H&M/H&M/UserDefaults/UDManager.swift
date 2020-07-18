//
//  UDManager.swift
//  H&M
//
//  Created by katia kutsi on 7/9/20.
//  Copyright © 2020 TBC. All rights reserved.
//

import Foundation

class UDManager {
    internal static let SIGNED = "SIGNED"
    private static let CURRENTUSER = "CURRENT_USER"
    
    static func getUD() -> UserDefaults{
        return UserDefaults.standard
    }
    
    static func setSigned(value: Bool) {
        return getUD().set(value, forKey: SIGNED)
    }
    
    static func getSigned() -> Bool {
        return getUD().bool(forKey: SIGNED)
    }
    
    static func setUser(value: String) {
        return getUD().set(value, forKey: CURRENTUSER)
    }
    
    static func getUser() -> String {
        return getUD().string(forKey: CURRENTUSER) ?? "NO user"
    }
}
