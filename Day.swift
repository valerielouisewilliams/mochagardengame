//
//  Day.swift
//  Cafe Fleur
//
//  Created by Valerie Williams on 5/31/23.
//

import Foundation

class Day {
    
    // data members
    var dayNumber: Int
    var moneyEarned: Int
    var customersServed: Int
    var drinksCorrect: Int
    var drinksIncorrect: Int
    
    // functions start
    
    // constructor
    init()
    {
        self.dayNumber = 0;
        self.moneyEarned = 0;
        self.customersServed = 0;
        self.drinksCorrect = 0;
        self.drinksIncorrect = 0;
    }
    
    // setters
    func setDayNumber(number: Int) {
        self.dayNumber = number
    }
    
    func setMoneyEarned(number: Int) {
        self.moneyEarned = number
    }
    
    func addMoney(number: Int) {
        self.moneyEarned = moneyEarned + number
    }
    
    func addCustomer() {
        self.customersServed = customersServed + 1
    }
    
    func addIncorrectDrink() {
        self.drinksIncorrect = drinksIncorrect + 1
    }
    
    func addCorrectDrink() {
        self.drinksCorrect = drinksCorrect + 1
    }
    
    // getters
    func getDayNumber() -> Int {
        return self.dayNumber
    }
    
    func getMoneyEarned() -> Int {
        return self.moneyEarned
    }
    
    func getCustomersServed() -> Int {
        return self.customersServed
    }
    
    func getDrinksCorrect() -> Int {
        return self.drinksCorrect
    }
    
    func getDrinksIncorrect() -> Int {
        return self.drinksIncorrect
    }
    
}
