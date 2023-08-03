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
    
    private func moveScene() {
        if base1.position.x < -base1.size.width {
            base1.position = CGPoint(x: base2.position.x + base1.size.width, y: base1.position.y)
        }
        if base2.position.x < -base2.size.width {
            base2.position = CGPoint(x: base1.position.x + base2.size.width, y: base2.position.y)
        }
        
        base1.position = CGPoint(x: base1.position.x - 1, y: base1.position.y)
        base2.position = CGPoint(x: base2.position.x - 1, y: base2.position.y)
        
    }
    
    // GameStatus methods
    private func shuffle() {
        gameStatus = .idle
        
    }
    
    private func startGame() {
        gameStatus = .running
        birdStartFly()
    }
    
    private func gameOver() {
        gameStatus = .over
        birdStopFly()
    }
}
