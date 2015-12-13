//
//  Card.swift
//  Occultum-Server
//
//  Created by Joey on 7/12/15.
//  Copyright © 2015 JoeyKL. All rights reserved.
//

import Foundation

typealias Effect = (Player)->Void

func +<T>(left: (T)->(), right: (T)->()) -> ((T) -> ()) {
    return {left($0); right($0)}
}

class Card {
    let template: CardTemplate
    var buffs: [Buff] = []
    
    enum Buff {
        case AdditionalEffect(effect: Effect)
        case CostChange(amount: Int)
    }
    
    var cost: Int {
        var runningTotal = template.cost
        for buff in buffs {
            if case let .CostChange(amount) = buff {
                runningTotal += amount
            }
        }
        return runningTotal
    }
    
    var effect: Effect {
        var runningTotal = template.effect
        for buff in buffs {
            if case let .AdditionalEffect(effect) = buff {
                runningTotal = runningTotal + effect
            }
        }
        return runningTotal
    }
    
    var type: CardType {
        return template.type
    }
    
    var name: String {
        return template.name
    }
    
    init(template: CardTemplate) {
        self.template = template;
    }
    
}

struct CardTemplate {
    let name: String
    let cost: Int
    let type: CardType
    let effect: Effect
}

enum CardType {
    case Follower, Incantation
}

