//
//  GameScene.swift
//
//  Created by Valerie Williams on 5/31/23.
//

import SpriteKit
import GameplayKit
import AVFoundation

class GameScene: SKScene, IngredientSpriteDelegate, MixButtonDelegate, DrinkSpriteDelegate
{
    
    // class-level variables:
        
    // user data
    var totalMoney: Int! // the total money the user has
    var moneyEarnedInDay: Int! // the amount of money the user earned in one day
    var moneyEarnedFromDrink: Int! // the amount of money the user earned from a drink (temp variable)
    var daysOpened: Int! // the number of days the café has been open
    var customersServed: Int! // the number of customers served in the day (this is not saved BTW)
    
    // general UI
    var speechBubble: SKSpriteNode!
    var orderBase:  SKSpriteNode!
    var orderTopping1: SKSpriteNode!
    var eodSummarySprite: SKSpriteNode!
    var nextButtonSprite: SKSpriteNode!
    var daysOpenedSprite: SKLabelNode!
    var moneyEarnedSprite: SKLabelNode!
    var customersServedSprite: SKLabelNode!
    var timerSprite: SKSpriteNode!
    var timerLabelSprite: SKLabelNode!
    var moneySprite: SKSpriteNode!
    var moneyLabelSprite: SKLabelNode!
    var toolbarSprite: SKSpriteNode!
    var shopIconSprite: SKSpriteNode!
    var settingsIconSprite: SKSpriteNode!
    var helpIconSprite: SKSpriteNode!
    
    // shop UI
    var shopBackgroundsSprite: SKSpriteNode!
    
    // timer + day control
    var timer: Timer?
    var secondsPassed: Int = 0
    var isDayActive: Bool = false
    
    // day data displays
    var moneyEarnedFromDrinkSprite: SKLabelNode!
    
    // animations + audio
    let fadeOut = SKAction.fadeAlpha(to: 0.0, duration: 1.0)
    let fadeIn = SKAction.fadeAlpha(to: 2.0, duration: 1.0)
    var audioPlayer: AVAudioPlayer?
    var backgroundMusicPlayer: AVAudioPlayer?

    // create drink object (user created drink)
    var barista_drink = Drink(isOrder: false)
    var barista_drinkSprite: DrinkSprite!
    var drink_Finished: Bool!
    
    // create customer object
    var currCustomer: Customer!
    var customerSprite: CustomerSprite!
    var customerOrderNode: SKNode!
    var customerOrderString: String!
    var customersOrder: Drink!
    
    // UI buttons & functionality
    var mixButton: DrinkMixButton!
    var numIngredientsUsed: Int!
    
    // ingredient symbols for display only
    var symbol_coffee: SKSpriteNode!
    var symbol_matcha: SKSpriteNode!
    var symbol_chai: SKSpriteNode!
    var symbol_cherry: SKSpriteNode!
    var symbol_rose: SKSpriteNode!
    var symbol_stardust: SKSpriteNode!
    var symbol_sweetcream: SKSpriteNode!
    
    // create ingredient sprites
    // bases
    var matcha: IngredientSprite!
    var coffee: IngredientSprite!
    var chai: IngredientSprite!
    
    // toppings
    var cherry: IngredientSprite!
    var stardust: IngredientSprite!
    var rose: IngredientSprite!
    var sweetcream: IngredientSprite!
    
    // inventory
    var inventory: [Item]!
    
    // create the background sprite (it's default initialized to the basic background)
    var background = SKSpriteNode(imageNamed: "Scenes/Gameplay.png")
    
    // create furniture
    var counterAsset = SKSpriteNode(imageNamed: "counter_base")
    var boardAsset = SKSpriteNode(imageNamed: "tray_base")
    var decorAsset: Item!
    var decorAssetSprite: ItemSprite!
    
    /**
     This function handles properly loading the GameScene. Displays the appropriate furniture & ingredient sprites.
     */
    override func sceneDidLoad()
    {
        
        // set up the cafe
        setUpCafe()
        
        // enable user interaction for the scene
        self.isUserInteractionEnabled = true
        
        // set up delegates
        assignDelegates()
        
        // set up + play the background music
        setupBackgroundMusic()
        playBackgroundMusic()
        
        //set up the UI
        setupUI()
    
        // start the round
        startDay()
        
    }
    
