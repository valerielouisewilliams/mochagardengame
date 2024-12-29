//
//  UserDataManager.swift
//  Mocha Garden
//
//  Created by Valerie Williams on 8/27/23.
//

import Foundation

/**
 This class is responsible for handling the saving and loading of simple user data (days opened and money earned)
 */
class UserDataManager
{
    static let shared = UserDataManager() // singleton instance
    
    private init() {} // constructor
    
    /**
     This function is responsible for saving the money earned by the user.
     */
    func saveMoneyEarned(_ moneyEarned: Int)
    {
        UserDefaults.standard.set(moneyEarned, forKey: "MoneyEarnedKey")
    }
    
    /**
     This function is responsible for saving the user's item inventory.
     */
    func saveInventory(items: [Item])
    {
        // Creating the JSON encoder
        let encoder = JSONEncoder()
        
        do
        {
            let data = try encoder.encode(items)
            
            UserDefaults.standard.set(data, forKey: "inventoryKey")
        }
        catch
        {
            print("Failed to encode inventory: \(error)")
        }
    }
    
    func addItem(newItem: Item)
    {
        var items = loadInventory() ?? [Item]() // load the inventory, if empty create an array for inventory
        
        items.append(newItem)
        
        let encoder = JSONEncoder()
        
        do
        {
            let data = try encoder.encode(items)
            UserDefaults.standard.set(data, forKey: "inventoryKey")
        }
        catch
        {
            print("Failed to encode inventory: \(error)")
        }
    }
    
    func loadInventory() -> [Item]?
    {
        
        if let data = UserDefaults.standard.data(forKey: "inventoryKey")
        {
            let decoder = JSONDecoder()
            
            do
            {
                let items = try decoder.decode([Item].self, from: data)
                return items
            }
            catch
            {
                print("Failed to decode inventory: \(error)")
            }
        }
        
        return nil
        
    }
    
    /**
     This function is responsible for loading the money earned by the user.
     */
    func loadMoneyEarned() -> Int
    {
        return UserDefaults.standard.integer(forKey: "MoneyEarnedKey")
    }
        
    /**
     This function is responsible for saving the 'days' since the café has been open.
     */
    func saveDays(_ daysOpened: Int)
    {
        UserDefaults.standard.set(daysOpened, forKey: "daysOpenedKey")
    }
    
    /**
     This function is responsible for loading the 'days' since the café has been open.
     */
    func loadDays() -> Int
    {
        return UserDefaults.standard.integer(forKey: "daysOpenedKey")
    }

}
