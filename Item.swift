//
//  Item.swift
//  Mocha Garden
//
//  Created by Valerie Williams on 7/1/24.
//

import Foundation
import SpriteKit

/**
 This class represents items in the store. The types of items available include decor, furniture (like the barista counter and mixing board), unique backdrops, and new ingredients for the player to unlock as they progress through the game.
 */
class Item: Codable, Hashable
{
    // data members
    var itemID: String // an item's uniquely identifying ID
    var imageName: String // the name of the image used to create the sprite
    var price: Int // how many 'stars' an item costs
    var type: String // decor, furuniture, backdrop, ingredient
    var isOwned: Bool // true if the item is in the user's inventory
    var isEquipped: Bool // true if the item is currently being used
    
    /*
     This is the default initalizer (only to be used for testing purposes)
     */
    init()
    {
        itemID = "A0"
        imageName = "null"
        price = 0
        type = "null"
        isOwned = false
        isEquipped = false
    }
    
    /*
     This is the main initializer that should be used for creating Item objects.
     */
    init(itemID: String, imageName: String, price: Int, type: String, isOwned: Bool, isEquipped: Bool) {
        self.itemID = itemID
        self.imageName = imageName
        self.price = price
        self.type = type
        self.isOwned = isOwned
        self.isEquipped = isEquipped
    }
    
    // setters
    
    /**
     This function edits the isOwned boolean.
     */
    func setIsOwned(itemOwned: Bool)
    {
        isOwned = itemOwned
    }
    
    /**
     This function edits the isEquipped boolean.
     */
    func setIsEquipped(itemEquipped: Bool)
    {
        isEquipped = itemEquipped
    }
    
    // getters
    
    /**
     This function returns an item's price.
     */
    func getPrice() -> Int
    {
        return price
    }
    
    /**
     This function returns the item's unique ID.
     */
    func getItemID() -> String
    {
        return itemID
    }
    
    /**
     This function returns the type of an item (decor, furniture, backdrop, ingredient)
     */
    func getType() -> String
    {
        return type
    }
    
    /**
     This function returns the image name that is used to create the Item sprite.
     */
    func getImageName() -> String
    {
        return imageName
    }
    
    /**
     This function returns an items owned status.
     */
    func getIsOwned() -> Bool
    {
        return isOwned
    }
    
    /**
     This function returns an item's equip status.
     */
    func getIsEquipped() -> Bool
    {
        return isEquipped
    }
    
    /**
     This function conforms the class to Equatable and checks if two Item objects are equal.
     */
    static func == (lhs: Item, rhs: Item) -> Bool
    {
        return lhs.getItemID() == rhs.getItemID()
    }
    
    /**
     This function conforms the class to Hashable so that Item objects can be included in a set.
     */
    func hash(into hasher: inout Hasher)
    {
        hasher.combine(itemID)
    }
}
