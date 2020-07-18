//
//  FetchObjects.swift
//  H&M
//
//  Created by katia kutsi on 7/9/20.
//  Copyright © 2020 TBC. All rights reserved.
//

import Foundation
import CoreData

struct CoreDataHelper {
    
    static func fetchUsers() -> [User]{
        let context = AppDelegate.coreDataContainer.viewContext
        let request: NSFetchRequest<User> = User.fetchRequest()
        
        do{
            let result = try context.fetch(request)
            let users = result as [User]
            return users
        }catch{}
        return []
    }
    
    static func fetchOrders(email: String) -> [OrderProduct]{
        let context = AppDelegate.coreDataContainer.viewContext
        let request: NSFetchRequest<User> = User.fetchRequest()
        
        var user: User?
        
        do{
            let result = try context.fetch(request)
            let users = result as [User]
            
            for u in users{
                if u.email == email {
                    user = u
                }
            }
            
            return (user?.orders?.allObjects as NSArray?) as? [OrderProduct] ?? []
        }catch{}
        return []
    }
    
    static func fetchFavourites(email: String) -> [FavouriteProduct]{
        let context = AppDelegate.coreDataContainer.viewContext
        let request: NSFetchRequest<User> = User.fetchRequest()
        
        var user: User?
        
        do{
            let result = try context.fetch(request)
            let users = result as [User]
            
            for u in users{
                if u.email == email {
                    user = u
                }
            }
            
            return (user?.favourites?.allObjects as NSArray?) as? [FavouriteProduct] ?? []
        }catch{}
        return []
    }
    
    static func removeOrder(order: OrderProduct) {
        let context = AppDelegate.coreDataContainer.viewContext
        context.delete(order)
        do {
            try context.save()
        } catch {
        }
    }
    
    static func removeFavourite(order: FavouriteProduct) {
        let context = AppDelegate.coreDataContainer.viewContext
        context.delete(order)
        do {
            try context.save()
        } catch {
        }
    }
}
