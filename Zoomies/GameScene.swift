//
//  GameScene.swift
//  Zoomies
//
//  Created by Ritika Joshi on 10/18/25.
//

import SpriteKit
import UIKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    private var gameStarted = false
    private var tapToStartLabel: SKSpriteNode?

    private var dog: SKSpriteNode!

    private var idleY: CGFloat { size.height * 0.38 }
    private var runY: CGFloat { size.height * 0.355 }

    private var idleFrames: [SKTexture] = []
    private var runFrames: [SKTexture] = []
    private var jumpFrames: [SKTexture] = []
    private var hurtFrames: [SKTexture] = []
    private var dieFrames: [SKTexture] = []
    private var healthSkull: SKSpriteNode?

    private var boneCollectedFrames: [SKTexture] = []
    private var lastObstacleSpawnTime: TimeInterval = 0

    private enum DogState {
        case idle, running, jumping, hurt, dead
    }
    private var dogState: DogState = .idle

    private var healthHearts: [SKSpriteNode] = []
    private var currentHealth = 5
    
    private var distanceLabelNode: SKSpriteNode?
    private var distanceValueLabel: SKLabelNode?
    private var distanceTraveled: CGFloat = 0


    private var menuButton: SKSpriteNode?
    private var inMenu = false
    private var menuOverlay: SKSpriteNode?
    // keep track of nodes paused by menu so we can resume them
    private var menuPausedNodes: [SKNode] = []

    // MARK: - Initializer
    init(size: CGSize, isRestarting: Bool = false) {
        self.isRestarting = isRestarting
        super.init(size: size)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private var isRestarting = false


    // MARK: - Scene Lifecycle
    override func didMove(to view: SKView) {
        backgroundColor = .black
        physicsWorld.contactDelegate = self

        // 🟢 Skip title screen if restarting
        if isRestarting {
            startGame()   // go straight to idle dog setup
        } else {
            showTitleScreen()  // only for first launch
        }
    }

    // MARK: - Title Screen
    private func showTitleScreen() {
        let titleTexture = SKTexture(imageNamed: "zoomies-title")
        titleTexture.filteringMode = .nearest
        
        let title = SKSpriteNode(texture: titleTexture)
        title.setScale(3)
        title.position = CGPoint(x: size.width / 1.8, y: size.height / 2.15)
        title.zPosition = 100
        title.alpha = 0.0
        addChild(title)
        
        // 🐕 Add barking dog on title screen
        let barkSheet = SKTexture(imageNamed: "dog-bark-sprite")
        barkSheet.filteringMode = .nearest
        var barkFrames: [SKTexture] = []   // must be var, not let
        let frameCount = 13  // number of frames in dog-bark-sprite
        let frameWidth = 1.0 / CGFloat(frameCount)
        for i in 0..<frameCount {
            let rect = CGRect(x: frameWidth * CGFloat(i), y: 0, width: frameWidth, height: 1.0)
            barkFrames.append(SKTexture(rect: rect, in: barkSheet))   // ✅ fixed target array
        }
        
        let barkDog = SKSpriteNode(texture: barkFrames.first)
        barkDog.setScale(3)
        barkDog.position = CGPoint(x: size.width / 2.8, y: size.height * 0.53)
        barkDog.zPosition = 90
        barkDog.alpha = 0
        addChild(barkDog)
        
        // Animate barking loop
        let barkAnim = SKAction.animate(with: barkFrames, timePerFrame: 0.12)
        barkDog.run(.repeatForever(barkAnim))
        
        // Combined fade in/out for both title and dog
        let fadeIn = SKAction.fadeAlpha(to: 1.0, duration: 1.0)
        let wait = SKAction.wait(forDuration: 1.5)
        let fadeOut = SKAction.fadeAlpha(to: 0.0, duration: 1.0)
        let remove = SKAction.removeFromParent()
        let startGameAction = SKAction.run { [weak self] in self?.startGame() }
        
        // Apply same fade sequence to both
        let titleSequence = SKAction.sequence([fadeIn, wait, fadeOut, remove])
        let dogSequence = SKAction.sequence([fadeIn, wait, fadeOut, remove])
        
        title.run(titleSequence)
        barkDog.run(SKAction.sequence([dogSequence, startGameAction]))
    }

    // MARK: - Game Setup
    private func startGame() {
        backgroundColor = .systemBackground
        addSky()
        addClouds()
        addRoad()
        addDog()
        addHealthDisplay()
        addDistanceDisplay()
        addTapToStartLabel()
        addMenuButton() // 🟡 menu button visible immediately (idle)
        gameStarted = true
    }

    // MARK: - Dog Setup
    private func addDog() {
        func loadFrames(from imageName: String, frameCount: Int) -> [SKTexture] {
            let sheet = SKTexture(imageNamed: imageName)
            sheet.filteringMode = .nearest
            var frames: [SKTexture] = []
            let frameWidth = 1.0 / CGFloat(frameCount)
            for i in 0..<frameCount {
                let rect = CGRect(x: frameWidth * CGFloat(i), y: 0, width: frameWidth, height: 1.0)
                frames.append(SKTexture(rect: rect, in: sheet))
            }
            return frames
        }

        idleFrames = loadFrames(from: "dog-idle-sprite", frameCount: 16)
        runFrames  = loadFrames(from: "dog-running-sprite", frameCount: 8)
        jumpFrames = loadFrames(from: "dog-jump-sprite", frameCount: 7)
        hurtFrames = loadFrames(from: "dog-hurt-sprite", frameCount: 4)
        dieFrames  = loadFrames(from: "dog-die-sprite", frameCount: 8)
        boneCollectedFrames = loadFrames(from: "dog-bone-collected-sprite", frameCount: 6)

        dog = SKSpriteNode(texture: idleFrames.first)
        dog.position = CGPoint(x: size.width * 0.2, y: idleY)
        dog.setScale(3)
        dog.zPosition = 5
        addChild(dog)

        dog.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: dog.size.width / 2.8, height: dog.size.height / 3))
        dog.physicsBody?.isDynamic = true
        dog.physicsBody?.affectedByGravity = false
        dog.physicsBody?.categoryBitMask = 1
        dog.physicsBody?.contactTestBitMask = 2 | 4   // logs + bones
        dog.physicsBody?.collisionBitMask = 0

        startIdle()
    }

    // MARK: - Animations
    private func startIdle() {
        dogState = .idle
        dog.removeAllActions()
        let idleAnimation = SKAction.animate(with: idleFrames, timePerFrame: 0.12)
        dog.run(SKAction.repeatForever(idleAnimation))
    }

    private func startRunning() {
        guard dogState != .running else { return }
        dogState = .running
        
        // Fade out "Tap to Start" text once the dog starts running
        if let label = tapToStartLabel {
            label.run(SKAction.sequence([
                SKAction.fadeOut(withDuration: 0.5),
                SKAction.removeFromParent()
            ]))
            tapToStartLabel = nil
        }

        dog.removeAllActions()
        let moveDown = SKAction.moveTo(y: runY, duration: 0.1)
        dog.run(moveDown)
        let runAnimation = SKAction.animate(with: runFrames, timePerFrame: 0.065)
        dog.run(SKAction.repeatForever(runAnimation))

        if action(forKey: "obstacleSpawner") == nil {
            startObstacleSpawner()
            startBoneSpawner() // 🦴 NEW
        }
    }

    private func startJump() {
        guard dogState == .running else { return }
        dogState = .jumping
        dog.removeAllActions()

        let jumpAnimation = SKAction.animate(with: jumpFrames, timePerFrame: 0.04)
        let moveUp = SKAction.moveBy(x: 0, y: 110, duration: 0.5)
        let moveDown = SKAction.moveBy(x: 0, y: -105, duration: 0.3)
        let jumpMotion = SKAction.sequence([moveUp, moveDown])
        let jumpGroup = SKAction.group([jumpAnimation, jumpMotion])

        dog.run(jumpGroup) { [weak self] in
            self?.startRunning()
        }
    }

    private func startHurt() {
        guard dogState != .hurt, dogState != .dead else { return }
        dogState = .hurt
        dog.removeAllActions()

        // Instantly remove a heart if available
        if currentHealth > 0 {
            currentHealth -= 1
            let lostHeart = healthHearts.removeLast()
            lostHeart.removeFromParent()
        }

        // 💀 If health reaches zero, show skull immediately
        if currentHealth == 0 {
            let skullTexture = SKTexture(imageNamed: "health-skull")
            skullTexture.filteringMode = .nearest

            let skull = SKSpriteNode(texture: skullTexture)
            skull.setScale(1.4)
            skull.anchorPoint = CGPoint(x: 0.03, y: 0.52)
            skull.zPosition = 10

            // Position exactly where first heart would have been
            skull.position = CGPoint(x: size.width * 0.1 + 52.5, y: size.height * 0.155)

            skull.alpha = 0
            addChild(skull)
            healthSkull = skull

            // Fade-in effect
            let fadeIn = SKAction.fadeIn(withDuration: 0.4)
            skull.run(fadeIn)

            // Proceed to death after short delay
            run(SKAction.wait(forDuration: 0.3)) { [weak self] in
                self?.startDeath()
            }
            return
        }

        // Normal hurt animation (only if not dead)
        let hurtAnimation = SKAction.animate(with: hurtFrames, timePerFrame: 0.05)
        dog.run(SKAction.sequence([hurtAnimation, SKAction.wait(forDuration: 0.1)])) { [weak self] in
            self?.startRunning()
        }
    }



    private func startDeath() {
        guard dogState != .dead else { return }
        dogState = .dead
        dog.removeAllActions()

        // Pause logs & bones
        removeAction(forKey: "obstacleSpawner")
        removeAction(forKey: "boneSpawner")
        for node in children where node.name == "log" || node.name == "bone" {
            node.removeAllActions()
        }

        // hide menu once dead
        menuButton?.removeFromParent()
        inMenu = false
        menuOverlay?.removeFromParent()
        menuPausedNodes.removeAll()

        // 💀 Add skull on health bar when all hearts are gone
        if currentHealth == 0 {
            let skullTexture = SKTexture(imageNamed: "health-skull")
            skullTexture.filteringMode = .nearest

            let skull = SKSpriteNode(texture: skullTexture)
            skull.setScale(1.2)
            skull.anchorPoint = CGPoint(x: -0.15, y: 0.55)
            skull.zPosition = 10

            // Place exactly where first heart appears
            if let firstHeart = healthHearts.first {
                skull.position = firstHeart.position
            } else {
                // fallback if all hearts were already removed
                skull.position = CGPoint(x: size.width * 0.1 + 90, y: size.height * 0.215)
            }

            addChild(skull)
            healthSkull = skull

            // Subtle fade-in for dramatic effect
            skull.alpha = 0
            skull.run(SKAction.fadeIn(withDuration: 0.4))
        }

        // Land at running Y
        let groundY = size.height * 0.355
        let moveToGround = SKAction.moveTo(y: groundY, duration: 0.1)

        let dieAnimation = SKAction.animate(with: dieFrames, timePerFrame: 0.12)
        let wait = SKAction.wait(forDuration: 1.5)
        let fadeBlack = SKAction.run { [weak self] in self?.showGameOverScreen() }

        // Make skull fade away with Game Over fade
        let fadeSkull = SKAction.fadeOut(withDuration: 1.0)
        if let skull = healthSkull {
            skull.run(fadeSkull)
        }

        let sequence = SKAction.sequence([moveToGround, dieAnimation, wait, fadeBlack])
        dog.run(sequence)
    }

    
    private func showGameOverScreen() {
        gameStarted = false

        // Fade to black
        let fade = SKSpriteNode(color: .black, size: size)
        fade.position = CGPoint(x: size.width / 2, y: size.height / 2)
        fade.alpha = 0
        fade.zPosition = 200
        addChild(fade)
        fade.run(SKAction.fadeAlpha(to: 1.0, duration: 1.0))

        // 💀 Skull icon
        let skullTexture = SKTexture(imageNamed: "skull")
        skullTexture.filteringMode = .nearest
        let skull = SKSpriteNode(texture: skullTexture)
        skull.setScale(1.8)
        skull.position = CGPoint(x: size.width / 1.99, y: size.height / 1.5) // slightly above text
        skull.alpha = 0
        skull.zPosition = 210
        addChild(skull)

        // "Game Over" text
        let gameOverTexture = SKTexture(imageNamed: "game-over-title")
        gameOverTexture.filteringMode = .nearest
        let gameOver = SKSpriteNode(texture: gameOverTexture)
        gameOver.setScale(3.5)
        gameOver.position = CGPoint(x: size.width / 2, y: size.height / 1.8)
        gameOver.alpha = 0
        gameOver.zPosition = 210
        addChild(gameOver)

        // Fade-in animations
        let fadeInSequence = SKAction.sequence([
            SKAction.wait(forDuration: 1.0),
            SKAction.fadeIn(withDuration: 1.0)
        ])
        gameOver.run(fadeInSequence)
        skull.run(fadeInSequence)

        // Then fade in Play Again + Buttons together
        run(SKAction.sequence([
            SKAction.wait(forDuration: 2.2),
            SKAction.run { [weak self] in self?.addRestartOptions() }
        ]))
    }


    private func addRestartOptions() {
        // 🪦 "Play Again?" text
        let playAgainTexture = SKTexture(imageNamed: "play-again-title")
        playAgainTexture.filteringMode = .nearest
        let playAgain = SKSpriteNode(texture: playAgainTexture)
        playAgain.setScale(2.2)
        playAgain.position = CGPoint(x: size.width / 2, y: size.height / 3.1)
        playAgain.alpha = 0
        playAgain.zPosition = 210
        addChild(playAgain)

        // ✅ YES / NO buttons
        let whiteYes = SKTexture(imageNamed: "white-yes")
        let whiteNo  = SKTexture(imageNamed: "white-no")
        [whiteYes, whiteNo].forEach { $0.filteringMode = .nearest }

        let yesButton = SKSpriteNode(texture: whiteYes)
        let noButton  = SKSpriteNode(texture: whiteNo)
        yesButton.name = "yesButton"
        noButton.name  = "noButton"

        // 🔹 slightly smaller scale = same visual distance, smaller hitbox
        yesButton.setScale(2.05)
        noButton.setScale(2.05)
        yesButton.zPosition = 220
        noButton.zPosition  = 220

        // Keep anchor centered
        yesButton.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        noButton.anchorPoint  = CGPoint(x: 0.5, y: 0.5)

        // ✅ keep them close (your original distance)
        // same visual spacing as before (roughly matches /1.85 and /2.1 values)
        let buttonY = size.height / 3.4
        yesButton.position = CGPoint(x: size.width / 2 - 12, y: buttonY)
        noButton.position  = CGPoint(x: size.width / 2 + 22, y: buttonY)


        yesButton.alpha = 0
        noButton.alpha  = 0
        addChild(yesButton)
        addChild(noButton)

        // Fade all together
        let fadeInAll = SKAction.fadeIn(withDuration: 0.8)
        playAgain.run(fadeInAll)
        yesButton.run(fadeInAll)
        noButton.run(fadeInAll)

        // ✅ Add small press-down feedback animation
        func addTapAnimation(to button: SKSpriteNode) {
            let pressDown = SKAction.scale(to: 1.95, duration: 0.08)
            let release   = SKAction.scale(to: 2.05, duration: 0.08)
            button.run(SKAction.sequence([pressDown, release]))
        }
    }

   

    // MARK: - Obstacles (logs)
    private func startObstacleSpawner() {
        let spawn = SKAction.run { [weak self] in
            self?.spawnWoodenLog()
        }
        let wait = SKAction.wait(forDuration: 3.5, withRange: 1.5)
        let loop = SKAction.repeatForever(SKAction.sequence([spawn, wait]))
        run(loop, withKey: "obstacleSpawner")
    }

    private func spawnWoodenLog() {
        guard CACurrentMediaTime() - lastObstacleSpawnTime > 2 else { return }  // 2 sec gap
        lastObstacleSpawnTime = CACurrentMediaTime()

        let texture = SKTexture(imageNamed: "wooden-log")
        texture.filteringMode = .nearest

        let log = SKSpriteNode(texture: texture)
        log.name = "log"
        log.setScale(1.6)
        log.zPosition = 5

        let roadY = size.height * 0.251
        log.position = CGPoint(x: size.width + log.size.width, y: roadY + log.size.height / 4.2)
        addChild(log)

        log.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: log.size.width / 1.6, height: log.size.height / 1.8))
        log.physicsBody?.isDynamic = false
        log.physicsBody?.categoryBitMask = 2
        log.physicsBody?.contactTestBitMask = 1
        log.physicsBody?.collisionBitMask = 0

        let duration = Double.random(in: 3.5...5.0)
        let moveLeft = SKAction.moveBy(x: -size.width - log.size.width * 2, y: 0, duration: duration)
        log.run(SKAction.sequence([moveLeft, .removeFromParent()]))
    }

    // MARK: - Bones 🦴
    private func startBoneSpawner() {
        let spawn = SKAction.run { [weak self] in
            self?.spawnDogBone()
        }
        let wait = SKAction.wait(forDuration: 7.0, withRange: 3.0) // less frequent than logs
        run(SKAction.repeatForever(SKAction.sequence([spawn, wait])), withKey: "boneSpawner")
    }

    private func spawnDogBone() {

        let texture = SKTexture(imageNamed: "dog-bone")
        texture.filteringMode = .nearest
        let bone = SKSpriteNode(texture: texture)
        bone.name = "bone"
        bone.setScale(2.0)
        bone.zPosition = 5

        // higher than road
        let fixedY = size.height * 0.58   // ✨ consistent height above road
        bone.position = CGPoint(x: size.width + bone.size.width, y: fixedY)
        addChild(bone)

        bone.physicsBody = SKPhysicsBody(rectangleOf: bone.size)
        bone.physicsBody?.isDynamic = false
        bone.physicsBody?.categoryBitMask = 4
        bone.physicsBody?.contactTestBitMask = 1
        bone.physicsBody?.collisionBitMask = 0

        let duration = Double.random(in: 5.0...6.5)
        let moveLeft = SKAction.moveBy(x: -size.width - bone.size.width * 2, y: 0, duration: duration)
        bone.run(SKAction.sequence([moveLeft, .removeFromParent()]))
    }
    
    private func handleBoneCollected(_ bone: SKNode) {
        // Stop bone movement and remove
        bone.removeAllActions()
        bone.removeFromParent()

        // ✨ Yellow bone blink twice
        let blinkBone = SKSpriteNode(imageNamed: "dog-bone-yellow")
        blinkBone.setScale(2.0)
        blinkBone.position = bone.position
        blinkBone.zPosition = 6
        addChild(blinkBone)

        let blinkTwice = SKAction.sequence([
            SKAction.fadeIn(withDuration: 0.05),
            SKAction.wait(forDuration: 0.08),
            SKAction.fadeOut(withDuration: 0.05),
            SKAction.fadeIn(withDuration: 0.05),
            SKAction.wait(forDuration: 0.08),
            SKAction.fadeOut(withDuration: 0.05),
            SKAction.removeFromParent()
        ])
        blinkBone.run(blinkTwice)

        // ❤️ Add one heart if below 5, styled like addHealthDisplay()
        if currentHealth < 5 {
            currentHealth += 1

            let heartTexture = SKTexture(imageNamed: "heart")
            heartTexture.filteringMode = .nearest
            let newHeart = SKSpriteNode(texture: heartTexture)
            newHeart.setScale(1.2)
            newHeart.anchorPoint = CGPoint(x: -0.15, y: 0.55)

            // Use same spacing and alignment as addHealthDisplay()
            let heartSpacing: CGFloat = 35
            if let lastHeart = healthHearts.last {
                newHeart.position = CGPoint(
                    x: lastHeart.position.x + heartSpacing,
                    y: lastHeart.position.y
                )
            } else {
                newHeart.position = CGPoint(
                    x: size.width * 0.1 + 90,
                    y: size.height * 0.215
                )
            }

            newHeart.alpha = 0
            newHeart.zPosition = 10
            addChild(newHeart)
            healthHearts.append(newHeart)

            // ✨ Blink effect (same as restart hearts)
            let fadeIn = SKAction.fadeAlpha(to: 1, duration: 0.15)
            let fadeOut = SKAction.fadeAlpha(to: 0.6, duration: 0.15)
            let fadeInFinal = SKAction.fadeAlpha(to: 1, duration: 0.15)
            let blinkSequence = SKAction.sequence([fadeIn, fadeOut, fadeInFinal])
            newHeart.run(blinkSequence)
        }

        // Ensure total hearts never exceed 5 visually
        while healthHearts.count > 5 {
            let extra = healthHearts.removeLast()
            extra.removeFromParent()
        }
    }


    // 🔽🔽🔽  MENU HELPERS  🔽🔽🔽

    private func addMenuButton() {
        let tex = SKTexture(imageNamed: "menu-button")
        tex.filteringMode = .nearest
        let button = SKSpriteNode(texture: tex)
        button.name = "menuButton"
        button.setScale(2.4)
        // bottom-right near health
        button.position = CGPoint(x: size.width * 0.90, y: size.height * 0.83)
        button.zPosition = 30
        addChild(button)
        menuButton = button
    }

    private func pauseForMenu() {
        menuPausedNodes.removeAll()

        // pause dog animation
        if dogState != .dead {
            dog.isPaused = true
            menuPausedNodes.append(dog)
        }

        // pause moving obstacles
        for node in children where node.name == "log" || node.name == "bone" {
            node.isPaused = true
            menuPausedNodes.append(node)
        }

        // stop spawners (will be restarted on resume if running)
        removeAction(forKey: "obstacleSpawner")
        removeAction(forKey: "boneSpawner")
    }

    private func resumeFromMenu() {
        // resume paused nodes
        for n in menuPausedNodes { n.isPaused = false }
        menuPausedNodes.removeAll()

        // if we were running, restart spawners
        if dogState == .running {
            if action(forKey: "obstacleSpawner") == nil { startObstacleSpawner() }
            if action(forKey: "boneSpawner") == nil { startBoneSpawner() }
        }
    }

    private func showMenuOverlay() {
        guard !inMenu else { return }
        inMenu = true
        pauseForMenu()

        let overlay = SKSpriteNode(color: .white, size: size)
        overlay.name = "menuBG"
        overlay.position = CGPoint(x: size.width/2, y: size.height/2)
        overlay.zPosition = 200
        addChild(overlay)
        menuOverlay = overlay

        let items = ["resume","rules","credits","exit"]
        for (i, base) in items.enumerated() {
            let tex = SKTexture(imageNamed: "\(base)-button")
            tex.filteringMode = .nearest
            let btn = SKSpriteNode(texture: tex)
            btn.name = "\(base)Button"
            btn.setScale(2.6)
            btn.position = CGPoint(x: 0, y: CGFloat(90 - i*70))
            btn.zPosition = 210
            overlay.addChild(btn)
        }
    }


    private func showRulesScreen() {
        guard let overlay = menuOverlay else { return }
        overlay.removeAllChildren()

        let imgTexture = SKTexture(imageNamed: "menu-rules")
        imgTexture.filteringMode = .nearest
        let img = SKSpriteNode(texture: imgTexture)
        img.setScale(2.4)
        img.position = .zero
        img.zPosition = 210
        overlay.addChild(img)

        let backTex = SKTexture(imageNamed: "back-button")
        backTex.filteringMode = .nearest
        let back = SKSpriteNode(texture: backTex)
        back.name = "backFromRules"
        back.setScale(2.4)
        back.position = CGPoint(x: -size.width*0.38, y: size.height*0.33)
        back.zPosition = 220
        overlay.addChild(back)
    }
    
    private func showCreditsScreen() {
        guard let overlay = menuOverlay else { return }
        overlay.removeAllChildren()

        // 🖼️ Credits background
        let imgTexture = SKTexture(imageNamed: "menu-credits")
        imgTexture.filteringMode = .nearest
        let img = SKSpriteNode(texture: imgTexture)
        img.setScale(2.4) // match rules scale
        img.position = .zero
        img.zPosition = 210
        overlay.addChild(img)

        // 🔙 Back button (same position as rules)
        let backTex = SKTexture(imageNamed: "back-button")
        backTex.filteringMode = .nearest
        let back = SKSpriteNode(texture: backTex)
        back.name = "backFromCredits"
        back.setScale(2.4)
        back.position = CGPoint(x: -size.width * 0.38, y: size.height * 0.33)
        back.zPosition = 220
        overlay.addChild(back)

        // 🐶 sitting dog animation at bottom center
        let sitSheet = SKTexture(imageNamed: "dog-sit-sprite")
        sitSheet.filteringMode = .nearest

        // ✅ FIXED: precise and slightly inset cropping
        var sitFrames: [SKTexture] = []
        let sitFrameCount = 9 // adjust if different
        _ = sitSheet.size().width
        let inset: CGFloat = 0.002 // small inset to avoid bleeding

        for i in 0..<sitFrameCount {
            let xStart = (1.0 / CGFloat(sitFrameCount)) * CGFloat(i) + inset
            let frameWidth = (1.0 / CGFloat(sitFrameCount)) - (inset * 2)
            let rect = CGRect(x: xStart, y: 0, width: frameWidth, height: 1.0)
            sitFrames.append(SKTexture(rect: rect, in: sitSheet))
        }

        let sitDog = SKSpriteNode(texture: sitFrames.first)
        sitDog.setScale(3)
        sitDog.position = CGPoint(x: 0, y: -size.height * 0.33)
        sitDog.zPosition = 220
        overlay.addChild(sitDog)

        // smooth loop
        let sitAnim = SKAction.animate(with: sitFrames, timePerFrame: 0.09)
        sitDog.run(.repeatForever(sitAnim))

    }

    
    // Reapply crisp texture filtering for the menu button after resuming
    private func refreshMenuButtonTexture() {
        guard let mb = menuButton else { return }
        let normalTex = SKTexture(imageNamed: "menu-button")
        normalTex.filteringMode = .nearest
        mb.texture = normalTex
        mb.setScale(2.4)
        mb.zPosition = 30
    }

    private func closeMenuOverlay() {
        menuOverlay?.removeFromParent()
        menuOverlay = nil
        inMenu = false
        resumeFromMenu()
        refreshMenuButtonTexture() // 🟢 keep menu button crisp when we return
    }

    private func reopenMainMenuOverlay() {
        // destroy any current overlay (rules/credits) and rebuild main menu instantly
        menuOverlay?.removeFromParent()
        inMenu = false
        showMenuOverlay()
    }

    // MARK: - Input Handling
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)

        // 🟡 Check if "Game Over" buttons exist (YES/NO)
        if let yesButton = childNode(withName: "yesButton") as? SKSpriteNode,
           let noButton = childNode(withName: "noButton") as? SKSpriteNode {

            let yellowYes = SKTexture(imageNamed: "yellow-yes")
            let yellowNo = SKTexture(imageNamed: "yellow-no")
            yellowYes.filteringMode = .nearest
            yellowNo.filteringMode = .nearest

            // tighter hitboxes (reduce overlap)
            let yesFrame = yesButton.calculateAccumulatedFrame().insetBy(dx: 20, dy: 15)
            let noFrame = noButton.calculateAccumulatedFrame().insetBy(dx: 20, dy: 15)

            // ✅ handle NO first to prevent overlapping tap zones
            if noFrame.contains(location) {
                noButton.texture = yellowNo
                run(SKAction.wait(forDuration: 0.25)) { [weak self] in
                    guard let self = self, let view = self.view else { return }
                    let newScene = GameScene(size: self.size)
                    newScene.scaleMode = self.scaleMode
                    view.presentScene(newScene, transition: .fade(withDuration: 1.0))
                }
                return
            }

            // ✅ handle YES separately
            if yesFrame.contains(location) {
                yesButton.texture = yellowYes
                run(SKAction.wait(forDuration: 0.25)) { [weak self] in
                    guard let self = self else { return }
                    self.resetGameState()
                    let newScene = GameScene(size: self.size, isRestarting: true)
                    newScene.scaleMode = self.scaleMode
                    self.view?.presentScene(newScene, transition: .fade(withDuration: 0.6))
                }
                return
            }
        }


        // 🟢 MENU BUTTON (always visible until death)
        if let mb = menuButton, mb.contains(location), dogState != .dead {
            // show clicked texture clearly before menu opens
            let clickedTex = SKTexture(imageNamed: "menu-button-clicked")
            clickedTex.filteringMode = .nearest
            mb.texture = clickedTex

            // short wait so we actually see it
            let wait = SKAction.wait(forDuration: 0.15)
            let openMenu = SKAction.run { [weak self] in
                self?.showMenuOverlay()
                // restore crisp normal texture after menu opens
                let normalTex = SKTexture(imageNamed: "menu-button")
                normalTex.filteringMode = .nearest
                mb.texture = normalTex
                mb.setScale(2.2)
            }
            mb.run(.sequence([wait, openMenu]))
            return
        }

        // If inside menu overlay, route taps to menu items and return
        if inMenu, let overlay = menuOverlay {
            let localPoint = convert(location, to: overlay)
            for node in overlay.children {
                guard let s = node as? SKSpriteNode,
                      isPointInsideTightHitbox(node: s, point: localPoint) else { continue }

                switch s.name {
                case "resumeButton":
                    let clicked = SKTexture(imageNamed: "resume-button-clicked")
                    clicked.filteringMode = .nearest
                    s.texture = clicked
                    s.run(.sequence([
                        .wait(forDuration: 0.12),
                        .run { [weak self] in self?.closeMenuOverlay() }
                    ]))
                case "rulesButton":
                    let clicked = SKTexture(imageNamed: "rules-button-clicked")
                    clicked.filteringMode = .nearest
                    s.texture = clicked
                    s.run(.sequence([
                        .wait(forDuration: 0.12),
                        .run { [weak self] in self?.showRulesScreen() }
                    ]))
                case "creditsButton":
                    let clicked = SKTexture(imageNamed: "credits-button-clicked")
                    clicked.filteringMode = .nearest
                    s.texture = clicked
                    s.run(.sequence([
                        .wait(forDuration: 0.12),
                        .run { [weak self] in self?.showCreditsScreen() }
                    ]))
                case "exitButton":
                    let clicked = SKTexture(imageNamed: "exit-button-clicked")
                    clicked.filteringMode = .nearest
                    s.texture = clicked
                    s.run(.sequence([
                        .wait(forDuration: 0.12),
                        .run { [weak self] in
                            guard let self = self, let view = self.view else { return }
                            let newScene = GameScene(size: self.size)
                            newScene.scaleMode = self.scaleMode
                            view.presentScene(newScene, transition: .fade(withDuration: 0.6))
                        }
                    ]))
                case "backFromRules":
                    let clicked = SKTexture(imageNamed: "back-button-clicked")
                    clicked.filteringMode = .nearest
                    s.texture = clicked
                    s.run(.sequence([
                        .wait(forDuration: 0.12),
                        .run { [weak self] in self?.reopenMainMenuOverlay() }
                    ]))
                case "backFromCredits":
                    let clicked = SKTexture(imageNamed: "back-button-clicked")
                    clicked.filteringMode = .nearest
                    s.texture = clicked
                    s.run(.sequence([
                        .wait(forDuration: 0.12),
                        .run { [weak self] in self?.reopenMainMenuOverlay() }
                    ]))
                default:
                    break
                }
                return
            }
            return
        }
        
        
        // 🐶 Ignore taps before game actually starts
        guard gameStarted else { return }
        // 🐶 Regular tap behavior (for gameplay)
        switch dogState {
        case .idle:
            startRunning()
        case .running:
            startJump()
        default:
            break
        }
    }
    
    // 🧼 Reset the game state completely before restarting
    private func resetGameState() {
        // Reset dog and scene-related flags
        dogState = .idle
        currentHealth = 5
        gameStarted = false

        // Remove everything currently on screen
        removeAllChildren()
        removeAllActions()
    }


    #if os(macOS)
    override func keyDown(with event: NSEvent) {
        if event.keyCode == 49 {
            touchesBegan([], with: nil)
        }
    }
    #endif

    // MARK: - UI
    private func addHealthDisplay() {
        let heartTexture = SKTexture(imageNamed: "heart")
        heartTexture.filteringMode = .nearest
        let healthLabelTexture = SKTexture(imageNamed: "health_label")
        healthLabelTexture.filteringMode = .nearest

        // "HEALTH" text
        let label = SKSpriteNode(texture: healthLabelTexture)
        label.setScale(2.5)
        label.anchorPoint = CGPoint(x: 0.4, y: 0.55)
        let roadY = size.height * 0.25
        label.position = CGPoint(x: size.width * 0.1, y: roadY - 35)
        label.zPosition = 10
        addChild(label)

        // Reset health array
        healthHearts.removeAll()
        currentHealth = 5

        // ❤️ Create 5 hearts for full health
        let heartSpacing: CGFloat = 35
        for i in 0..<5 {
            let heart = SKSpriteNode(texture: heartTexture)
            heart.setScale(1.2)
            heart.anchorPoint = CGPoint(x: -0.15, y: 0.55)
            heart.position = CGPoint(
                x: label.position.x + 45 + CGFloat(i) * heartSpacing,
                y: label.position.y
            )
            
            // 👇 Visible by default unless restarting
            heart.alpha = isRestarting ? 0 : 1
            heart.zPosition = 10
            addChild(heart)
            healthHearts.append(heart)

            // ✨ Only blink hearts if this is a restart
            if isRestarting {
                let wait = SKAction.wait(forDuration: Double(i) * 0.25)
                let fadeIn = SKAction.fadeAlpha(to: 1, duration: 0.15)
                let fadeOut = SKAction.fadeAlpha(to: 0.6, duration: 0.15)
                let fadeInFinal = SKAction.fadeAlpha(to: 1, duration: 0.15)
                let blinkSequence = SKAction.sequence([wait, fadeIn, fadeOut, fadeInFinal])
                heart.run(blinkSequence)
            }
        }
        isRestarting = false

    }
    private func addDistanceDisplay() {
        let distanceTexture = SKTexture(imageNamed: "distance_label")
        distanceTexture.filteringMode = .nearest

        // 🏁 "DISTANCE" image on bottom right
        let labelNode = SKSpriteNode(texture: distanceTexture)
        labelNode.setScale(2.51)
        labelNode.anchorPoint = CGPoint(x: 1.2, y: 0.667)  // right-aligned anchor
        labelNode.position = CGPoint(x: size.width * 0.90, y: size.height * 0.198)
        labelNode.zPosition = 10
        addChild(labelNode)
        distanceLabelNode = labelNode

        // Numeric label to the left of the text
        let valueLabel = SKLabelNode(fontNamed: "Courier-Bold")
        valueLabel.fontSize = 18
        valueLabel.fontColor = .black
        valueLabel.horizontalAlignmentMode = .right
        valueLabel.verticalAlignmentMode = .center
        valueLabel.position = CGPoint(x: labelNode.position.x + 30, y: labelNode.position.y - 16.45)
        valueLabel.text = "0"
        valueLabel.zPosition = 10
        addChild(valueLabel)
        distanceValueLabel = valueLabel

        distanceTraveled = 0
    }

    
    private func addTapToStartLabel() {
        // Load texture
        let tapTexture = SKTexture(imageNamed: "tap-to-start-title")
        tapTexture.filteringMode = .nearest

        // Create label node
        let label = SKSpriteNode(texture: tapTexture)
        label.setScale(2.5)
        label.position = CGPoint(x: size.width / 2, y: size.height * 0.65)
        label.alpha = 1.0
        label.zPosition = 20
        addChild(label)
        tapToStartLabel = label
    }

    
    private func addRoad() {
        let road = SKSpriteNode(color: .black, size: CGSize(width: size.width, height: 15))
        road.position = CGPoint(x: size.width / 2, y: size.height * 0.25)
        addChild(road)
    }

    private func addSky() {
        let roadY = size.height * 0.25
        let skyHeight = size.height - roadY
        let sky = SKSpriteNode(
            color: SKColor(red: 0.53, green: 0.81, blue: 0.98, alpha: 1.0),
            size: CGSize(width: size.width, height: skyHeight)
        )
        sky.anchorPoint = CGPoint(x: 0.5, y: 0.0)
        sky.position = CGPoint(x: size.width / 2, y: roadY)
        sky.zPosition = -10
        addChild(sky)
    }

    private func addClouds() {
        let cloudTextures = [
            SKTexture(imageNamed: "cloud1"),
            SKTexture(imageNamed: "cloud2"),
            SKTexture(imageNamed: "cloud3")
        ]
        for texture in cloudTextures { texture.filteringMode = .nearest }

        let initialCount = Int.random(in: 3...5)
        for _ in 0..<initialCount {
            spawnCloud(using: cloudTextures, startOnScreen: true)
        }

        let spawnAction = SKAction.run { [weak self] in
            self?.spawnCloud(using: cloudTextures, startOnScreen: false)
        }
        let wait = SKAction.wait(forDuration: 5, withRange: 3)
        run(SKAction.repeatForever(SKAction.sequence([wait, spawnAction])))
    }

    private func spawnCloud(using cloudTextures: [SKTexture], startOnScreen: Bool) {
        let type = Int.random(in: 0..<cloudTextures.count)
        let texture = cloudTextures[type]
        let cloud = SKSpriteNode(texture: texture)
        cloud.alpha = 0.9
        cloud.zPosition = -5 - CGFloat(type)
        cloud.setScale(1.8 + CGFloat(type) * 0.5)

        let roadY = size.height * 0.25
        let skyTop = size.height
        let minY = roadY + (skyTop - roadY) * 0.65
        let maxY = roadY + (skyTop - roadY) * 0.9
        let startY = CGFloat.random(in: minY...maxY)
        let startX = startOnScreen ? CGFloat.random(in: 0...size.width)
                                   : size.width + cloud.size.width + CGFloat.random(in: 20...150)

        cloud.position = CGPoint(x: startX, y: startY)
        addChild(cloud)

        let duration = Double.random(in: 40...60)
        let moveLeft = SKAction.moveBy(x: -size.width - cloud.size.width * 2, y: 0, duration: duration)
        cloud.run(SKAction.sequence([moveLeft, .removeFromParent()]))

        let up = SKAction.moveBy(x: 0, y: 4, duration: 2)
        cloud.run(SKAction.repeatForever(SKAction.sequence([up, up.reversed()])))
    }

    // MARK: - Physics Contact
    func didBegin(_ contact: SKPhysicsContact) {
        // Figure out which body is the dog and which is the other object
        let otherBody: SKPhysicsBody
        if contact.bodyA.categoryBitMask == 1 {
            otherBody = contact.bodyB
        } else if contact.bodyB.categoryBitMask == 1 {
            otherBody = contact.bodyA
        } else {
            return
        }

        // 🪵 Collision with wooden log
        if otherBody.categoryBitMask == 2 {
            startHurt()
            otherBody.node?.removeFromParent()
        }

        // 🦴 Collision with bone
        else if otherBody.categoryBitMask == 4 {
            if let node = otherBody.node {
                handleBoneCollected(node)
            }
        }
    }
    override func update(_ currentTime: TimeInterval) {
        guard dogState == .running else { return }
        distanceTraveled += 0.15   // tweak this for speed/distance feel
        distanceValueLabel?.text = String(format: "%.0f", distanceTraveled)
    }

}
// MARK: - Precise hit detection for pixel-art buttons
private func isPointInsideTightHitbox(node: SKSpriteNode, point: CGPoint) -> Bool {
    // Use the node’s calculated frame (ignores transparent pixels)
    let frame = node.calculateAccumulatedFrame()
    
    // Shrink slightly so empty edges don’t count as "inside"
    let insetFrame = frame.insetBy(dx: node.size.width * 0.3,
                                   dy: node.size.height * 0.3)
    
    return insetFrame.contains(point)
}
