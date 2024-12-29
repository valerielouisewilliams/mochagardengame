//
//  ShopScene.swift
//  Mocha Garden
//
//  Created by Valerie Williams on 6/5/24.
//

import Foundation
import SpriteKit
import GameplayKit
import AVFoundation

class ShopScene: SKScene, ItemSpriteDelegate
{

    var previousScene: GameScene?
    var currentInventory: [Item]!
    var decorItems: [Item] = []
    var furnitureItems: [Item] = []
    var backgroundItems: [Item] = []
    var ingredientItems: [Item] = []
    
    // general UI
    let background = SKSpriteNode(imageNamed: "Scenes/Gameplay.png")
    let backButton = SKSpriteNode(imageNamed: "back.png")
    let forward = SKSpriteNode(imageNamed: "forward.png")
    let backward = SKSpriteNode(imageNamed: "backward.png")
    
    // catalogue UI
    let tab1Page = SKSpriteNode(imageNamed: "tab1_highlighted.png")
    let tab2Page = SKSpriteNode(imageNamed: "tab2_highlighted.png")
    let tab3Page = SKSpriteNode(imageNamed: "tab3_highlighted.png")
    let tab4Page = SKSpriteNode(imageNamed: "tab4_highlighted.png")
    
    let furnitureButton = SKSpriteNode(imageNamed: "furniture_button.png")
    let decorButton = SKSpriteNode(imageNamed: "decor_button.png")
    let backgroundButton = SKSpriteNode(imageNamed: "background_button.png")
    let ingredientButton = SKSpriteNode(imageNamed: "ingredient_button.png")

    // pagination stuff
    var currentCategory = ""
    let itemsPerPage = 8
    var currentPage = 0
    let card1Point = CGPoint(x: -320, y: 120)
    let card2Point = CGPoint(x: -320, y: -90)
    let card3Point = CGPoint(x: -130, y: 115)
    let card4Point = CGPoint(x: -130, y: -100)
    let card5Point = CGPoint(x: 80, y: 105)
    let card6Point = CGPoint(x: 80, y: -110)
    let card7Point = CGPoint(x: 270, y: 105)
    let card8Point = CGPoint(x: 270, y: -110)
    
    let card1LabelPoint = CGPoint(x: -320, y: 15)
    let card2LabelPoint = CGPoint(x: -320, y: -200)
    let card3LabelPoint = CGPoint(x: -130, y: 15)
    let card4LabelPoint = CGPoint(x: -130, y: -200)
    let card5LabelPoint = CGPoint(x: 80, y: 15)
    let card6LabelPoint = CGPoint(x: 80, y: -200)
    let card7LabelPoint = CGPoint(x: 270, y: 15)
    let card8LabelPoint = CGPoint(x: 270, y: -200)
    
    // item labels
    var itemLabelsDict: [String: SKLabelNode] = [:]

    // item sprites (this is for testing, delete later)
    var item1Sprite: ItemSprite!
    var item2Sprite: ItemSprite!
    
    override func didMove(to view: SKView)
    {
        // enable user interaction for the scene
        self.isUserInteractionEnabled = true
        scene?.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        loadUI()
        loadDecorItems()
        loadBackgroundItems()
        loadFurnitureItems()
        
        // furniture is the first page to pop up
        loadItemsForCurrentPage(type: "furniture")
        
    }
    
