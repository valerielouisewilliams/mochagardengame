//
//  DrinkMixButton.swift
//  Mocha Garden
//
//  Created by Valerie Williams on 8/16/23.
//

import Foundation
import SpriteKit

protocol MixButtonDelegate: AnyObject {
    func mixButtonTouched(_ isFull: Bool)
}

class DrinkMixButton : SKSpriteNode
{
    
    // class level variables
    var progressBarTextures: [SKTexture]!
    var progressBar: SKSpriteNode!
    var progressBarTexturesIndex: Int!
    
    // the delegate function
    weak var delegate: MixButtonDelegate?

    /**
     This constructs a DrinkMixButton sprite + progress bar.
     */
    init()
    {
        
        // create and configure the button sprite
//        let buttonTexture = SKTexture(imageNamed: "mixbutton_default.png")
//        super.init(texture: buttonTexture, color: .clear, size: CGSize(width: 100, height: 100))
//        super.zPosition = 2
//        super.position = CGPoint(x: 125, y: -150)
//        super.isUserInteractionEnabled = true
        
        // create and configure the progress bar
        self.progressBarTextures = [SKTexture(imageNamed: "mix_progress-1.png"),
                               SKTexture(imageNamed: "mix_progress-2.png"),
                               SKTexture(imageNamed: "mix_progress-3.png"),
                               SKTexture(imageNamed: "mix_progress-4.png"),
                               SKTexture(imageNamed: "mix_progress-5.png"),
                               SKTexture(imageNamed: "mix_progress-6.png"),
                               SKTexture(imageNamed: "mix_progress-7.png"),
                               SKTexture(imageNamed: "mix_progress-8.png"),
                               SKTexture(imageNamed: "mix_progress-9.png"),
                               SKTexture(imageNamed: "mix_progress-10.png")]
        progressBarTexturesIndex = 0
        
        super.init(texture: progressBarTextures[0], color: .clear, size: CGSize(width: 120, height: 120))
        super.position = CGPoint(x: 125, y: -190)
        //addChild(progressBar)
        
    }
    
    /**
     This handles what happens when the constructor is not implemented.
     */
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    /**
     This function animates the progress bar's filliing process.
     */
    func animateFilling()
    {
    
        // fill the button
        if (progressBarTexturesIndex < progressBarTextures.count - 1)
        {
            progressBarTexturesIndex += 1
            self.texture = progressBarTextures[progressBarTexturesIndex]
            
            print(String(progressBarTexturesIndex))

        }

    }
    
    /**
     This function visually changes the button to its pushed state.
     */
    func animatePushingButton()
    {
        let pushedTexture = SKTexture(imageNamed: "mixbutton_pushed.png")
        self.texture = pushedTexture
    }
    
    /**
     This function visually changes the button to its released (default) state.
     */
    func animateButtonRelease()
    {
        let releasedTexture = SKTexture(imageNamed: "mixbutton_default.png")
        self.texture = releasedTexture
    }
    
    /**
     This function resets the progress bar.
     */
    func resetProgress()
    {
        progressBarTexturesIndex = 0
        self.texture = progressBarTextures[progressBarTexturesIndex]
    }
    
    /**
     This function returns the progressBarTexturesIndex.
     */
    func getTextureIndex() -> Int
    {
        return progressBarTexturesIndex
    }

    /**
     This function determines whether the progress bar is full or not.
     */
    func isFull() -> Bool {
        
        if (progressBarTexturesIndex == 9)
        {
            print("FULL!")
            return true
        }
        else
        {
            return false
        }
        
    }

    /**
     This function handles what happens when the mix button object sprite is touched.
     */
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        //if let touch = touches.first
        //{
            
            // notify GameScene that the button was pressed & its status
            delegate?.mixButtonTouched(self.isFull())
    
        //}


    }
    
    /**
     This function handles what happens when the user *stops* touching the mix button sprite object.
     */
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        
        // animate the button being released
        //animateButtonRelease()
        
        print("hi")
        
    }
    
} // end of class
