//
//  Customer.swift
//  Cafe Fleur
//
//  Created by Valerie Williams on 5/31/23.
//

import Foundation

class Customer {
    
    // static data members
    var flowerOptions: [String] = ["tulip", "rose", "lotus", "lavender"]
    
    // data members
    var flower: String
    var order: Drink
    var fulfilled: Bool
    var correct: Bool
    
    // functions start
    
    // constructor
    init(order: Drink)
    {
        
        let flowerIndex = Int.random(in: 0..<4)
        self.flower = flowerOptions[flowerIndex];
        self.order = order;
        self.fulfilled = false;
        self.correct = false;
        
    }
    
    // setter functions
    
    // sets the customer's flower type
    func setFlower(flower: String)
    {
        self.flower = flower;
    }
    
    // sets the customer's order
    func setOrder(order: Drink)
    { //again, change to drink object later
        self.order = order;
    }
    
    // sets the customer's fulfillment flag
    func setFulfilledFlag(fulfillment: Bool)
    {
        self.fulfilled = fulfillment
    }
    
    // sets the customer's correct flag
    func setCorrectFlag(correct: Bool)
    {
        self.correct = correct
    }
    
    // getter functions
    
    // returns the customer's flower type
    func getFlower() -> String
    {
        return self.flower
    }
    
    // returns the customer's order
    func getOrder() -> Drink
    {
        return self.order
    }
    
    // returns the customer's fulfillment status
    func getFulfilledFlag() -> Bool
    {
        return self.fulfilled
    }
    
    // returns the customer's correct drink flag
    func getCorrectFlag() -> Bool
    {
        return self.correct
    }
    
}
