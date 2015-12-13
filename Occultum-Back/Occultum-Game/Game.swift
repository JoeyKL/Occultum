//
//  Game.swift
//  Occultum-Server
//
//  Created by Joey on 7/12/15.
//  Copyright © 2015 JoeyKL. All rights reserved.
//

import Foundation

class Game {
    let playerOne: Player
    let playerTwo: Player
    
    init() {
        (playerOne, playerTwo) = Player.makePlayers()
        
        print("The game has begun! May the best Elder God win!")
        
        playerOne.startTurn()
    }
    
    func makeMove(player: Player, move: Move) {
        do {
            try player.makeMove(move)
        }
        catch MoveError.CardNotFound {
            print("There is not a card at that index")
        }
        catch MoveError.InsufficientActions {
            print("I don't have enough actions")
        }
        catch MoveError.InsufficientMoney {
            print("I don't have enough money")
        }
        catch MoveError.InvalidChoice {
            print("That's not something you can choose")
        }
        catch MoveError.WrongPlayerStatus {
            print("You can't do that right now")
        }
        catch {
            print("Something has gone very, very wrong")
        }

    }
}
