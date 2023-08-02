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

    }
    
    private func addBase() {
        base1 = SKSpriteNode(imageNamed: "base")
        base1.anchorPoint = CGPoint(x: 0, y: 0)
        base1.position = CGPoint(x: 0, y: 0)
        addChild(base1)
        
        base2 = SKSpriteNode(imageNamed: "base")
        base2.anchorPoint = CGPoint(x: 0, y: 0)
        base2.position = CGPoint(x: base1.size.width, y: 0)
        addChild(base2)
    }
    
    private func addPlayer() {
        player = SKSpriteNode(imageNamed: "redbird-midflap")
        player.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
        addChild(player)
    }
    
    // GameStatus methods
    private func shuffle() {
        gameStatus = .idle
    }
    
    private func startGame() {
        gameStatus = .running
    }
    
    private func gameOver() {
        gameStatus = .over
    }
}