    func loadUI()
    {
        
        // set up the background
        background.position = CGPoint(x: 0, y: 0)
        background.scale(to: CGSize(width: 1400, height: 600))
        background.zPosition = -3
        background.isHidden = false
        addChild(background)
        
        // set up the back button
        backButton.position = CGPoint(x: -520, y: 210)
        backButton.scale(to: CGSize(width: 100, height: 100))
        backButton.zPosition = 5
        backButton.name = "exit"
        addChild(backButton)
        
        // set up the forward page button
        forward.position = CGPoint(x:405, y: -20)
        forward.size = CGSize(width: 100, height: 100)
        forward.zPosition = 5
        forward.name = "forward"
        addChild(forward)
        
        // set up the backward page button
        backward.position = CGPoint(x: -455, y: -20)
        backward.size = CGSize(width: 100, height: 100)
        backward.zPosition = 5
        backward.name = "backward"
        addChild(backward)
        
        // set up the tabbed pages
        tab1Page.isHidden = false // this will be the default page
        tab1Page.size = CGSize(width: 1400, height: 600)
        tab1Page.position = CGPoint(x:0, y: -5)
        tab1Page.zPosition = 1
        
        tab2Page.isHidden = true
        
        tab3Page.isHidden = true
        
        tab4Page.isHidden = true
        
        
        addChild(tab1Page)
        addChild(tab2Page)
        addChild(tab3Page)
        addChild(tab4Page)
        
        // set up the category buttons/icons
        furnitureButton.position = CGPoint(x: 70, y: 235)
        furnitureButton.size = CGSize(width: 32, height: 32)
        furnitureButton.zPosition = 3
        furnitureButton.name = "furniture"
        addChild(furnitureButton)
        
        decorButton.position = CGPoint(x: 152, y: 235)
        decorButton.size = CGSize(width: 32, height: 32)
        decorButton.zPosition = 3
        decorButton.name = "decor"
        addChild(decorButton)
        
        backgroundButton.position = CGPoint(x: 234, y: 235)
        backgroundButton.size = CGSize(width: 35, height: 35)
        backgroundButton.zPosition = 3
        backgroundButton.name = "background"
        addChild(backgroundButton)
        
        ingredientButton.position = CGPoint(x: 316, y: 240)
        ingredientButton.size = CGSize(width: 30, height: 30)
        ingredientButton.zPosition = 3
        ingredientButton.name = "ingredient"
        addChild(ingredientButton)
    
        // load the display cards for items
        loadItemCards()
        
    }
    
    func highlightTab(Category: String)
    {
        switch Category {
        case "furniture":

            tab1Page.isHidden = false
            currentCategory = "furniture"
        
            tab2Page.isHidden = true
            tab3Page.isHidden = true
            tab4Page.isHidden = true
                        
        case "decor":
            tab2Page.size = CGSize(width: 1400, height: 600)
            tab2Page.position = CGPoint(x:0, y: -5)
            tab2Page.zPosition = 1
            tab2Page.isHidden = false
            currentCategory = "decor"
            
            tab1Page.isHidden = true
            tab3Page.isHidden = true
            tab4Page.isHidden = true
            
        case "background":
            tab3Page.size = CGSize(width: 1400, height: 600)
            tab3Page.position = CGPoint(x:0, y: -5)
            tab3Page.zPosition = 1
            tab3Page.isHidden = false
            currentCategory = "background"
            
            tab1Page.isHidden = true
            tab2Page.isHidden = true
            tab4Page.isHidden = true
            
        case "ingredient":
            tab4Page.size = CGSize(width: 1400, height: 600)
            tab4Page.position = CGPoint(x:0, y: -5)
            tab4Page.zPosition = 1
            tab4Page.isHidden = false
            currentCategory = "ingredient"
            
            tab1Page.isHidden = true
            tab2Page.isHidden = true
            tab3Page.isHidden = true
            
        default:
            print("Fatal Error: Invalid category!")
        }
    }
    