    func setUpCafe()
    {
        // load the inventory array up
        loadInventory()
        
        // display the background
        loadBackground()
        
        // display the mixing board
        loadMixingBoard()
        
        // display and set up the mix button
        loadMixButton()
        
        // display the barista counter
        loadBaristaCounter()
        
        // display the ingredients
        displayIngredients()
        
        // display decor
        displayDecor()
    }
    

    override func didMove(to view: SKView) {
        
        // collapse the toolbar menu
        shopIconSprite.isHidden = true
        settingsIconSprite.isHidden = true
        helpIconSprite.isHidden = true
        
        // reset the item sprites
        resetItemsSprites()
        
        // update money earned
        moneyLabelSprite.text = String(UserDataManager.shared.loadMoneyEarned())
        
        // reload the inventory
        loadInventory()
        
        // update decor
        displayDecor()
        
        // update background
        loadBackground()
        
        // update furniture
        loadMixingBoard()
        loadBaristaCounter()
        
        // update any new ingredients
        
        print(background)
            
    }
    
    /**
     This function sets up UI displays such as the timer, how much money the user has,
     the hamburger toolbar, etc.
     */
    func setupUI()
    {
        // toolbar + icons (icons hidden until tapped)
        toolbarSprite = SKSpriteNode(imageNamed: "hamburger_menu.png")
        toolbarSprite.name = "toolbar"
        toolbarSprite.size = CGSize(width: 60, height: 60)
        toolbarSprite.position = CGPoint(x: 415, y: 250)
        toolbarSprite.zPosition = 10
        addChild(toolbarSprite)
    
        shopIconSprite = SKSpriteNode(imageNamed: "shop.png")
        shopIconSprite.size = CGSize(width: 60, height: 60)
        shopIconSprite.position = CGPoint(x: 415, y: 190)
        shopIconSprite.zPosition = 10
        addChild(shopIconSprite)
        shopIconSprite.name = "shop"
        shopIconSprite.isHidden = true
        
        settingsIconSprite = SKSpriteNode(imageNamed: "settings.png")
        settingsIconSprite.size = CGSize(width: 60, height: 60)
        settingsIconSprite.position = CGPoint(x: 415, y: 130)
        settingsIconSprite.zPosition = 10
        addChild(settingsIconSprite)
        settingsIconSprite.isHidden = true
        
        helpIconSprite = SKSpriteNode(imageNamed: "help.png")
        helpIconSprite.size = CGSize(width: 60, height: 60)
        helpIconSprite.position = CGPoint(x: 415, y: 70)
        helpIconSprite.zPosition = 10
        addChild(helpIconSprite)
        helpIconSprite.isHidden = true
        
        // timer
        timerSprite = SKSpriteNode(imageNamed: "time_display.png")
        timerSprite.size = CGSize(width: 150, height: 150)
        timerSprite.position = CGPoint(x: -300, y: 250)
        timerSprite.zPosition = 3
        addChild(timerSprite)
        
        // timer label
        timerLabelSprite = SKLabelNode(fontNamed: "SalsaScripture20-Regular")
        timerLabelSprite.text = "80 secs" // user has 80 seconds in every day
        timerLabelSprite.fontColor = .black
        timerLabelSprite.position = CGPoint(x: -282, y: 235)
        timerLabelSprite.zPosition = 4
        addChild(timerLabelSprite)
        
        // set up money earned node
        moneySprite = SKSpriteNode(imageNamed: "money_display.png")
        moneySprite.size = CGSize(width: 150, height: 150)
        moneySprite.position = CGPoint(x: -95, y: 250)
        moneySprite.zPosition = 3
        addChild(moneySprite)
        
        moneyLabelSprite = SKLabelNode(fontNamed: "SalsaScripture20-Regular")
        moneyLabelSprite.text = String(UserDataManager.shared.loadMoneyEarned())
        moneyLabelSprite.fontColor = .black
        moneyLabelSprite.position = CGPoint(x: -95, y: 235)
        moneyLabelSprite.zPosition = 4
        addChild(moneyLabelSprite)
        

        // set up order base symbol
        orderBase = SKSpriteNode()
        orderBase.size = CGSize(width: 60, height: 60)
        orderBase.zPosition = 3
        orderBase.position = CGPoint(x: -165, y: 110)
        orderBase.alpha = 0
        addChild(orderBase)

        
        // set up order topping 1 symbol
        orderTopping1 = SKSpriteNode()
        orderTopping1.size = CGSize(width: 60, height: 60)
        orderTopping1.zPosition = 3
        orderTopping1.position = CGPoint(x: -70, y: 110)
        orderTopping1.alpha = 0
        addChild(orderTopping1)

        
        // set up speech bubble
        speechBubble = SKSpriteNode(imageNamed: "speechBubble.png")
        speechBubble.size = CGSize(width: 400, height: 400)
        speechBubble.position = CGPoint(x: -140, y: 80)
        speechBubble.alpha = 0
        addChild(speechBubble)
        
    }
    
    
    func startDay()
    {
        isDayActive = true
        moneyEarnedInDay = 0
        customersServed = 0
        toggleIngredients(active: true)
        startTimer()
        spawnCustomer()

    }
    
