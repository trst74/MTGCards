//
//  Card.swift
//  MTGCards
//
//  Created by Joseph Smith on 1/26/19.
//  Copyright © 2019 Robotic Snail Software. All rights reserved.
//

import Foundation

class Card: Codable {
    let artist: String?
    let borderColor: String?
    let colorIdentity: [String]?
    let colors: [String]?
    let convertedManaCost: Int?
    let flavorText: String?
    let foreignData: [ForeignDatum]?
    let frameVersion: String?
    let hasFoil: Bool?
    let hasNonFoil: Bool?
    let layout: String?
    let legalities: Legalities?
    let manaCost: String?
    let multiverseID: Int?
    let name: String?
    let number: String?
    let originalText: String?
    let originalType: String?
    let power: String?
    let printings: [String]?
    let rarity: String?
    let rulings: [Ruling]?
    let scryfallID: String?
    let subtypes: [String]?
    let supertypes: [String]?
    let tcgplayerProductID: Int?
    let tcgplayerPurchaseURL: String?
    let text: String?
    let toughness: String?
    let type: String?
    let types: [String]?
    let uuid: String?
    let watermark: String?
    let names: [String]?
    let loyalty: String?
    let faceConvertedManaCost: Int?
    let side: String?
    let variations: [String]?
    let starter: Bool?
    
    enum CodingKeys: String, CodingKey {
        case artist = "artist"
        case borderColor = "borderColor"
        case colorIdentity = "colorIdentity"
        case colors = "colors"
        case convertedManaCost = "convertedManaCost"
        case flavorText = "flavorText"
        case foreignData = "foreignData"
        case frameVersion = "frameVersion"
        case hasFoil = "hasFoil"
        case hasNonFoil = "hasNonFoil"
        case layout = "layout"
        case legalities = "legalities"
        case manaCost = "manaCost"
        case multiverseID = "multiverseId"
        case name = "name"
        case number = "number"
        case originalText = "originalText"
        case originalType = "originalType"
        case power = "power"
        case printings = "printings"
        case rarity = "rarity"
        case rulings = "rulings"
        case scryfallID = "scryfallId"
        case subtypes = "subtypes"
        case supertypes = "supertypes"
        case tcgplayerProductID = "tcgplayerProductId"
        case tcgplayerPurchaseURL = "tcgplayerPurchaseUrl"
        case text = "text"
        case toughness = "toughness"
        case type = "type"
        case types = "types"
        case uuid = "uuid"
        case watermark = "watermark"
        case names = "names"
        case loyalty = "loyalty"
        case faceConvertedManaCost = "faceConvertedManaCost"
        case side = "side"
        case variations = "variations"
        case starter = "starter"
    }
    
