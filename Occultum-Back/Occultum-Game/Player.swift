//
//  Player.swift
//  Occultum-Server
//
//  Created by Joey on 7/12/15.
//  Copyright © 2015 JoeyKL. All rights reserved.
//

import Foundation

func dump<T>(inout from: [T], inout into: [T]) {
    into += from
    from.removeAll()
}

extension MutableCollectionType where Index == Int {
    /// Shuffle the elements of `self` in-place.
    mutating func shuffle() {
        // empty and single-element collections don't shuffle
        if count < 2 { return }
        
        for i in 0..<count - 1 {
            let j = Int(arc4random_uniform(UInt32(count - i))) + i
            guard i != j else { continue }
            swap(&self[i], &self[j])
        }
    }
}


class Player {
    private var supplyDeck = [Card]()
    private var supplyRow = [Card]()
    private let maxSupplyRowLength = 7
    
    private var drawDeck = [Card]()
    
    private var inPlay = [Card]()
    
    private var discard = [Card]()
    
    private var hand = [Card]()
    
    let opponnent: Player!
    
    enum Status {
        case MyTurn
        case OpponentsTurn
        case Choosing(options: Set<Int>, quantity: Int, callback: (Player, choice: Set<Int>)->() )
    }
    
    var status = Status.OpponentsTurn
    
    var doom = 0
    var actions = 0
    var money = 0
    
    static func makePlayers() -> (Player, Player) {
        let playerOne = Player(isFirstPlayer: true)
        let playerTwo = playerOne.opponnent
        
        playerOne.beginGame()
        playerTwo.beginGame()
        
        return (playerOne, playerTwo)
    }
    
    private init(isFirstPlayer: Bool) {
        if isFirstPlayer {
            opponnent = Player(isFirstPlayer: false)
            opponnent.opponnent = self
        }
        else {
            opponnent  = nil
        }
    }
    
    func beginGame() {
        drawDeck = [Card](count: 10, repeatedValue: Card(template: cultist))
        drawDeck.shuffle()
        draw(5)

        supplyDeck = [Card](count: 20, repeatedValue: Card(template: highCultist))
        supplyDeck.shuffle()
        addToSupplyRow(7)
    }
    
    func makeMove(move: Move) throws {
        switch status {
        case .MyTurn:
            switch move {
            case .BuyCard(let index):
                guard actions > 0 else {throw MoveError.InsufficientActions}
                guard supplyRow.count > index else {throw MoveError.CardNotFound}
                
                let card = supplyRow[index]
                
                guard money >= card.cost else {throw MoveError.InsufficientMoney}

                supplyRow.removeAtIndex(index)
                
                actions -= 1
                money -= card.cost
                
                switch(card.type) {
                case .Follower:
                    discard.append(card)
                case .Incantation:
                    activate(card)
                }
                
            case .PlayFollower(let index):
                guard actions > 0 else {throw MoveError.InsufficientActions}
                guard hand.count > index else {throw MoveError.CardNotFound}
                
                actions -= 1
                let follower = hand.removeAtIndex(index)
                inPlay.append(follower)
                activate(follower)
                
            case .EndTurn:
                endTurn()
                
            case .Choose(_):
                throw MoveError.WrongPlayerStatus
            }
            
        case .OpponentsTurn:
            throw MoveError.WrongPlayerStatus
        
        case let .Choosing(options, quantity, callback):
            if case let .Choose(choice) = move {
                guard choice.isSubsetOf(options) else {throw MoveError.InvalidChoice}
                guard choice.count == quantity else {throw MoveError.InvalidChoice}
                
                callback(self, choice: choice)
            }
            else {
                throw MoveError.WrongPlayerStatus
            }
        }
    }
    
    func printStatus() {
        print("You have \(actions) actions.")
        print("You have \(money) money.")
        
        print("Your hand contains:", terminator: " ")
        for card in hand {
            print(card.name, terminator: ", ")
        }
        print("")
        
        print("Your supply row contains:", terminator: " ")
        for card in supplyRow {
            print(card.name, terminator: ", ")
        }
        print("")
    }
    
    func startTurn() {
        print("Your turn has begun.")
        
        status = Status.MyTurn
        actions = 2
        
        printStatus()
    }
    
    func endTurn() {
        print("Your turn has ended.")
        dump(&inPlay, into: &discard)
        dump(&hand, into: &discard)
        
        draw(5)
        addToSupplyRow(1)
        
        money = 0
        
        status = Status.OpponentsTurn
        
        opponnent.startTurn()
    }
    
    private func choose(options: Set<Int>, quantity: Int, _ callback: (Player, choice: Set<Int>) -> ()) {
        status = Status.Choosing(options: options, quantity: quantity, callback: callback)
    }
    
    func chooseFromSupplyRow(callback: (Player, choice: Set<Int>) -> ()) {
        status = Status.Choosing(options: Set<Int>(supplyRow.indices), quantity: 1, callback: callback )
    }
    
    func activate(card: Card) {
        card.effect(self)
    }
    
    func draw(quantity: Int) {
        draw(quantity, into: &hand)
    }
    
    func draw(quantity: Int, inout into destination: [Card]) {
        for _ in 0..<quantity {
            if drawDeck.count == 0 {
                shuffleDiscard()
            }
            destination.append(drawDeck.removeLast())
        }
    }
    
    func addToSupplyRow(quantity: Int) {
        for _ in 0..<quantity {
            supplyRow.append(supplyDeck.removeLast())
            if supplyRow.count > maxSupplyRowLength {
                supplyRow.removeFirst(supplyRow.count - maxSupplyRowLength)
            }
        }
    }
    
    func shuffleDiscard() {
        dump(&discard, into: &drawDeck)
        drawDeck.shuffle()
    }
}
