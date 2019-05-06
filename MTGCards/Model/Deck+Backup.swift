//
//  Deck+Backup.swift
//  MTGCards
//
//  Created by Joseph Smith on 5/1/19.
//  Copyright © 2019 Robotic Snail Software. All rights reserved.
//

import Foundation

extension Deck {
    func getDeckBackup() -> DeckBackup {
        var cardBackups: [CardBackup] = []
        for card in (self.cards?.allObjects as? [DeckCard] ?? []) {
            cardBackups.append(CardBackup(uuid: card.card?.uuid ?? "", quantity: Int(card.quantity), isCommander: card.isCommander, isSideboard: card.isSideboard))
        }
        return DeckBackup(name: self.name ?? "", format: self.format ?? "" , cardBackups: cardBackups)
    }
}