    /**
     This function loads the display card + button base for each item.
     Note: This does not handle actual items, only the card graphic the items are displayed upon.
     */
    func loadItemCards()
    {
        let card1 = SKSpriteNode(imageNamed: "card_background")
        card1.size = CGSize(width: 200, height: 200)
        card1.position = CGPoint(x:-320, y: 105)
        card1.zPosition = 3
        
        let card1_button = SKSpriteNode(imageNamed: "card_button")
        card1_button.size = CGSize(width: 220, height: 220)
        card1_button.position = CGPoint(x:-320, y: 105)
        card1_button.zPosition = 4

        addChild(card1)
        addChild(card1_button)
        
        let card2 = SKSpriteNode(imageNamed: "card_background")
        card2.size = CGSize(width: 200, height: 200)
        card2.position = CGPoint(x:-320, y: -110)
        card2.zPosition = 3
        
        let card2_button = SKSpriteNode(imageNamed: "card_button")
        card2_button.size = CGSize(width: 220, height: 220)
        card2_button.position = CGPoint(x:-320, y: -110)
        card2_button.zPosition = 4

        addChild(card2)
        addChild(card2_button)
        
        let card3 = SKSpriteNode(imageNamed: "card_background")
        card3.size = CGSize(width: 200, height: 200)
        card3.position = CGPoint(x:-130, y: 105)
        card3.zPosition = 3
        
        let card3_button = SKSpriteNode(imageNamed: "card_button")
        card3_button.size = CGSize(width: 220, height: 220)
        card3_button.position = CGPoint(x:-130, y: 105)
        card3_button.zPosition = 4
        
        addChild(card3)
        addChild(card3_button)
        
        let card4 = SKSpriteNode(imageNamed: "card_background")
        card4.size = CGSize(width: 200, height: 200)
        card4.position = CGPoint(x: -130, y: -110)
        card4.zPosition = 3
        
        let card4_button = SKSpriteNode(imageNamed: "card_button")
        card4_button.size = CGSize(width: 220, height: 220)
        card4_button.position = CGPoint(x: -130, y: -110)
        card4_button.zPosition = 4
        
        addChild(card4)
        addChild(card4_button)
        
        let card5 = SKSpriteNode(imageNamed: "card_background")
        card5.size = CGSize(width: 200, height: 200)
        card5.position = CGPoint(x: 80, y: 105)
        card5.zPosition = 3
        
        let card5_button = SKSpriteNode(imageNamed: "card_button")
        card5_button.size = CGSize(width: 220, height: 220)
        card5_button.position = CGPoint(x: 80, y: 105)
        card5_button.zPosition = 4
        
        addChild(card5)
        addChild(card5_button)
        
        let card6 = SKSpriteNode(imageNamed: "card_background")
        card6.size = CGSize(width: 200, height: 200)
        card6.position = CGPoint(x: 80, y: -110)
        card6.zPosition = 3
        
        let card6_button = SKSpriteNode(imageNamed: "card_button")
        card6_button.size = CGSize(width: 220, height: 220)
        card6_button.position = CGPoint(x:80, y: -110)
        card6_button.zPosition = 4
        
        addChild(card6)
        addChild(card6_button)
        
        let card7 = SKSpriteNode(imageNamed: "card_background")
        card7.size = CGSize(width: 200, height: 200)
        card7.position = CGPoint(x: 270, y: 105)
        card7.zPosition = 3
        
        let card7_button = SKSpriteNode(imageNamed: "card_button")
        card7_button.size = CGSize(width: 220, height: 220)
        card7_button.position = CGPoint(x: 270, y: 105)
        card7_button.zPosition = 4
        
        addChild(card7)
        addChild(card7_button)
        
        let card8 = SKSpriteNode(imageNamed: "card_background")
        card8.size = CGSize(width: 200, height: 200)
        card8.position = CGPoint(x: 270, y: -110)
        card8.zPosition = 3
        
        let card8_button = SKSpriteNode(imageNamed: "card_button")
        card8_button.size = CGSize(width: 220, height: 220)
        card8_button.position = CGPoint(x: 270, y: -110)
        card8_button.zPosition = 4
        
        addChild(card8)
        addChild(card8_button)
    }
    
