//
//  Drink.swift
//  Cafe Fleur
//
//  Created by Valerie Williams on 5/31/23.
//

import Foundation

class Drink
{
    
    // static data members
    var baseOptions: [String] = ["coffee", "matcha", "chai"]
    var toppingOptions: [String] = ["stardust", "rose", "sweetcream", "cherry"]
    
    // data members
    var name: String
    var base: String
    var topping: String
    var price: Int
    var isOrder: Bool
    
    // functions start
    
    /**
     This constructor creates a Drink object.
     */
    init(isOrder: Bool)
    {
        
        // customer order
        if (isOrder == true)
        {
            let baseIndex = Int.random(in: 0..<3)
            let toppingIndex = Int.random(in: 0..<4)
            
            self.isOrder = isOrder
            self.base = baseOptions[baseIndex]
            self.topping = toppingOptions[toppingIndex]
            
            price = Int.random(in: 3..<8)
            
            name = ""
            name = nameBuilder()
        }
        else // user made drink
        {
            self.isOrder = isOrder
            self.base = "undefined"
            self.topping = "undefined"
            price = 0
            name = ""
        }
        
    }
    
    /**
     This function is used to create a random drink, used mainly for customer orders.
     */
    func randomize()
    {
        
        let baseIndex = Int.random(in: 0..<3)
        let toppingIndex = Int.random(in: 0..<3)
        
        self.isOrder = true
        self.base = baseOptions[baseIndex]
        self.topping = toppingOptions[toppingIndex]
        
        price = Int.random(in: 3..<8)
        
        name = ""
        name = nameBuilder()
        
    }
        
    /**
     This function builds the name of the drink from its characteristics.
     */
    func nameBuilder() -> String
    {
        var nameCreated: String
        nameCreated = ""
        
        switch self.topping
        {
        case "stardust":
            nameCreated = "stardust "
        case "rose":
            nameCreated = "rose "
        case "cherry":
            nameCreated = "cherry "
        case "sweetcream":
            nameCreated = "sweet cream "
        default:
            print("error")
        }
        
        switch self.base
        {
        case "coffee":
            nameCreated = nameCreated + "latte"
        case "matcha":
            nameCreated = nameCreated + "matcha latte"
        case "chai":
            nameCreated = nameCreated + "chai latte"
        default:
            print("error")
        }
        
        return nameCreated
        
    }
    
    // setter functions
    
    /**
     This function allows the user to set the *name* of a Drink object.
     */
    func setName(name: String)
    {
        self.name = name;
    }
    
    /**
     This function allows the user to set the *base* of a Drink object.
     */
    func setBase(base: String)
    {
        self.base = base;
    }
        
    /**
     This function allows for setting the *syrup* of a Drink object.
     */
    func setTopping(topping: String)
    {
        self.topping = topping
    }

    // getter functions
    
    /**
     This function returns the *name* of a Drink object.
     */
    func getName() -> String
    {
        return self.name;
    }
    
    /**
     This function returns the *price* of a Drink object.
     */
    func getPrice() -> Int
    {
        return self.price;
    }
    
    /**
     This function returns the *base* of a Drink object.
     */
    func getBase() -> String
    {
        return self.base;
    }
    
    /**
     This function returns the *additions* of a Drink object.
     */
    func getTopping() -> String
    {
        return self.topping;
    }
    
    // action functions
    
    /**
     This function determines whether two Drink objects are equal or not.
     */
    func isEqual(drinkToCompare: Drink) -> Bool
    {
        
        var equal: Bool
        
        equal = false;
        
        if (
            self.getBase() == drinkToCompare.getBase() &&
            self.getTopping() == drinkToCompare.getTopping()
            )
        {
            
            equal = true;
            
        }
        
        return equal;
        
    }
    
}

