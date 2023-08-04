//
//  BitMaskCategory.swift
//  FlappyBird
//
//  Created by Roman Lantsov on 04.08.2023.
//

import SpriteKit

extension SKPhysicsBody {
    var category: BitMaskCategory {
        get {
            return BitMaskCategory(rawValue: self.categoryBitMask)
        }
        
        set {
            self.categoryBitMask = newValue.rawValue
        }
    }
}

struct BitMaskCategory: OptionSet {
    let rawValue: UInt32
    
    static let none = BitMaskCategory(rawValue: 0 << 0)
    static let player = BitMaskCategory(rawValue: 1 << 0)
    static let pipe = BitMaskCategory(rawValue: 1 << 1)
    static let base = BitMaskCategory(rawValue: 1 << 2)
    static let all = BitMaskCategory(rawValue: UInt32.max)
}