    /**
     This function loads the current decor items in the shop.
     */
    func loadDecorItems()
    {
        // load inventory for comparison
        currentInventory = UserDataManager.shared.loadInventory()
        
        // load all items
        let decor1 = Item(itemID: "0", imageName: "test_item", price: 5, type: "decor", isOwned: false, isEquipped: false)
        let decor2 = Item(itemID: "1", imageName: "test_item2", price: 5, type: "decor", isOwned: false, isEquipped: false)
        let decor3 = Item(itemID: "2", imageName: "blueconchshell", price: 100, type: "decor", isOwned: false, isEquipped: false)
        let decor4 = Item(itemID: "3", imageName: "blueseashell", price: 20, type: "decor", isOwned: false, isEquipped: false)
        let decor5 = Item(itemID: "4", imageName: "bow", price: 50, type: "decor", isOwned: false, isEquipped: false)
        let decor6 = Item(itemID: "5", imageName: "butterflyjar", price: 60, type: "decor", isOwned: false, isEquipped: false)
        let decor7 = Item(itemID: "6", imageName: "partyduck", price: 100, type: "decor", isOwned: false, isEquipped: false)
        let decor8 = Item(itemID: "7", imageName: "pinkballoon", price: 200, type: "decor", isOwned: false, isEquipped: false)
        let decor9 = Item(itemID: "8", imageName: "pinkcake", price: 400, type: "decor", isOwned: false, isEquipped: false)
        let decor10 = Item(itemID: "9", imageName: "pinkpartyhat", price: 140, type: "decor", isOwned: false, isEquipped: false)
        let decor11 = Item(itemID: "10", imageName: "snail", price: 50, type: "decor", isOwned: false, isEquipped: false)
        let decor12 = Item(itemID: "11", imageName: "toybear", price: 100, type: "decor", isOwned: false, isEquipped: false)
        let decor13 = Item(itemID: "12", imageName: "yellowballoon", price: 200, type: "decor", isOwned: false, isEquipped: false)
        
        // store the decor items in an array
        let decorCatalog = [decor1, decor2, decor3, decor4, decor5, decor6, decor7, decor8,
                            decor9, decor10, decor11, decor12, decor13]
        
        decorItems.append(contentsOf: decorCatalog)
    }
    
    /**
     This function loads the background items in the shop.
     */
    func loadBackgroundItems()
    {
        // load the user's current inventory
        currentInventory = UserDataManager.shared.loadInventory();
        
        // load the items
        let background1 = Item(itemID: "13", imageName: "beach_preview", price: 5, type: "background", isOwned: false, isEquipped: false)
        let background2 = Item(itemID: "14", imageName: "mountain_preview", price: 5, type: "background", isOwned: false, isEquipped: false)
        let background3 = Item(itemID: "15", imageName: "cherryblossom_preview", price: 5, type: "background", isOwned: false, isEquipped: false)
        
        let backgroundCatalog = [background1, background2, background3]
        
        backgroundItems.append(contentsOf: backgroundCatalog)
        
    }
    
