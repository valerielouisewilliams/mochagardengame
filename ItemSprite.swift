//
//  ItemSprite.swift
//  Mocha Garden
//
//  Created by Valerie Williams on 7/5/24.
//

import Foundation
import SpriteKit

protocol ItemSpriteDelegate: AnyObject {
    func handleItemTouch(_ touchedItem: Item)
}

class ItemSprite: SKSpriteNode {
    
    // delegate for handling touch
    weak var delegate: ItemSpriteDelegate?
    var item: Item!

    init(itemToCreate: Item)
    {
        
        // initialize necessary variables
        var itemTextureString: String
        var itemTexture: SKTexture
        item = itemToCreate
        
        itemTextureString = item.getImageName()
        itemTexture = SKTexture(imageNamed: itemTextureString)
        
        // for debugging
        print(itemTextureString)
        
        super.init(texture: itemTexture, color: .clear, size: CGSize(width: 150, height: 150))
        self.zPosition = 10
        self.isUserInteractionEnabled = true
        
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        guard let item = item else { return }
        print(item.getItemID())
        delegate?.handleItemTouch(item)
    }
    
    
}