    init(artist: String?, borderColor: String?, colorIdentity: [String]?, colors: [String]?, convertedManaCost: Int?, flavorText: String?, foreignData: [ForeignDatum]?, frameVersion: String?, hasFoil: Bool?, hasNonFoil: Bool?, layout: String?, legalities: Legalities?, manaCost: String?, multiverseID: Int?, name: String?, number: String?, originalText: String?, originalType: String?, power: String?, printings: [String]?, rarity: String?, rulings: [Ruling]?, scryfallID: String?, subtypes: [String]?, supertypes: [String]?, tcgplayerProductID: Int?, tcgplayerPurchaseURL: String?, text: String?, toughness: String?, type: String?, types: [String]?, uuid: String?, watermark: String?, names: [String]?, loyalty: String?, faceConvertedManaCost: Int?, side: String?, variations: [String]?, starter: Bool?) {
        self.artist = artist
        self.borderColor = borderColor
        self.colorIdentity = colorIdentity
        self.colors = colors
        self.convertedManaCost = convertedManaCost
        self.flavorText = flavorText
        self.foreignData = foreignData
        self.frameVersion = frameVersion
        self.hasFoil = hasFoil
        self.hasNonFoil = hasNonFoil
        self.layout = layout
        self.legalities = legalities
        self.manaCost = manaCost
        self.multiverseID = multiverseID
        self.name = name
        self.number = number
        self.originalText = originalText
        self.originalType = originalType
        self.power = power
        self.printings = printings
        self.rarity = rarity
        self.rulings = rulings
        self.scryfallID = scryfallID
        self.subtypes = subtypes
        self.supertypes = supertypes
        self.tcgplayerProductID = tcgplayerProductID
        self.tcgplayerPurchaseURL = tcgplayerPurchaseURL
        self.text = text
        self.toughness = toughness
        self.type = type
        self.types = types
        self.uuid = uuid
        self.watermark = watermark
        self.names = names
        self.loyalty = loyalty
        self.faceConvertedManaCost = faceConvertedManaCost
        self.side = side
        self.variations = variations
        self.starter = starter
    }
}
extension Card {
    convenience init(data: Data) throws {
        let me = try newJSONDecoder().decode(Card.self, from: data)
        self.init(artist: me.artist, borderColor: me.borderColor, colorIdentity: me.colorIdentity, colors: me.colors, convertedManaCost: me.convertedManaCost, flavorText: me.flavorText, foreignData: me.foreignData, frameVersion: me.frameVersion, hasFoil: me.hasFoil, hasNonFoil: me.hasNonFoil, layout: me.layout, legalities: me.legalities, manaCost: me.manaCost, multiverseID: me.multiverseID, name: me.name, number: me.number, originalText: me.originalText, originalType: me.originalType, power: me.power, printings: me.printings, rarity: me.rarity, rulings: me.rulings, scryfallID: me.scryfallID, subtypes: me.subtypes, supertypes: me.supertypes, tcgplayerProductID: me.tcgplayerProductID, tcgplayerPurchaseURL: me.tcgplayerPurchaseURL, text: me.text, toughness: me.toughness, type: me.type, types: me.types, uuid: me.uuid, watermark: me.watermark, names: me.names, loyalty: me.loyalty, faceConvertedManaCost: me.faceConvertedManaCost, side: me.side, variations: me.variations, starter: me.starter)
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
        artist: String?? = nil,
        borderColor: String?? = nil,
        colorIdentity: [String]?? = nil,
        colors: [String]?? = nil,
        convertedManaCost: Int?? = nil,
        flavorText: String?? = nil,
        foreignData: [ForeignDatum]?? = nil,
        frameVersion: String?? = nil,
        hasFoil: Bool?? = nil,
        hasNonFoil: Bool?? = nil,
        layout: String?? = nil,
        legalities: Legalities?? = nil,
        manaCost: String?? = nil,
        multiverseID: Int?? = nil,
        name: String?? = nil,
        number: String?? = nil,
        originalText: String?? = nil,
        originalType: String?? = nil,
        power: String?? = nil,
        printings: [String]?? = nil,
        rarity: String?? = nil,
        rulings: [Ruling]?? = nil,
        scryfallID: String?? = nil,
        subtypes: [String]?? = nil,
        supertypes: [String]?? = nil,
        tcgplayerProductID: Int?? = nil,
        tcgplayerPurchaseURL: String?? = nil,
        text: String?? = nil,
        toughness: String?? = nil,
        type: String?? = nil,
        types: [String]?? = nil,
        uuid: String?? = nil,
        watermark: String?? = nil,
        names: [String]?? = nil,
        loyalty: String?? = nil,
        faceConvertedManaCost: Int?? = nil,
        side: String?? = nil,
        variations: [String]?? = nil,
        starter: Bool?? = nil
        ) -> Card {
        return Card(
            artist: artist ?? self.artist,
            borderColor: borderColor ?? self.borderColor,
            colorIdentity: colorIdentity ?? self.colorIdentity,
            colors: colors ?? self.colors,
            convertedManaCost: convertedManaCost ?? self.convertedManaCost,
            flavorText: flavorText ?? self.flavorText,
            foreignData: foreignData ?? self.foreignData,
            frameVersion: frameVersion ?? self.frameVersion,
            hasFoil: hasFoil ?? self.hasFoil,
            hasNonFoil: hasNonFoil ?? self.hasNonFoil,
            layout: layout ?? self.layout,
            legalities: legalities ?? self.legalities,
            manaCost: manaCost ?? self.manaCost,
            multiverseID: multiverseID ?? self.multiverseID,
            name: name ?? self.name,
            number: number ?? self.number,
            originalText: originalText ?? self.originalText,
            originalType: originalType ?? self.originalType,
            power: power ?? self.power,
            printings: printings ?? self.printings,
            rarity: rarity ?? self.rarity,
            rulings: rulings ?? self.rulings,
            scryfallID: scryfallID ?? self.scryfallID,
            subtypes: subtypes ?? self.subtypes,
            supertypes: supertypes ?? self.supertypes,
            tcgplayerProductID: tcgplayerProductID ?? self.tcgplayerProductID,
            tcgplayerPurchaseURL: tcgplayerPurchaseURL ?? self.tcgplayerPurchaseURL,
            text: text ?? self.text,
            toughness: toughness ?? self.toughness,
            type: type ?? self.type,
            types: types ?? self.types,
            uuid: uuid ?? self.uuid,
            watermark: watermark ?? self.watermark,
            names: names ?? self.names,
            loyalty: loyalty ?? self.loyalty,
            faceConvertedManaCost: faceConvertedManaCost ?? self.faceConvertedManaCost,
            side: side ?? self.side,
            variations: variations ?? self.variations,
            starter: starter ?? self.starter
        )
    }
    
    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}