    /**
     This function loads the furniture items (ingredient board, counters, etc)
     in the shop.
     */
    func loadFurnitureItems()
    {
        // load inventory for comparison
        currentInventory = UserDataManager.shared.loadInventory()
        
        // load the items in
        let furniture1 = Item(itemID: "16", imageName: "tray_teakwood", price: 5, type: "furniture", isOwned: false, isEquipped: false)
        let furniture2 = Item(itemID: "17", imageName: "tray_marble", price: 5, type: "furniture", isOwned: false, isEquipped: false)
        let furniture3 = Item(itemID: "18", imageName: "counter_pink", price: 5, type: "furniture", isOwned: false, isEquipped: false)
        let furniture4 = Item(itemID: "19", imageName: "counter_oak", price: 5, type: "furniture", isOwned: false, isEquipped: false)
        let furniture5 = Item(itemID: "20", imageName: "counter_base", price: 0, type: "furniture", isOwned: true, isEquipped: false)
        let furniture6 = Item(itemID: "21", imageName: "tray_base", price: 0, type: "furniture", isOwned: true, isEquipped: false)

        
        let furnitureCatalog = [furniture1, furniture2, furniture3, furniture4, furniture5, furniture6]
        
        furnitureItems.append(contentsOf: furnitureCatalog)

    }
    
    
    func handleItemTouch(_ touchedItem: Item)
    {
        
        // for debugging
        print(touchedItem.getItemID())
        print("item touched")
        
        // set up necessary variables
        let currentBalance = UserDataManager.shared.loadMoneyEarned()
        var newBalance: Int
        var indexIfOwned = -1
        let touchedItemID = touchedItem.getItemID()
        let touchedItemPrice = touchedItem.getPrice()
        
        currentInventory = UserDataManager.shared.loadInventory()
        var touchedItemIsOwned = false // false until it's found in the user's inventory
        
        // check if the item is owned or not
        if currentInventory != nil //TODO: Unwrap the optional properly lmao
        {
            for i in 0..<currentInventory.count
            {
                // compare the touched item to every item in the user's inventory to see if it's owned already
                if touchedItemID == currentInventory[i].getItemID()
                {
                    touchedItemIsOwned = true // mark the flag as true
                    indexIfOwned = i // store the index
                }
            }
        }

        // for debugging
        print("isOwned: \(touchedItemIsOwned)")
        print("currentBalance: \(currentBalance)")
        print("item price: \(touchedItem.getPrice())")
        print("item is equipped: \(touchedItem.getIsEquipped())")
        
        // call the appropriate function depending on the status of the item!
        
        // if item is not in inventory + user has enough stars to purchase -> purchase the item
        if touchedItemIsOwned == false && currentBalance >= touchedItemPrice
        {
            print("purchasing item!")
            
                // ask if the user really wants to buy the item
                
                // if yes:
                
                // handle the transaction
                newBalance = currentBalance - touchedItem.getPrice()
                UserDataManager.shared.saveMoneyEarned(newBalance)
            
                // change status of item
                touchedItem.setIsEquipped(itemEquipped: true)
                touchedItem.setIsOwned(itemOwned: true)
        
                // add item to inventory
                UserDataManager.shared.addItem(newItem: touchedItem)
            
                // update the item label to reflect 'equipped' status
                if let label = itemLabelsDict[touchedItem.getItemID()]
                {
                    label.text = "Equipped"
                }
                
                // unequip the other item
            if let currentInventory
            {
                for i in 0..<currentInventory.count
                {
                    // unequip the currently equipped item of the same type
                    if currentInventory[i].getType() == touchedItem.getType() &&
                        currentInventory[i].isEquipped == true
                    {
                        currentInventory[i].setIsEquipped(itemEquipped: false)
                        
                        // update the item label to reflect 'owned' but not 'equipped' status
                        if let label = itemLabelsDict[currentInventory[i].getItemID()]
                        {
                            label.text = "Owned"
                        }
                        
                    }
                }
            }
        
        }

        // if item is not in inventory + user does not have enough stars to purchase -> error msg
        if touchedItemIsOwned == false && currentBalance < touchedItem.getPrice()
        {
            print("broke bitch!!!")
        }
        
        // if item is in inventory + equipped -> unequip it
        if touchedItemIsOwned && currentInventory[indexIfOwned].getIsEquipped() == true
        {
            print("item already equipped")
            currentInventory[indexIfOwned].setIsEquipped(itemEquipped: false)
            UserDataManager.shared.saveInventory(items: currentInventory)
            
            // update the item label to reflect 'owned' but not 'equipped' status
            if let label = itemLabelsDict[currentInventory[indexIfOwned].getItemID()]
            {
                label.text = "Owned"
            }
            
        }
        
       // if item is in inventory + not equipped -> equip it and unequip the other item
        if touchedItemIsOwned
        {
            if currentInventory[indexIfOwned].getIsEquipped() == false
            {
                for i in 0..<currentInventory.count
                {
                    // unequip the currently equipped item of the same type
                    if currentInventory[i].getType() == touchedItem.getType() &&
                        currentInventory[i].isEquipped == true
                    {
                        currentInventory[i].setIsEquipped(itemEquipped: false)
                        
                        // update the item label to reflect 'owned' but not 'equipped' status
                        if let label = itemLabelsDict[currentInventory[i].getItemID()]
                        {
                            label.text = "Owned"
                        }
                        
                    }
                    
                    // equip the correct item
                    for i in 0..<currentInventory.count
                    {
                        // equip the touched item (since it's already owned)
                        if currentInventory[i].getItemID() == touchedItem.getItemID()
                        {
                            currentInventory[i].setIsEquipped(itemEquipped: true)
                            
                            // update the item label to reflect 'equipped' status
                            if let label = itemLabelsDict[touchedItem.getItemID()]
                            {
                                label.text = "Equipped"
                            }
                        }
                    }
                    // save the changes we just made (equipped an item, unequipped an item)
                    UserDataManager.shared.saveInventory(items: currentInventory)
                }
            }
        }

    }
    