    func startTimer()
    {
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }
    
    @objc func updateTimer()
    {
        // pass a second
        secondsPassed += 1
        
        // update the label sprite
        timerLabelSprite.text = String(81 - secondsPassed) + " secs"
        
        if secondsPassed == 80
        {
            endDay()
        }
    }
    
    func pauseTimer()
    {
        timer?.invalidate()
    }
    
    func endDay()
    {
        // set the day as inactive
        isDayActive = false
        
        // invalidate & reset the timer
        timer?.invalidate()
        secondsPassed = 0
        
        // remove the customer, drink, & order sprites
        customerSprite.removeFromParent()
        barista_drinkSprite.removeFromParent()
        orderBase.alpha = 0
        orderTopping1.alpha = 0
        speechBubble.alpha = 0
        
        // make ingredients untouchable
        toggleIngredients(active: false)
        
        // reset mix bar
        mixButton.resetProgress()
        
        // hide ingredients
        hideAllIngredients()
        
        //TODO: change background to night, have it fade
        
        // save the user data
        
        // save the day data
        daysOpened = UserDataManager.shared.loadDays() // days since café opened
        UserDataManager.shared.saveDays(daysOpened + 1)
        
        // save the money earned
        totalMoney = UserDataManager.shared.loadMoneyEarned() // total money earned in the day
        //UserDataManager.shared.saveMoneyEarned(totalMoney + moneyEarnedInDay)
        
        // display stats (money earned, customers served, etc)
        
        // display the summary background
        eodSummarySprite = SKSpriteNode(imageNamed: "eod_summary")
        eodSummarySprite.size = CGSize(width: 450, height: 450)
        eodSummarySprite.position = CGPoint(x: 0, y: 45)
        eodSummarySprite.zPosition = 2
        addChild(eodSummarySprite)
        
        // display the next button
        nextButtonSprite = SKSpriteNode(imageNamed: "next_button")
        nextButtonSprite.size = CGSize(width: 150, height: 125)
        nextButtonSprite.position = CGPoint(x:0, y: -35)
        nextButtonSprite.zPosition = 3
        nextButtonSprite.name = "next"
        addChild(nextButtonSprite)
        
        // days opened
        daysOpenedSprite = SKLabelNode(fontNamed: "SalsaScripture20-Regular")
        daysOpenedSprite.text = "Days Opened: " + String(UserDataManager.shared.loadDays())
        daysOpenedSprite.position = CGPoint(x: 0, y: 25)
        daysOpenedSprite.zPosition = 3
        daysOpenedSprite.fontColor = .black
        addChild(daysOpenedSprite)
        
        // money earned
        moneyEarnedSprite = SKLabelNode(fontNamed: "SalsaScripture20-Regular")
        moneyEarnedSprite.text = "Money Earned Today: " + String(moneyEarnedInDay)
        moneyEarnedSprite.position = CGPoint(x: 0, y: 65)
        moneyEarnedSprite.zPosition = 3
        moneyEarnedSprite.fontColor = .black
        addChild(moneyEarnedSprite)
        
        // customers served
        customersServedSprite = SKLabelNode(fontNamed: "SalsaScripture20-Regular")
        customersServedSprite.text = "Customers Served Today: " + String(customersServed)
        customersServedSprite.position = CGPoint(x: 0, y: 100)
        customersServedSprite.zPosition = 3
        customersServedSprite.fontColor = .black
        addChild(customersServedSprite)
    
        // for debugging
        print("round is done")
        
    }
    
