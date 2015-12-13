//
//  TextController.swift
//  Occultum-Server
//
//  Created by Joey on 7/12/15.
//  Copyright © 2015 JoeyKL. All rights reserved.
//

import Foundation

func input() -> String {
    let keyboard = NSFileHandle.fileHandleWithStandardInput()
    let inputData = keyboard.availableData
    let strData = NSString(data: inputData, encoding: NSUTF8StringEncoding)!
    
    return strData.stringByTrimmingCharactersInSet(NSCharacterSet.newlineCharacterSet())
}

class TextViewController {
    let game: Game
    
    init(game: Game) {
        self.game = game
    }
    
    func makeMove(commandString: String) {
        let commandWords = commandString.characters.split{$0 == " "}.map(String.init)
        
        let targetPlayer = ((Int(commandWords[0]) == 1) ? game.playerOne : game.playerTwo)
        let command = commandWords[1]
        let parameter: Int?
        
        if commandWords.count >= 3 {
            parameter = Int(commandWords[2])
        } else {
            parameter = nil
        }
        
        switch(command) {
        case "buy":
            game.makeMove(targetPlayer, move: .BuyCard(card: parameter!))
        case "play":
            game.makeMove(targetPlayer, move: .PlayFollower(follower: parameter!))
        case "choose":
            game.makeMove(targetPlayer, move: .Choose(choice: Set<Int>([parameter!])))
        case "endturn":
            game.makeMove(targetPlayer, move: .EndTurn)
        case "status":
            targetPlayer.printStatus()
        default:
            print("lol that didnt fuckin work")
        }
    }
}