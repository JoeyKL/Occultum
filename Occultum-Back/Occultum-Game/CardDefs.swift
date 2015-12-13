//
//  CardDefs.swift
//  Occultum-Server
//
//  Created by Joey on 10/12/15.
//  Copyright © 2015 JoeyKL. All rights reserved.
//

import Foundation

var cultist = CardTemplate(
    name: "Cultist",
    cost: 1,
    type: .Follower,
    effect: {
        $0.money+=1
        $0.actions+=1
    }
)

var highCultist = CardTemplate(
    name: "High Cultist",
    cost: 3,
    type: .Follower,
    effect: {
        $0.money+=2
        $0.actions+=1
    }
)

var archCultist = CardTemplate(
    name: "Arch Cultist",
    cost: 6,
    type: .Follower,
    effect: {
        $0.money+=3
        $0.actions+=1
    }
)

var tourmentedArtist = CardTemplate(
    name: "Tourmented Artist",
    cost: 3,
    type: .Follower,
    effect: {
        $0.draw(1)
        $0.actions+=2
    }
)

var frenzy = CardTemplate(
    name: "Frenzy",
    cost: 4,
    type: .Incantation,
    effect: {
        $0.draw(3)
        $0.addToSupplyRow(3)
    }
)