    func loadItemsForCurrentPage(type: String)
    {
        //clear the page to make room for new items
        removeAllItemSprites()
        removeAllLabelSprites()
        
        currentInventory = UserDataManager.shared.loadInventory()

        
        let points: [CGPoint] = [card1Point, card2Point, card3Point, card4Point,
                                card5Point, card6Point, card7Point, card8Point] // create array of necessary coordinates
        let labelPoints: [CGPoint] = [card1LabelPoint, card2LabelPoint, card3LabelPoint, card4LabelPoint,
                                      card5LabelPoint, card6LabelPoint, card7LabelPoint, card8LabelPoint]
        var pointIndex = 0
        
        switch type {
        case "decor":
            let startIndex = currentPage * itemsPerPage
            let endIndex = min(startIndex + itemsPerPage, decorItems.count)
            
            if currentInventory != nil
            {
                let currentInventorySet = Set(currentInventory) // load the user's inventory into a set
                let equippedItemsSet = Set(currentInventory.filter( { $0.getIsEquipped() })) // load the user's equipped items into a set
                
                // change the status for owned items
                for decorItem in decorItems
                {
                    if currentInventorySet.contains(decorItem)
                    {
                        decorItem.setIsOwned(itemOwned: true)
                    }
                }
                
                // change the status for equipped items
                for decorItem in decorItems
                {
                    if equippedItemsSet.contains(decorItem)
                    {
                        decorItem.setIsEquipped(itemEquipped: true)
                    }
                }
            }

            for index in startIndex..<endIndex
            {
                // reset the point index
                if startIndex % 8 > 0
                {
                    pointIndex = 0
                }
                
                let item = decorItems[index]
                let itemSprite = ItemSprite(itemToCreate: item)
                itemSprite.delegate = self
                itemSprite.position = points[pointIndex]
                itemSprite.zPosition = 5
                itemSprite.isUserInteractionEnabled = true
                addChild(itemSprite)

                var labelText = ""
                
                if decorItems[index].getIsOwned() == true && decorItems[index].getIsEquipped() == true
                {
                    labelText = "Equipped"
                }
                else if decorItems[index].getIsOwned() == true && decorItems[index].getIsEquipped() == false
                {
                    labelText = "Owned"
                }
                else if decorItems[index].getIsOwned() == false
                {
                    labelText = String(decorItems[index].getPrice())
                }
                
                let itemSpriteLabel = SKLabelNode(text: labelText)
                itemSpriteLabel.position = labelPoints[pointIndex]
                itemSpriteLabel.zPosition = 5
                itemSpriteLabel.isUserInteractionEnabled = true
                itemSpriteLabel.name = "\(decorItems[index].getItemID())_label"
                itemLabelsDict[decorItems[index].getItemID()] = itemSpriteLabel
                addChild(itemSpriteLabel)
                
                pointIndex += 1
            }
        case "background":
            let startIndex = currentPage * itemsPerPage
            let endIndex = min(startIndex + itemsPerPage, backgroundItems.count)
            
            print(startIndex)
            print(endIndex)
            
            if currentInventory != nil
            {
                let currentInventorySet = Set(currentInventory) // load the user's inventory into a set
                let equippedItemsSet = Set(currentInventory.filter( { $0.getIsEquipped() })) // load the user's equipped items into a set
                
                // change the status for owned items
                for backgroundItem in backgroundItems {
                    if currentInventorySet.contains(backgroundItem)
                    {
                        backgroundItem.setIsOwned(itemOwned: true)
                    }
                }
                
                // change the status for equipped items
                for backgroundItem in backgroundItems
                {
                    if equippedItemsSet.contains(backgroundItem)
                    {
                        backgroundItem.setIsEquipped(itemEquipped: true)
                    }
                }
            }

            for index in startIndex..<endIndex
            {
                // reset the point index
                if startIndex % 8 > 0
                {
                    pointIndex = 0
                }
                
                let item = backgroundItems[index]
                let itemSprite = ItemSprite(itemToCreate: item)
                itemSprite.delegate = self
                itemSprite.position = points[pointIndex]
                itemSprite.zPosition = 5
                itemSprite.isUserInteractionEnabled = true
                addChild(itemSprite)
                
                var labelText = ""
                
                if backgroundItems[index].getIsOwned() == true && backgroundItems[index].getIsEquipped() == true
                {
                    labelText = "Equipped"
                }
                else if backgroundItems[index].getIsOwned() == true && backgroundItems[index].getIsEquipped() == false
                {
                    labelText = "Owned"
                }
                else if backgroundItems[index].getIsOwned() == false
                {
                    labelText = String(backgroundItems[index].getPrice())
                }
                
                let itemSpriteLabel = SKLabelNode(text: labelText)
                itemSpriteLabel.position = labelPoints[pointIndex]
                itemSpriteLabel.zPosition = 5
                itemSpriteLabel.isUserInteractionEnabled = true
                itemSpriteLabel.name = "\(backgroundItems[index].getItemID())_label"
                itemLabelsDict[backgroundItems[index].getItemID()] = itemSpriteLabel
                addChild(itemSpriteLabel)
                
                pointIndex += 1
            }
        case "furniture":
            let startIndex = currentPage * itemsPerPage
            let endIndex = min(startIndex + itemsPerPage, furnitureItems.count)
            
            print(startIndex)
            print(endIndex)
            
            if currentInventory != nil
            {
                let currentInventorySet = Set(currentInventory) // load the user's inventory into a set
                let equippedItemsSet = Set(currentInventory.filter( { $0.getIsEquipped() })) // load the user's equipped items into a set
                
                // change the status for owned items
                for furnitureItem in furnitureItems {
                    if currentInventorySet.contains(furnitureItem)
                    {
                        furnitureItem.setIsOwned(itemOwned: true)
                    }
                }
                
                // change the status for equipped items
                for furnitureItem in furnitureItems
                {
                    if equippedItemsSet.contains(furnitureItem)
                    {
                        furnitureItem.setIsEquipped(itemEquipped: true)
                    }
                }
            }

            for index in startIndex..<endIndex
            {
                // reset the point index
                if startIndex % 8 > 0
                {
                    pointIndex = 0
                }
                
                let item = furnitureItems[index]
                let itemSprite = ItemSprite(itemToCreate: item)
                itemSprite.delegate = self
                itemSprite.position = points[pointIndex]
                itemSprite.zPosition = 5
                itemSprite.isUserInteractionEnabled = true
                addChild(itemSprite)
                
                var labelText = ""
                
                if furnitureItems[index].getIsOwned() == true && furnitureItems[index].getIsEquipped() == true
                {
                    labelText = "Equipped"
                }
                else if furnitureItems[index].getIsOwned() == true && furnitureItems[index].getIsEquipped() == false
                {
                    labelText = "Owned"
                }
                else if furnitureItems[index].getIsOwned() == false
                {
                    labelText = String(furnitureItems[index].getPrice())
                }
                
                let itemSpriteLabel = SKLabelNode(text: labelText)
                itemSpriteLabel.position = labelPoints[pointIndex]
                itemSpriteLabel.zPosition = 5
                itemSpriteLabel.isUserInteractionEnabled = true
                itemSpriteLabel.name = "\(furnitureItems[index].getItemID())_label"
                itemLabelsDict[furnitureItems[index].getItemID()] = itemSpriteLabel
                addChild(itemSpriteLabel)
                
                pointIndex += 1
            }
        default:
            print("Error loading items.")
        }
    
    }
    
