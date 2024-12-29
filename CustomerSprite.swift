//
//  CustomerSprite.swift
//  Cafe Fleur
//
//  Created by Valerie Williams on 6/12/23.
//

import Foundation

import SpriteKit

class CustomerSprite: SKSpriteNode
{
    
    var customer: Customer
    var greetings: [String] = ["Hi! ", "Aloha! ", "Sup. ", "Yo... ", "HELLO UGLY. ", "Um..." ]
    var asks: [String] = ["Can I please have ", "Let me get ", "", "I want ", "Give me "]
    
    // create the visual object (initializer)
    init(customer: Customer)
    {
        // declare necessary variables
        var imageName = "" // create a variable for the image that will be used for the sprite
        
        // connect the sprite to the customer object (customer object must be initialized before the sprite)
        self.customer = customer
        
        // open the image to be used for the character
        switch customer.getFlower()
        {
            
        case "tulip":
            let filePostFixes = ["_blue", "_pink", "_purple"]
            let fileEnding = filePostFixes[Int.random(in: 0..<2)] // to randomize the color
            imageName = "Characters/" + customer.getFlower() + fileEnding // the image to use for the texture
            
        case "rose":
            let filePostFixes = ["_orange", "_pink", "_red"]
            let fileEnding = filePostFixes[Int.random(in: 0..<2)] // to randomize the color
            imageName = "Characters/" + customer.getFlower() + fileEnding // the image to use for the texture
            
        case "lotus":
            let filePostFixes = ["_blue", "_pink", "_purple"]
            let fileEnding = filePostFixes[Int.random(in: 0..<2)] // to randomize the color
            imageName = "Characters/" + customer.getFlower() + fileEnding // the image to use for the texture
        
        case "lavender":
            let filePostFixes = ["_blue", "_purple"]
            let fileEnding = filePostFixes[Int.random(in: 0..<1)] // to randomize the color
            imageName = "Characters/" + customer.getFlower() + fileEnding // the image to use for the texture
            
        default:
            print("fatal error: invalid flower type")
            
        }
        
        // create the texture to use
        let texture = SKTexture(imageNamed: imageName)
        
        // for debugging
        print(imageName)
        
        // create the size constant
        let customerSize = CGSize(width: 250, height: 250)
        
        // initialize 
        super.init(texture: texture, color: .clear, size: customerSize)
        
        // edit the position
        self.zPosition = -2
        self.position = CGPoint(x: -437, y: 37)
        
        // enable user interaction
        self.isUserInteractionEnabled = true
        
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
        
    // happy emote
    
    // angry emote
    
    // display order
    func orderString() -> String
    {
        // create a blank string to hold the order to display
        var orderString: String
        orderString = ""
        var drink: Drink
        drink = self.customer.getOrder()
        
        // add a random greeting
        orderString += greetings[Int.random(in: 0..<5)]
        
        // add an ask style
        orderString += asks[Int.random(in: 0..<4)]
        
        // add drink
        orderString += drink.getName()
        
        return orderString
        
    }
    
    
    func createOrderNode(orderString: String) -> SKLabelNode
    {
        
        // TEXT BASED ORDER:
        // initialize the label node
        var drinkLabel = SKLabelNode()

        // create the label node
        drinkLabel = SKLabelNode(fontNamed: "SalsaScripture20-Regular")
        drinkLabel.text = orderString
        drinkLabel.position = CGPoint(x: -190, y: 50)
        drinkLabel.fontColor = .black
        drinkLabel.fontSize = 40

        // return the node
        return drinkLabel
        

    }
    
    
    
}