    func loadInventory()
    {
        // loads the user's current items
        inventory = UserDataManager.shared.loadInventory()
        
        // if the inventory is not empty, loop through and load each asset
        if inventory != nil
        {
            for i in 0..<inventory.count
            {
                print(inventory[i].getImageName())
                
                switch inventory[i].getType() {
                case "decor":
                    if inventory[i].getIsEquipped() == true
                    {
                        decorAsset = inventory[i]
                    }
                case "background":
                    if inventory[i].getIsEquipped() == true
                    {
                        let bg_name = inventory[i].getImageName().components(separatedBy: "_").first
                        print(bg_name!)
                        background = SKSpriteNode(imageNamed: bg_name!)
                    }
                case "furniture":
                    if inventory[i].getIsEquipped() == true
                    {
                        // store the second word in the image name
                        let furniture_name = inventory[i].getImageName().components(separatedBy: "_").first
                        print("FURNITURE: " + furniture_name!)
                        
                        // handle trays
                        if (furniture_name == "tray")
                        {
                            boardAsset = SKSpriteNode(imageNamed: inventory[i].getImageName())
                        }
                        
                        // handle counters
                        if (furniture_name == "counter")
                        {
                            counterAsset = SKSpriteNode(imageNamed: inventory[i].getImageName())
                        }
                        
                    }
                default:
                    print("Error loading inventory...")
                }
            }
        }
    }
    
    func displayDecor()
    {
        
        if decorAsset != nil
        {
            decorAssetSprite = ItemSprite(itemToCreate: decorAsset)
            decorAssetSprite.position = CGPoint(x: 400, y: 20)
            decorAssetSprite.zPosition = 10
            addChild(decorAssetSprite)
        }
        
    }
    
    func resetItemsSprites()
    {
        // reset the decor asset
        if decorAssetSprite != nil
        {
            decorAssetSprite.removeFromParent()
        }
        
        // reset the background
        background.removeFromParent()
        
        // reset the furniture
        boardAsset.removeFromParent()
        counterAsset.removeFromParent()
    }
    
    func loadBackground()
    {
        // add background to scene
        background.position = CGPoint(x: 0, y: 0)
        background.scale(to: CGSize(width: 1400, height: 600))
        background.zPosition = -3
        addChild(background)
        background.isUserInteractionEnabled = false
    }
    
    func loadMixingBoard()
    {
        // add the mix board to the scene
        boardAsset.zPosition = 1
        let boardScale = 0.2
        boardAsset.setScale(boardScale)
        boardAsset.position = CGPoint(x: -50, y: -200)
        addChild(boardAsset)
    }
    
    func loadMixButton()
    {
        // add the mix button
        mixButton = DrinkMixButton()
        addChild(mixButton)
    }
    
    func loadBaristaCounter()
    {
        // add the counter to the scene
        counterAsset.zPosition = -1
        let scale: CGFloat = 0.5
        counterAsset.setScale(scale)
        counterAsset.position = CGPoint(x: 0, y: -170)
        counterAsset.isUserInteractionEnabled = true
        addChild(counterAsset)
    }
    
    func setupBackgroundMusic()
    {
        if let musicFileURL = Bundle.main.url(forResource: "audio/main_song", withExtension: "mp3") {
            do {
                backgroundMusicPlayer = try AVAudioPlayer(contentsOf: musicFileURL)
                backgroundMusicPlayer?.numberOfLoops = -1  // Loop indefinitely
                backgroundMusicPlayer?.prepareToPlay()
            } catch {
                print("Error loading background music: \(error)")
            }
        }
    }
    
    func playBackgroundMusic()
    {
        backgroundMusicPlayer?.play()
    }
    
