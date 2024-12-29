//
//  HomeScene.swift
//  Mocha Garden
//
//  Created by Valerie Williams on 8/25/23.
//

import Foundation
import SpriteKit

class HomeScene: SKScene
{
    
    override func didMove(to view: SKView) {
           // Set up your loading screen UI here
        let background = SKSpriteNode(imageNamed: "loading/homescreen_background")
        background.position = CGPoint(x: 0, y: 0)
        background.scale(to: CGSize(width: 1400, height: 600))
        addChild(background)
        
        // Set up the play button
        let playButton = SKSpriteNode(imageNamed: "loading/play_button" )
        playButton.position = CGPoint(x: 0, y: 0)
        addChild(playButton)
        
       }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        
        // for debugging
        if let touch = touches.first
        {
            let touchLocation = touch.location(in: self)
            print(touchLocation)
        }
        
    }
    
}

