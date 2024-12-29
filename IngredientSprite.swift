//
//  IngredientSprite.swift
//  Cafe Fleur
//
//  Created by Valerie Williams on 6/13/23.
//

import Foundation
import SpriteKit

protocol IngredientSpriteDelegate: AnyObject {
    func ingredientTouched(_ type: String)
}

class IngredientSprite: SKSpriteNode
{
    
    // static data members
    enum ingredientType
    {
        // bases
        case matcha
        case coffee
        case chai
        
        // toppings
        case stardust
        case rose
        case cherry
        case sweetcream
    
    }
    
    
    var type: String
    weak var delegate: IngredientSpriteDelegate?

    // constructor
    // create the visual object (initializer)
    init(ingredient: ingredientType)
    {
        // create the texture + size variables
        var texture: SKTexture?
        var mySize: CGSize
        var position: CGPoint
        
        // determine which ingredient sprite is to be created + its characteristics
        switch ingredient
        {
            
        //bases
        case .matcha:
            
            texture = SKTexture(imageNamed: "Drinks/Ingredients/matcha.png")
            position = CGPoint(x: 0, y: -20)
            mySize = CGSize(width: 100, height: 100)
            type = "matcha"

        case .coffee:
            
            texture = SKTexture(imageNamed: "Drinks/Ingredients/coffee.png")
            position = CGPoint(x: 100, y: -20)
            mySize = CGSize(width: 100, height: 100)
            type = "coffee"
            
        case .chai:
            texture = SKTexture(imageNamed: "Drinks/Ingredients/chai.png")
            position = CGPoint(x: 200, y: -20)
            mySize = CGSize(width: 100, height: 100)
            type = "chai"
            
        // syrups
        case .stardust:
            texture = SKTexture(imageNamed: "Drinks/Ingredients/stardust.png")
            position = CGPoint(x: -320, y: -150)
            mySize = CGSize(width: 150, height: 130)
            type = "stardust"
            
        case .rose:
            texture = SKTexture(imageNamed: "Drinks/Ingredients/rose.png")
            position = CGPoint(x: -490, y: -150)
            mySize = CGSize(width: 150, height: 130)
            type = "rose"
            
        case .cherry:
            texture = SKTexture(imageNamed: "Drinks/Ingredients/cherry.png")
            position = CGPoint(x: -490, y: -230)
            mySize = CGSize(width: 150, height: 130)
            type = "cherry"
            
            
        case .sweetcream:
            texture = SKTexture(imageNamed: "Drinks/Ingredients/sweetcream.png")
            position = CGPoint(x: -320, y: -230)
            mySize = CGSize(width: 150, height: 130)
            type = "sweetcream"
    
        } // end switch case
        
        // create the sprite
        super.init(texture: texture, color: .clear, size: mySize)
        
        // enable user interaction
        self.isUserInteractionEnabled = true

        // edit the position
        self.zPosition = 1
        self.position = position
        
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    // shake animation
    func shake()
    {
        // for debugging
        print("made it to the shake function")
        
        let duration = 0.1
        let tiltLeft = SKAction.rotate(toAngle: -0.1, duration: duration)
        let tiltRight = SKAction.rotate(toAngle: 0.1, duration: duration)
        let restingPosition = SKAction.rotate(toAngle: 0, duration: duration)
        
        let tiltSequence = SKAction.sequence([tiltLeft, tiltRight, restingPosition, tiltLeft, tiltRight, restingPosition])
        
        self.run(tiltSequence)
        
        // for debugging
        print("end shake function")

    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        if let touch = touches.first
        {
            
            // for debugging: get the touch location in the scene
            let touchLocation = touch.location(in: self)
            print(touchLocation)
            
            // send information to the delegate (GameScene)
            switch self.type
            {
            //bases
            case "matcha":
                self.shake()
                delegate?.ingredientTouched("matcha")
                
            case "coffee":
                self.shake()
                delegate?.ingredientTouched("coffee")
            
            case "chai":
                self.shake()
                delegate?.ingredientTouched("chai")
                
            // syrups
            case "cherry":
                self.shake()
                delegate?.ingredientTouched("cherry")
            
            case "rose":
                self.shake()
                delegate?.ingredientTouched("rose")
                
            case "stardust":
                self.shake()
                delegate?.ingredientTouched("stardust")
                
            case "sweetcream":
                self.shake()
                delegate?.ingredientTouched("sweetcream")
                
            default:
                break
            }
            
        }
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        // for debugging
        print("hey")
    }
       
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        // for debugging
        print("yo")
    }
    
}