    func setupAudioPlayer(fileName: String)
    {
        if let audioFileURL = Bundle.main.url(forResource: fileName, withExtension: "mp3") {
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: audioFileURL)
                audioPlayer?.prepareToPlay()
            } catch {
                print("Error loading audio file: \(error)")
            }
        }
    }
    
    func playSound()
    {
        audioPlayer?.currentTime = 0
        audioPlayer?.play()
    }
    
    func displayIngredients()
    {
        
        //add ingredient SYMBOLS, set them to hidden at first
        symbol_coffee = SKSpriteNode(imageNamed: "Drinks/Ingredients/coffee_raw.png")
        symbol_coffee.position = CGPoint(x: -45, y: -186)
        symbol_coffee.size = CGSize(width: 60, height: 60)
        symbol_coffee.isHidden = true
        symbol_coffee.zPosition = 2
        addChild(symbol_coffee)
        
        symbol_matcha = SKSpriteNode(imageNamed: "Drinks/Ingredients/matcha_raw.png")
        symbol_matcha.position = CGPoint(x: -45, y: -186)
        symbol_matcha.size = CGSize(width: 60, height: 60)
        symbol_matcha.isHidden = true
        symbol_matcha.zPosition = 2
        addChild(symbol_matcha)
        
        symbol_chai = SKSpriteNode(imageNamed: "Drinks/Ingredients/chai_raw.png")
        symbol_chai.position = CGPoint(x: -45, y: -186)
        symbol_chai.size = CGSize(width: 60, height: 60)
        symbol_chai.isHidden = true
        symbol_chai.zPosition = 2
        addChild(symbol_chai)
        
        symbol_cherry = SKSpriteNode(imageNamed: "Drinks/Ingredients/cherry_symbol.png")
        symbol_cherry.position = CGPoint(x: 25, y: -186)
        symbol_cherry.size = CGSize(width: 60, height: 60)
        symbol_cherry.isHidden = true
        symbol_cherry.zPosition = 2
        addChild(symbol_cherry)
        
        symbol_rose = SKSpriteNode(imageNamed: "Drinks/Ingredients/rose_symbol.png")
        symbol_rose.position = CGPoint(x: 25, y: -186)
        symbol_rose.size = CGSize(width: 60, height: 60)
        symbol_rose.isHidden = true
        symbol_rose.zPosition = 2
        addChild(symbol_rose)
        
        symbol_stardust = SKSpriteNode(imageNamed: "Drinks/Ingredients/stardust_symbol.png")
        symbol_stardust.position = CGPoint(x: 25, y: -186)
        symbol_stardust.size = CGSize(width: 60, height: 60)
        symbol_stardust.isHidden = true
        symbol_stardust.zPosition = 2
        addChild(symbol_stardust)
        
        symbol_sweetcream = SKSpriteNode(imageNamed: "Drinks/Ingredients/sweetcream_symbol.png")
        symbol_sweetcream.position = CGPoint(x: 25, y: -186)
        symbol_sweetcream.size = CGSize(width: 60, height: 60)
        symbol_sweetcream.isHidden = true
        symbol_sweetcream.zPosition = 2
        addChild(symbol_sweetcream)
        
        // display the tappable ingredients

        // bases
        matcha = IngredientSprite(ingredient: .matcha)
        addChild(matcha)
        matcha.isUserInteractionEnabled = true
        
        coffee = IngredientSprite(ingredient: .coffee)
        addChild(coffee)
        coffee.isUserInteractionEnabled = true
        
        chai = IngredientSprite(ingredient: .chai)
        addChild(chai)
        chai.isUserInteractionEnabled = true
        
        
        // toppings
        cherry = IngredientSprite(ingredient: .cherry)
        addChild(cherry)
        cherry.isUserInteractionEnabled = true
        
        stardust = IngredientSprite(ingredient: .stardust)
        addChild(stardust)
        stardust.isUserInteractionEnabled = true
        
        rose = IngredientSprite(ingredient: .rose)
        addChild(rose)
        rose.isUserInteractionEnabled = true
        
        sweetcream = IngredientSprite(ingredient: .sweetcream)
        addChild(sweetcream)
        sweetcream.isUserInteractionEnabled = true
    }
    
    func spawnCustomer()
    {
        
        // reset flags, objects, etc
        numIngredientsUsed = 0
        mixButton.isUserInteractionEnabled = true
        drink_Finished = false
        customersOrder = nil
        currCustomer = nil
        customerSprite = nil

        // initialize the customer's order
        customersOrder = Drink(isOrder: true) //the constructor creates a random order
        
        // initialize the customer
        currCustomer = Customer(order: customersOrder)
        
        // initialize + configure the customer sprite
        customerSprite = CustomerSprite(customer: currCustomer)
        customerSprite.alpha = 0
        customerSprite.isUserInteractionEnabled = true

        // display the customer sprite
        // wait for one second
        addChild(customerSprite)
        Task {
            try await Task.sleep(nanoseconds: 1000000000)
            await customerSprite.run(fadeIn)
            
            // display the customer's order
//            customerOrderString = customerSprite.orderString() // create the order string
//            customerOrderNode = MSKAnimatedLabel(text: customerOrderString) // initialize the label
//            customerOrderNode.position = CGPoint(x: -0, y: 50) // configure the position
//            addChild(customerOrderNode) // add it to the scene
            
            displayCustomerOrder()
            
        }
        
    }
    
    func displayCustomerOrder()
    {
        
        // configure the order symbols
        switch currCustomer.getOrder().getBase()
        {
        case "matcha":
            orderBase.texture = SKTexture(imageNamed: "Drinks/Ingredients/matcha_raw.png")
            
        case "coffee":
            orderBase.texture = SKTexture(imageNamed: "Drinks/Ingredients/coffee_raw.png")
        
        case "chai":
            orderBase.texture = SKTexture(imageNamed: "Drinks/Ingredients/chai_raw.png")
        default:
            print("Fatal error with base")
        }
        
        switch currCustomer.getOrder().getTopping()
        {
        case "cherry":
            orderTopping1.texture = SKTexture(imageNamed: "Drinks/Ingredients/cherry_symbol.png")
            
        case "stardust":
            orderTopping1.texture = SKTexture(imageNamed: "Drinks/Ingredients/stardust_symbol.png")
            
        case "sweetcream":
            orderTopping1.texture = SKTexture(imageNamed: "Drinks/Ingredients/sweetcream_symbol.png")
        
        case "rose":
            orderTopping1.texture = SKTexture(imageNamed: "Drinks/Ingredients/rose_symbol.png")
            
        default:
            print("Fatal error with topping1")
            
        }
        
        speechBubble.run(fadeIn)
        orderBase.run(fadeIn)
        orderTopping1.run(fadeIn)
        
    }
    
    func completeDrinkOrder()
    {
        
            if barista_drinkSprite.frame.intersects(customerSprite.frame)  // if user drags the drink to a customer
            {
                
                // update the customers served counter
                customersServed += 1

                // make the drink disappear
                barista_drinkSprite.removeFromParent()
                
                // set the drink finished flag to true
                drink_Finished = true
                
                // compare the barista drink to the customer's order
                if (barista_drink.isEqual(drinkToCompare: currCustomer.getOrder()) == true)
                {
                    // play the correct drink sound
                    setupAudioPlayer(fileName: "audio/drink_correct")
                    playSound()
                    
                    // keep track of money earned in day for EOD summary
                    moneyEarnedFromDrink = currCustomer.getOrder().getPrice()
                    moneyEarnedInDay += moneyEarnedFromDrink
                    
                    // update the money display at the top
                    let currentMoney = UserDataManager.shared.loadMoneyEarned()
                    UserDataManager.shared.saveMoneyEarned(moneyEarnedFromDrink + currentMoney)
                    moneyLabelSprite.text = String(UserDataManager.shared.loadMoneyEarned())
                    
                    // display the money earned
                    moneyEarnedFromDrinkSprite = SKLabelNode(fontNamed: "SalsaScripture20-Regular")
                    moneyEarnedFromDrinkSprite.text = String(moneyEarnedFromDrink)
                    moneyEarnedFromDrinkSprite.position = CGPoint(x: 0, y: 0)
                    moneyEarnedFromDrinkSprite.fontSize = 40
                    moneyEarnedFromDrinkSprite.alpha = 0
                    addChild(moneyEarnedFromDrinkSprite)
                    moneyEarnedFromDrinkSprite.run(fadeIn)
                    Task {
                        try await Task.sleep(nanoseconds: 1000000000)
                        await moneyEarnedFromDrinkSprite.run(fadeOut)
                    }
                    
                    // customer fades out
                    customerSprite.run(fadeOut)
                    
                    // order text fades out
                    speechBubble.run(fadeOut)
                    orderBase.run(fadeOut)
                    orderTopping1.run(fadeOut)
                    
                }
                else
                {
                    
                    // play the wrong drink sound
                    setupAudioPlayer(fileName: "audio/drink_incorrect")
                    playSound()
                    
                    // customer fades out
                    customerSprite.run(fadeOut)
                    
                    // order text fades out
                    speechBubble.run(fadeOut)
                    orderBase.run(fadeOut)
                    orderTopping1.run(fadeOut)
                    
                    //banana
                    //customerOrderNode.run(fadeOut)

                }
                
                // if the day is still active, spawn another customer (helps control the timer)
                if (isDayActive == true)
                {
                    spawnCustomer()
                }
                
            }
        
    }
    
    func assignDelegates()
    {
        
        // assign delegate to mix button
        mixButton.delegate = self
    
        
        // assign delegates to ingredients:
        
        // bases
        matcha.delegate = self
        coffee.delegate = self
        chai.delegate = self
        
        // topping
        cherry.delegate = self
        rose.delegate = self
        stardust.delegate = self
        sweetcream.delegate = self
        
    }

    
    /**
     This function handles what happens when the mix button is touched.
     */
    func mixButtonTouched(_ isFull: Bool)
    {

        // play button pressing sound
        setupAudioPlayer(fileName: "audio/ingredient_add")
        playSound()
            
        // animate the button being pressed
        //mixButton.animatePushingButton()
            
        // fill the progress bar
        mixButton.animateFilling()

        // when the progress bar is full...
        if (isFull == true)
        {
            
            customerSprite.isUserInteractionEnabled = true
            
            drink_Finished = true
            
            // spawn the user-created drink on the countertop
            barista_drinkSprite = DrinkSprite(drinkOrder: barista_drink)
            barista_drinkSprite.isUserInteractionEnabled = true
            
            // assign delegate to drink sprite
            barista_drinkSprite.delegate = self
            
            addChild(barista_drinkSprite)
            
            // play the drink_finished sound
            setupAudioPlayer(fileName: "audio/drink_finished")
            playSound()
            
            //TODO: add a sparkle animation onto the newly made drink
            
            // reset the progress bar
            mixButton.resetProgress()
            
            // user cannot touch mix button anymore
            mixButton.isUserInteractionEnabled = false
            
            // clear the mixing board
            hideAllIngredients()
            
        }
        
        
    }
        
    /**
     This function handles what happens when an ingredient sprite is touched,
     */
    func ingredientTouched(_ ingredient: String)
    {
        
        // play the ingredient_add sound
        setupAudioPlayer(fileName: "audio/ingredient_add")
        playSound()
            
        // bases
        if ingredient == "matcha"
        {
            // set the property of the drink
            barista_drink.setBase(base: "matcha")
            
            // display the matcha symbol
            symbol_matcha.isHidden = false
            numIngredientsUsed+=1 // add to counter
            
            // hide the other bases
            symbol_coffee.isHidden = true
            symbol_chai.isHidden = true
            
            // for debugging
            print("matcha is added")
        }
        
        if ingredient == "coffee"
        {
            // set the property of the drink
            barista_drink.setBase(base: "coffee")
            
            // display the coffee symbol
            symbol_coffee.isHidden = false
            numIngredientsUsed+=1 // add to counter
            
            // hide the other bases
            symbol_matcha.isHidden = true
            symbol_chai.isHidden = true
            
            // for debugging
            print("coffee is added")
        }
        
        if ingredient == "chai"
        {
            // set the property of the drink
            barista_drink.setBase(base: "chai")
            
            // display the chai symbol
            symbol_chai.isHidden = false
            numIngredientsUsed+=1 // add to counter
            
            // hide the other bases
            symbol_coffee.isHidden = true
            symbol_matcha.isHidden = true
            
            // for debugging
            print("chai is added")
        }
        
        // syrups
        if ingredient == "cherry"
        {
            // set the property of the drink
            barista_drink.setTopping(topping: "cherry")
            
            // display the vanilla syrup symbol
            symbol_cherry.isHidden = false
            numIngredientsUsed+=1 // add to counter
            
            // hide the other syrups
            symbol_rose.isHidden = true
            symbol_stardust.isHidden = true
            symbol_sweetcream.isHidden = true
            
            // for debugging
            print("cherry added")

        }
        
        if ingredient == "rose"
        {
            // set the property of the drink
            barista_drink.setTopping(topping: "rose")
            
            // display the caramel syrup symbol
            symbol_rose.isHidden = false
            numIngredientsUsed+=1 // add to counter
            
            // hide the other syrups
            symbol_cherry.isHidden = true
            symbol_stardust.isHidden = true
            symbol_sweetcream.isHidden = true

            
            // for debugging
            print("rose added")
        }
        
        if ingredient == "stardust"
        {
            // set the property of the drink
            barista_drink.setTopping(topping: "stardust")
            
            // display the chocolate syrup symbol
            symbol_stardust.isHidden = false
            numIngredientsUsed+=1 // add to counter
            
            // hide the other syrups
            symbol_cherry.isHidden = true
            symbol_rose.isHidden = true
            symbol_sweetcream.isHidden = true

            
            // for debugging
            print("stardust is added")
        }
        
        
        if ingredient == "sweetcream"
        {
            
            // set the property of the drink
            barista_drink.setTopping(topping: "sweetcream")
            
            // display the sweet cream symbol
            symbol_sweetcream.isHidden = false
            numIngredientsUsed+=1 // add to counter
            
            // hide the other ingredients
            symbol_cherry.isHidden = true
            symbol_rose.isHidden = true
            symbol_stardust.isHidden = true
            
            // for debugging
            print("sweet cream is added")
            
        }
    
    }
    
    /**
     This function hides all ingredient symbols from the mixing board. It's typically used when a drink order is mixed and ready
     to be served to the customer.
     */
    func hideAllIngredients()
    {
        
        // bases
        symbol_coffee.isHidden = true
        symbol_chai.isHidden = true
        symbol_matcha.isHidden = true
        
        // syrups
        symbol_cherry.isHidden = true
        symbol_rose.isHidden = true
        symbol_stardust.isHidden = true
        symbol_sweetcream.isHidden = true
        
    }
    
    func toggleIngredients(active: Bool)
    {
        
        if active == true
        {
            
            chai.isUserInteractionEnabled = true
            matcha.isUserInteractionEnabled = true
            coffee.isUserInteractionEnabled = true
            cherry.isUserInteractionEnabled = true
            stardust.isUserInteractionEnabled = true
            sweetcream.isUserInteractionEnabled = true
            rose.isUserInteractionEnabled = true
            mixButton.isUserInteractionEnabled = true
            
        }
        else
        {
            
            chai.isUserInteractionEnabled = false
            matcha.isUserInteractionEnabled = false
            coffee.isUserInteractionEnabled = false
            cherry.isUserInteractionEnabled = false
            stardust.isUserInteractionEnabled = false
            sweetcream.isUserInteractionEnabled = false
            rose.isUserInteractionEnabled = false
            mixButton.isUserInteractionEnabled = false

        }
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if let touch = touches.first
        {
            let touchLocation = touch.location(in: self)
            let node = self.atPoint(touchLocation)
            print(touchLocation)
            
            // 'next' button logic
            if node.name == "next"
            {
                
                // play pressing sound
                setupAudioPlayer(fileName: "audio/ingredient_add")
                playSound()
                
                // remove the EOD summary & all necessary sprites
                eodSummarySprite.removeFromParent()
                nextButtonSprite.removeFromParent()
                daysOpenedSprite.removeFromParent()
                moneyEarnedSprite.removeFromParent()
                customersServedSprite.removeFromParent()
                
                // start the next round
                print("next day!") //for debugging purposes
                startDay()
            }
            
            // 'hamburger button' tap logic
            if node.name == "toolbar"
            {
                print("touched toolbar")
                // if the icons are hidden, unhide them
                if (shopIconSprite.isHidden == true)
                {
                    shopIconSprite.isHidden = false
                    settingsIconSprite.isHidden = false
                    helpIconSprite.isHidden = false
                }
                else
                {
                    shopIconSprite.isHidden = true
                    settingsIconSprite.isHidden = true
                    helpIconSprite.isHidden = true
                }
                
            }
            
            // 'shop' tap logic
            if node.name == "shop"
            {
                
                // pause the game round
                pauseTimer()
                
                // transition to the shop scene
                let shopScene = ShopScene(size: self.size)
                shopScene.scaleMode = self.scaleMode
                shopScene.previousScene = self // Pass reference to GameScene
                let transition = SKTransition.fade(withDuration: 1.0)
                self.view?.presentScene(shopScene, transition: transition)
            }
            
        }
        
    }

} // end of gamescene class
