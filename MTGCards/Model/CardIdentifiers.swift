//
//  CardIdentifiers.swift
//  MTGCards
//
//  Created by Joseph Smith on 6/17/20.
//  Copyright © 2020 Robotic Snail Software. All rights reserved.
//

import Foundation

class CardIdentifiers: Codable {
    let cardKingdomFoilID: String?
    let cardKingdomID: String?
    let mcmID: String?
    let mcmMetaID: String?
    let mtgArenaID: String?
    let mtgoFoilID: String?
    let mtgoID: String?
    let multiverseID: String?
    let scryfallID: String?
    let scryfallIllustrationID: String?
    let scryfallOracleID: String?
    let tcgplayerProductID: String?

    enum CodingKeys: String, CodingKey {
        case cardKingdomFoilID = "cardKingdomFoilId"
        case cardKingdomID = "cardKingdomId"
        case mcmID = "mcmId"
        case mcmMetaID = "mcmMetaId"
        case mtgArenaID = "mtgArenaId"
        case mtgoFoilID = "mtgoFoilId"
        case mtgoID = "mtgoId"
        case multiverseID = "multiverseId"
        case scryfallID = "scryfallId"
        case scryfallIllustrationID = "scryfallIllustrationId"
        case scryfallOracleID = "scryfallOracleId"
        case tcgplayerProductID = "tcgplayerProductId"
    }

    init(cardKingdomFoilID: String?, cardKingdomID: String?, mcmID: String?, mcmMetaID: String?, mtgArenaID: String?, mtgoFoilID: String?, mtgoID: String?, multiverseID: String?, scryfallID: String?, scryfallIllustrationID: String?, scryfallOracleID: String?, tcgplayerProductID: String?) {
        self.cardKingdomFoilID = cardKingdomFoilID
        self.cardKingdomID = cardKingdomID
        self.mcmID = mcmID
        self.mcmMetaID = mcmMetaID
        self.mtgArenaID = mtgArenaID
        self.mtgoFoilID = mtgoFoilID
        self.mtgoID = mtgoID
        self.multiverseID = multiverseID
        self.scryfallID = scryfallID
        self.scryfallIllustrationID = scryfallIllustrationID
        self.scryfallOracleID = scryfallOracleID
        self.tcgplayerProductID = tcgplayerProductID
    }
}

// MARK: CardIdentifiers convenience initializers and mutators

extension CardIdentifiers {
    convenience init(data: Data) throws {
        let me = try newJSONDecoder().decode(CardIdentifiers.self, from: data)
        self.init(cardKingdomFoilID: me.cardKingdomFoilID, cardKingdomID: me.cardKingdomID, mcmID: me.mcmID, mcmMetaID: me.mcmMetaID, mtgArenaID: me.mtgArenaID, mtgoFoilID: me.mtgoFoilID, mtgoID: me.mtgoID, multiverseID: me.multiverseID, scryfallID: me.scryfallID, scryfallIllustrationID: me.scryfallIllustrationID, scryfallOracleID: me.scryfallOracleID, tcgplayerProductID: me.tcgplayerProductID)
    }

    convenience init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }

    convenience init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }

    func with(
        cardKingdomFoilID: String?? = nil,
        cardKingdomID: String?? = nil,
        mcmID: String?? = nil,
        mcmMetaID: String?? = nil,
        mtgArenaID: String?? = nil,
        mtgoFoilID: String?? = nil,
        mtgoID: String?? = nil,
        multiverseID: String?? = nil,
        scryfallID: String?? = nil,
        scryfallIllustrationID: String?? = nil,
        scryfallOracleID: String?? = nil,
        tcgplayerProductID: String?? = nil
    ) -> CardIdentifiers {
        return CardIdentifiers(
            cardKingdomFoilID: cardKingdomFoilID ?? self.cardKingdomFoilID,
            cardKingdomID: cardKingdomID ?? self.cardKingdomID,
            mcmID: mcmID ?? self.mcmID,
            mcmMetaID: mcmMetaID ?? self.mcmMetaID,
            mtgArenaID: mtgArenaID ?? self.mtgArenaID,
            mtgoFoilID: mtgoFoilID ?? self.mtgoFoilID,
            mtgoID: mtgoID ?? self.mtgoID,
            multiverseID: multiverseID ?? self.multiverseID,
            scryfallID: scryfallID ?? self.scryfallID,
            scryfallIllustrationID: scryfallIllustrationID ?? self.scryfallIllustrationID,
            scryfallOracleID: scryfallOracleID ?? self.scryfallOracleID,
            tcgplayerProductID: tcgplayerProductID ?? self.tcgplayerProductID
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}
