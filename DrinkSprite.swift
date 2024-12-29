//
//  DrinkSprite.swift
//  Mocha Garden
//
//  Created by Valerie Williams on 8/21/23.
//

import Foundation
import SpriteKit

protocol DrinkSpriteDelegate: AnyObject {
    func completeDrinkOrder()
}

/**
 This class creates a sprite to represent the drink that the user creates for the customer.
 */
class DrinkSprite : SKSpriteNode {
    
    // delegate for handling touch
    weak var delegate: DrinkSpriteDelegate?
    
    // for handling drag movement
    var initialTouchLocation: CGPoint!
    
    init(drinkOrder: Drink)
    {
        
        // initialize necessary variables
        var drinkTextureString: String // the texture to use for the sprite
        var drinkTexture: SKTexture
        var base: String
        var addition: String
        
        
        // tokenize the drink object passed to the constructor
        base = drinkOrder.getBase()
        addition = drinkOrder.getTopping()
        
        // create the string for the texture
        drinkTextureString = "Drinks/" + base + "_" + addition + ".png"
        
        // for debugging
        print(drinkTextureString)
        
        // create the texture from the string
        drinkTexture = SKTexture(imageNamed: drinkTextureString)
        
        // create + configure the sprite
        super.init(texture: drinkTexture, color: .clear, size: CGSize(width: 125, height: 125))
        self.position = CGPoint(x: -315, y: -15)
        self.zPosition = 10
        self.isUserInteractionEnabled = true
        
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        // record the initial touch location when the user starts dragging
        initialTouchLocation = touches.first?.location(in: self)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        guard initialTouchLocation == initialTouchLocation else {
            return
        }

        // calculate the displacement from the initial touch location
        let touchLocation = touches.first?.location(in: self)
        let displacement = CGPoint(x: touchLocation!.x - initialTouchLocation.x,
                                   y: touchLocation!.y - initialTouchLocation.y)

        // update the sprite's position by the calculated displacement
        self.position.x += displacement.x
        self.position.y += displacement.y
        

        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        // reset the initial touch location when dragging ends
        initialTouchLocation = nil
        
        // send information to main game scene (delegate)
        delegate?.completeDrinkOrder()
    }
    
}