    func removeAllItemSprites()
    {
        for child in children where child is ItemSprite
        {
            child.removeFromParent()
        }
    }
    
    func removeAllLabelSprites()
    {
        for child in children where child is SKLabelNode
        {
            child.removeFromParent()
        }
    }
    
    func goToNextPage(type: String)
    {
        // check if there is a next page
        if (currentPage + 1) * itemsPerPage < decorItems.count
        {
            // update the currentPage variable
            currentPage += 1
            // load the items for the next page
            loadItemsForCurrentPage(type: type)
        }
    }

    func goToPreviousPage(type: String)
    {
        // check if there is a previous page
        if currentPage > 0
        {
            // update the currentPage variable
            currentPage -= 1
            // load the items for the previous page
            loadItemsForCurrentPage(type: type)

        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        
        if let touch = touches.first
        {
            let touchLocation = touch.location(in: self)
            let node = self.atPoint(touchLocation)
            print(touchLocation)
                
            // if user touches back button -> go back to main game scene
            if node.name == "exit"
            {
                // resume the game round in the previous scene + transition to the main game scene
                if let gameScene = previousScene
                {
                    gameScene.startTimer()
                    gameScene.scaleMode = self.scaleMode
                    let transition = SKTransition.fade(withDuration: 1.0)
                    self.view?.presentScene(gameScene, transition: transition)
                }
                
            } // end of back button logic
            
            // logic for touching the category buttons
            if node.name == "furniture"
            {
                removeAllItemSprites()
                removeAllLabelSprites()
                highlightTab(Category: "furniture")
                loadItemsForCurrentPage(type: "furniture")
                print("furniture!")
            }
            
            if node.name == "decor"
            {
                removeAllItemSprites()
                removeAllLabelSprites()
                highlightTab(Category: "decor")
                loadItemsForCurrentPage(type: "decor")
                print("decor!")

            }
            
            if node.name == "background"
            {
                removeAllItemSprites()
                removeAllLabelSprites()
                highlightTab(Category: "background")
                loadItemsForCurrentPage(type: "background")
                print("bg!")

            }
            
            if node.name == "ingredient"
            {
                highlightTab(Category: "ingredient")
                print("ingredient!")
            }
            
            // handle pagination touch
            if node.name == "forward"
            {
                var totalItems = 0
                var maxPages = 0
                
                print("going forward a page!")
                
                switch currentCategory {
                case "decor":
                    totalItems = decorItems.count
                    maxPages = ((totalItems/itemsPerPage) + 3) / 4
                    
                    if currentPage <= maxPages
                    {
                        goToNextPage(type: "decor")

                    }
                case "furniture":
                    goToNextPage(type: "furniture")
                case "ingredient":
                    goToNextPage(type: "ingredient")
                case "background":
                    goToNextPage(type: "background")
                default:
                    print("lol")
                }
            }
            
            if node.name == "backward"
            {
                print("going backward a page!")
                goToPreviousPage(type: "decor") //change this soon
            }
            
        }
        
    }
    
}


