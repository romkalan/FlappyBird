//
//  GameScene.swift
//  FlappyBird
//
//  Created by Roman Lantsov on 02.08.2023.
//

import SpriteKit
import GameplayKit

enum GameStatus {
    case idle // инициализация
    case running // запуск
    case over // окончание
}

class GameScene: SKScene {
    
    var gameStatus: GameStatus = .idle
    
    var base1: SKSpriteNode!
    var base2: SKSpriteNode!
    var player: SKSpriteNode!
    
    override func didMove(to view: SKView) {
        self.backgroundColor = SKColor(red: 80/255, green: 192/255, blue: 203/255, alpha: 1.0)
        addBase()
        addPlayer()
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        if gameStatus != .over {
            moveScene()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        switch gameStatus {
        case .idle:
            startGame()
        case .running:
            print("лети моя птичка, лети-и-и-и")
        case .over:
            shuffle()
        }
    }
    
    private func addBase() {
        base1 = SKSpriteNode(imageNamed: "base")
        base1.anchorPoint = CGPoint(x: 0, y: 0)
        base1.setScale(1.2)
        base1.position = CGPoint(x: 0, y: 0)
        addChild(base1)
        
        base2 = SKSpriteNode(imageNamed: "base")
        base2.anchorPoint = CGPoint(x: 0, y: 0)
        base2.setScale(1.2)
//        base2.xScale
        base2.position = CGPoint(x: base1.size.width, y: 0)
        addChild(base2)
    }
    
    // Player's methods
    private func addPlayer() {
        player = SKSpriteNode(imageNamed: "redbird-midflap")
        player.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
        addChild(player)
    }
    
    private func birdStartFly() {
        let flyAction = SKAction.animate(
            with: [
                SKTexture(imageNamed: "redbird-midflap"),
                SKTexture(imageNamed: "redbird-downflap"),
                SKTexture(imageNamed: "redbird-midflap"),
                SKTexture(imageNamed: "redbird-upflap"),
            ],
            timePerFrame: 0.15
        )
        player.run(SKAction.repeatForever(flyAction), withKey: "fly")
    }
    
    private func birdStopFly() {
        player.removeAction(forKey: "fly")
    }
    
    //Pipes methods
    private func removeAllPipesNode() {
//        for pipe in self.children where pipe.name == "pipe" {
//            pipe.removeFromParent()
//        }
        enumerateChildNodes(withName: "pipe") { (node, stop) in
            node.removeFromParent()
        }
    }
    
    private func stopCreateRandomPipes() {
        self.removeAction(forKey: "createPipes")
    }
    
    private func generateRandomPipes() {
        let waitAction = SKAction.wait(forDuration: 3.5, withRange: 1.0)
        let generatePipeAction = SKAction.run { [unowned self] in
            self.createRandomPipes()
        }
        
        let sequence = SKAction.sequence([waitAction, generatePipeAction])
        
        run(SKAction.repeatForever(sequence), withKey: "createPipes")
    }
    
    private func createRandomPipes() {
        let height = self.size.height - self.base1.size.height
        let pipeGap = CGFloat(arc4random_uniform(UInt32(player.size.height))) + player.size.height * 2.5
        
        let pipeWidth = CGFloat(60.0)
        let topPipeHeight = CGFloat(arc4random_uniform(UInt32(height - pipeGap)))
        let bottomPipeHeight = height - pipeGap - topPipeHeight
        
        addPipes(
            topSize: CGSize(width: pipeWidth, height: topPipeHeight),
            bottomSize: CGSize(width: pipeWidth, height: bottomPipeHeight)
        )
    }
    
    private func addPipes(topSize: CGSize, bottomSize: CGSize) {
        let topPipeTexture = SKTexture(imageNamed: "pipe-green")
        let topPipe = SKSpriteNode(texture: topPipeTexture, size: topSize)
        topPipe.name = "pipe"
        topPipe.position = CGPoint(
            x: self.size.width + topPipe.size.width * 0.5,
            y: base1.size.height + topPipe.size.height * 0.5
        )
        addChild(topPipe)
        
        let bottomPipeTexture = SKTexture(imageNamed: "pipe-green")
        let bottomPipe = SKSpriteNode(texture: bottomPipeTexture, size: bottomSize)
        bottomPipe.yScale = -1
        bottomPipe.name = "pipe"
        bottomPipe.position = CGPoint(
            x: self.size.width + bottomPipe.size.width * 0.5,
            y: self.size.height - bottomPipe.size.height * 0.5
        )
        addChild(bottomPipe)
    }
    
    //Movement method
    private func moveScene() {
        if base1.position.x < -base1.size.width {
            base1.position = CGPoint(x: base2.position.x + base1.size.width, y: base1.position.y)
        }
        if base2.position.x < -base2.size.width {
            base2.position = CGPoint(x: base1.position.x + base2.size.width, y: base2.position.y)
        }
        
        base1.position = CGPoint(x: base1.position.x - 1, y: base1.position.y)
        base2.position = CGPoint(x: base2.position.x - 1, y: base2.position.y)
        
        
        for pipeNode in self.children where pipeNode.name == "pipe" {
            guard let pipeSprite = pipeNode as? SKSpriteNode else { return }
            pipeSprite.position = CGPoint(
                x: pipeSprite.position.x - 1,
                y: pipeSprite.position.y
            )
            if pipeSprite.position.x < -pipeSprite.size.width * 0.5 {
                pipeSprite.removeFromParent()
            }
        }
        
    }
    
    // GameStatus methods
    private func shuffle() {
        gameStatus = .idle
        removeAllPipesNode()
    }
    
    private func startGame() {
        gameStatus = .running
        birdStartFly()
        generateRandomPipes()
    }
    
    private func gameOver() {
        gameStatus = .over
        birdStopFly()
        stopCreateRandomPipes()
    }
}
