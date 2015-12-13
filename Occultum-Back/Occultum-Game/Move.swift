//
//  Move.swift
//  Occultum-Server
//
//  Created by Joey on 7/12/15.
//  Copyright © 2015 JoeyKL. All rights reserved.
//

import Foundation

enum Move {
    case PlayFollower(follower: Int)
    case BuyCard(card: Int)
    case EndTurn
    case Choose(choice: Set<Int>)
}

enum MoveError: ErrorType {
    case WrongPlayerStatus
    case InsufficientActions
    case InsufficientMoney
    case CardNotFound
    case InvalidChoice
}