//
//  UpdateSet.swift
//  MTGCards
//
//  Created by Joseph Smith on 5/9/19.
//  Copyright © 2019 Robotic Snail Software. All rights reserved.
//

// To parse the JSON, add this file to your project and do:
//
//   let updateSet = try UpdateSet(json)

import Foundation

class UpdateSet: Codable {
    let baseSetSize: Int
    let block: String?
    let cards: [UpdateCard]
    let code: String
    let isFoilOnly: Bool
    let isOnlineOnly: Bool
    let keyruneCode: String
    let mcmID: Int?
    let mcmName: String?
    let meta: UpdateMeta
    let mtgoCode: String?
    let name: String
    let releaseDate: String
    let tcgplayerGroupID: Int?
    let tokens: [UpdateToken]
    let totalSetSize: Int
    let translations: Translations
    let type: String
    
    enum CodingKeys: String, CodingKey {
        case baseSetSize = "baseSetSize"
        case block = "block"
        case cards = "cards"
        case code = "code"
        case isFoilOnly = "isFoilOnly"
        case isOnlineOnly = "isOnlineOnly"
        case keyruneCode = "keyruneCode"
        case mcmID = "mcmId"
        case mcmName = "mcmName"
        case meta = "meta"
        case mtgoCode = "mtgoCode"
        case name = "name"
        case releaseDate = "releaseDate"
        case tcgplayerGroupID = "tcgplayerGroupId"
        case tokens = "tokens"
        case totalSetSize = "totalSetSize"
        case translations = "translations"
        case type = "type"
    }
    
    init(baseSetSize: Int, block: String,  cards: [UpdateCard], code: String, isFoilOnly: Bool, isOnlineOnly: Bool, keyruneCode: String, mcmID: Int, mcmName: String, meta: UpdateMeta, mtgoCode: String, name: String, releaseDate: String, tcgplayerGroupID: Int, tokens: [UpdateToken], totalSetSize: Int, translations: Translations, type: String) {
        self.baseSetSize = baseSetSize
        self.block = block

        self.cards = cards
        self.code = code
        self.isFoilOnly = isFoilOnly
        self.isOnlineOnly = isOnlineOnly
        self.keyruneCode = keyruneCode
        self.mcmID = mcmID
        self.mcmName = mcmName
        self.meta = meta
        self.mtgoCode = mtgoCode
        self.name = name
        self.releaseDate = releaseDate
        self.tcgplayerGroupID = tcgplayerGroupID
        self.tokens = tokens
        self.totalSetSize = totalSetSize
        self.translations = translations
        self.type = type
    }
}

enum BoosterV3: Codable {
    case string(String)
    case stringArray([String])
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let x = try? container.decode([String].self) {
            self = .stringArray(x)
            return
        }
        if let x = try? container.decode(String.self) {
            self = .string(x)
            return
        }
        throw DecodingError.typeMismatch(BoosterV3.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for BoosterV3"))
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .string(let x):
            try container.encode(x)
        case .stringArray(let x):
            try container.encode(x)
        }
    }
}

class UpdateCard: Codable {
    let artist: String?
    let borderColor: String
    let colorIdentity: [String]
    let colors: [String]
    let convertedManaCost: Double?
    let foreignData: [UpdateForeignDatum]?
    let frameVersion: String
    let hasFoil: Bool
    let hasNonFoil: Bool
    let layout: String
    let legalities: UpdateLegalities
    let manaCost: String?
    let mcmID: Int?
    let mcmMetaID: Int?
    let mtgstocksID: Int?
    let multiverseID: Int?
    let name: String
    let number: String
    let originalText: String?
    let originalType: String?
    let power: String?
    let prices: Prices?
    let printings: [String]
    let purchaseUrls: PurchaseUrls?
    let rarity: String
    let rulings: [UpdateRuling]
    let scryfallID: String
    let scryfallIllustrationID: String?
    let scryfallOracleID: String
    let subtypes: [String]
    let supertypes: [String]
    let tcgplayerProductID: Int?
    let tcgplayerPurchaseURL: String?
    let text: String?
    let toughness: String?
    let type: String
    let types: [String]
    let uuid: String
    let flavorText: String?
    let faceConvertedManaCost: Int?
    let frameEffect: String?
    let names: [String]?
    let side: String?
    let isStarter: Bool?
    let variations: [String]?
    let loyalty: String?
    let watermark: String?
    let isReserved: Bool?
    
    enum CodingKeys: String, CodingKey {
        case artist = "artist"
        case borderColor = "borderColor"
        case colorIdentity = "colorIdentity"
        case colors = "colors"
        case convertedManaCost = "convertedManaCost"
        case foreignData = "foreignData"
        case frameVersion = "frameVersion"
        case hasFoil = "hasFoil"
        case hasNonFoil = "hasNonFoil"
        case layout = "layout"
        case legalities = "legalities"
        case manaCost = "manaCost"
        case mcmID = "mcmId"
        case mcmMetaID = "mcmMetaId"
        case mtgstocksID = "mtgstocksId"
        case multiverseID = "multiverseId"
        case name = "name"
        case number = "number"
        case originalText = "originalText"
        case originalType = "originalType"
        case power = "power"
        case prices = "prices"
        case printings = "printings"
        case purchaseUrls = "purchaseUrls"
        case rarity = "rarity"
        case rulings = "rulings"
        case scryfallID = "scryfallId"
        case scryfallIllustrationID = "scryfallIllustrationId"
        case scryfallOracleID = "scryfallOracleId"
        case subtypes = "subtypes"
        case supertypes = "supertypes"
        case tcgplayerProductID = "tcgplayerProductId"
        case tcgplayerPurchaseURL = "tcgplayerPurchaseUrl"
        case text = "text"
        case toughness = "toughness"
        case type = "type"
        case types = "types"
        case uuid = "uuid"
        case flavorText = "flavorText"
        case faceConvertedManaCost = "faceConvertedManaCost"
        case frameEffect = "frameEffect"
        case names = "names"
        case side = "side"
        case isStarter = "isStarter"
        case variations = "variations"
        case loyalty = "loyalty"
        case watermark = "watermark"
        case isReserved = "isReserved"
    }
    
    init(artist: String, borderColor: String, colorIdentity: [String], colors: [String], convertedManaCost: Double?, foreignData: [UpdateForeignDatum], frameVersion: String, hasFoil: Bool, hasNonFoil: Bool, layout: String, legalities: UpdateLegalities, manaCost: String?, mcmID: Int, mcmMetaID: Int, mtgstocksID: Int, multiverseID: Int, name: String, number: String, originalText: String?, originalType: String, power: String?, isReserved: Bool?, prices: Prices, printings: [String], purchaseUrls: PurchaseUrls, rarity: String, rulings: [UpdateRuling], scryfallID: String, scryfallIllustrationID: String?, scryfallOracleID: String, subtypes: [String], supertypes: [String], tcgplayerProductID: Int, tcgplayerPurchaseURL: String, text: String?, toughness: String?, type: String, types: [String], uuid: String, flavorText: String?, faceConvertedManaCost: Int?, frameEffect: String?, names: [String]?, side: String?, isStarter: Bool?, variations: [String]?, loyalty: String?, watermark: String?) {
        self.artist = artist
        self.borderColor = borderColor
        self.colorIdentity = colorIdentity
        self.colors = colors
        self.convertedManaCost = convertedManaCost
        self.foreignData = foreignData
        self.frameVersion = frameVersion
        self.hasFoil = hasFoil
        self.hasNonFoil = hasNonFoil
        self.layout = layout
        self.legalities = legalities
        self.manaCost = manaCost
        self.mcmID = mcmID
        self.mcmMetaID = mcmMetaID
        self.mtgstocksID = mtgstocksID
        self.multiverseID = multiverseID
        self.name = name
        self.number = number
        self.originalText = originalText
        self.originalType = originalType
        self.power = power
        self.isReserved = isReserved
        self.prices = prices
        self.printings = printings
        self.purchaseUrls = purchaseUrls
        self.rarity = rarity
        self.rulings = rulings
        self.scryfallID = scryfallID
        self.scryfallIllustrationID = scryfallIllustrationID
        self.scryfallOracleID = scryfallOracleID
        self.subtypes = subtypes
        self.supertypes = supertypes
        self.tcgplayerProductID = tcgplayerProductID
        self.tcgplayerPurchaseURL = tcgplayerPurchaseURL
        self.text = text
        self.toughness = toughness
        self.type = type
        self.types = types
        self.uuid = uuid
        self.flavorText = flavorText
        self.faceConvertedManaCost = faceConvertedManaCost
        self.frameEffect = frameEffect
        self.names = names
        self.side = side
        self.isStarter = isStarter
        self.variations = variations
        self.loyalty = loyalty
        self.watermark = watermark
    }
}

class UpdateForeignDatum: Codable {
    let flavorText: String?
    let language: String
    let multiverseID: Int?
    let name: String
    let text: String?
    let type: String?
    
    enum CodingKeys: String, CodingKey {
        case flavorText = "flavorText"
        case language = "language"
        case multiverseID = "multiverseId"
        case name = "name"
        case text = "text"
        case type = "type"
    }
    
    init(flavorText: String?, language: String, multiverseID: Int, name: String, text: String?, type: String) {
        self.flavorText = flavorText
        self.language = language
        self.multiverseID = multiverseID
        self.name = name
        self.text = text
        self.type = type
    }
}

class UpdateLegalities: Codable {
    let commander: String?
    let duel: String?
    let frontier: String?
    let future: String?
    let legacy: String?
    let modern: String?
    let pauper: String?
    let standard: String?
    let vintage: String?
    let penny: String?
    
    enum CodingKeys: String, CodingKey {
        case commander = "commander"
        case duel = "duel"
        case frontier = "frontier"
        case future = "future"
        case legacy = "legacy"
        case modern = "modern"
        case pauper = "pauper"
        case standard = "standard"
        case vintage = "vintage"
        case penny = "penny"
    }
    
    init(commander: String?, duel: String?, frontier: String?, future: String?, legacy: String?, modern: String?, pauper: String?, standard: String?, vintage: String?, penny: String?) {
        self.commander = commander
        self.duel = duel
        self.frontier = frontier
        self.future = future
        self.legacy = legacy
        self.modern = modern
        self.pauper = pauper
        self.standard = standard
        self.vintage = vintage
        self.penny = penny
    }
}

class Prices: Codable {
    let paper: [String: Double]
    
    enum CodingKeys: String, CodingKey {
        case paper = "paper"
    }
    
    init(paper: [String: Double]) {
        self.paper = paper
    }
}

class PurchaseUrls: Codable {
    let cardmarket: String?
    let mtgstocks: String?
    let tcgplayer: String?
    
    enum CodingKeys: String, CodingKey {
        case cardmarket = "cardmarket"
        case mtgstocks = "mtgstocks"
        case tcgplayer = "tcgplayer"
    }
    
    init(cardmarket: String?, mtgstocks: String?, tcgplayer: String?) {
        self.cardmarket = cardmarket
        self.mtgstocks = mtgstocks
        self.tcgplayer = tcgplayer
    }
}

class UpdateRuling: Codable {
    let date: String
    let text: String
    
    enum CodingKeys: String, CodingKey {
        case date = "date"
        case text = "text"
    }
    
    init(date: String, text: String) {
        self.date = date
        self.text = text
    }
}

class UpdateMeta: Codable {
    let date: String
    let pricesDate: String
    let version: String
    
    enum CodingKeys: String, CodingKey {
        case date = "date"
        case pricesDate = "pricesDate"
        case version = "version"
    }
    
    init(date: String, pricesDate: String, version: String) {
        self.date = date
        self.pricesDate = pricesDate
        self.version = version
    }
}

class UpdateToken: Codable {
    let artist: String?
    let borderColor: String?
    let colorIdentity: [String]
    let colors: [String]
    let layout: String
    let name: String
    let number: String
    let power: String?
    let reverseRelated: [String]
    let scryfallID: String?
    let scryfallIllustrationID: String?
    let scryfallOracleID: String
    let text: String?
    let toughness: String?
    let type: String
    let uuid: String
    
    enum CodingKeys: String, CodingKey {
        case artist = "artist"
        case borderColor = "borderColor"
        case colorIdentity = "colorIdentity"
        case colors = "colors"
        case layout = "layout"
        case name = "name"
        case number = "number"
        case power = "power"
        case reverseRelated = "reverseRelated"
        case scryfallID = "scryfallId"
        case scryfallIllustrationID = "scryfallIllustrationId"
        case scryfallOracleID = "scryfallOracleId"
        case text = "text"
        case toughness = "toughness"
        case type = "type"
        case uuid = "uuid"
    }
    
    init(artist: String, borderColor: String, colorIdentity: [String], colors: [String], layout: String, name: String, number: String, power: String?, reverseRelated: [String], scryfallID: String, scryfallIllustrationID: String, scryfallOracleID: String, text: String?, toughness: String?, type: String, uuid: String) {
        self.artist = artist
        self.borderColor = borderColor
        self.colorIdentity = colorIdentity
        self.colors = colors
        self.layout = layout
        self.name = name
        self.number = number
        self.power = power
        self.reverseRelated = reverseRelated
        self.scryfallID = scryfallID
        self.scryfallIllustrationID = scryfallIllustrationID
        self.scryfallOracleID = scryfallOracleID
        self.text = text
        self.toughness = toughness
        self.type = type
        self.uuid = uuid
    }
}

class Translations: Codable {
    let chineseSimplified: String?
    let chineseTraditional: String?
    let french: String?
    let german: String?
    let italian: String?
    let japanese: String?
    let korean: String?
    let portugueseBrazil: String?
    let russian: String?
    let spanish: String?
    
    enum CodingKeys: String, CodingKey {
        case chineseSimplified = "Chinese Simplified"
        case chineseTraditional = "Chinese Traditional"
        case french = "French"
        case german = "German"
        case italian = "Italian"
        case japanese = "Japanese"
        case korean = "Korean"
        case portugueseBrazil = "Portuguese (Brazil)"
        case russian = "Russian"
        case spanish = "Spanish"
    }
    
    init(chineseSimplified: String, chineseTraditional: String, french: String, german: String, italian: String, japanese: String, korean: String, portugueseBrazil: String, russian: String, spanish: String) {
        self.chineseSimplified = chineseSimplified
        self.chineseTraditional = chineseTraditional
        self.french = french
        self.german = german
        self.italian = italian
        self.japanese = japanese
        self.korean = korean
        self.portugueseBrazil = portugueseBrazil
        self.russian = russian
        self.spanish = spanish
    }
}

// MARK: Convenience initializers and mutators

extension UpdateSet {
   
    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

extension UpdateCard {
    

    

    
    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

extension UpdateForeignDatum {
    
    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

extension UpdateLegalities {
    convenience init(data: Data) throws {
        let me = try newJSONDecoder().decode(UpdateLegalities.self, from: data)
        self.init(commander: me.commander , duel: me.duel, frontier: me.frontier, future: me.future, legacy: me.legacy, modern: me.modern, pauper: me.pauper, standard: me.standard, vintage: me.vintage, penny: me.penny)
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
        commander: String? = nil,
        duel: String? = nil,
        frontier: String? = nil,
        future: String? = nil,
        legacy: String? = nil,
        modern: String? = nil,
        pauper: String?? = nil,
        standard: String? = nil,
        vintage: String? = nil,
        penny: String?? = nil
        ) -> UpdateLegalities {
        return UpdateLegalities(
            commander: commander ?? self.commander,
            duel: duel ?? self.duel,
            frontier: frontier ?? self.frontier,
            future: future ?? self.future,
            legacy: legacy ?? self.legacy,
            modern: modern ?? self.modern,
            pauper: pauper ?? self.pauper,
            standard: standard ?? self.standard,
            vintage: vintage ?? self.vintage,
            penny: penny ?? self.penny
        )
    }
    
    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

extension Prices {
    convenience init(data: Data) throws {
        let me = try newJSONDecoder().decode(Prices.self, from: data)
        self.init(paper: me.paper)
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
        paper: [String: Double]? = nil
        ) -> Prices {
        return Prices(
            paper: paper ?? self.paper
        )
    }
    
    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

extension PurchaseUrls {
    convenience init(data: Data) throws {
        let me = try newJSONDecoder().decode(PurchaseUrls.self, from: data)
        self.init(cardmarket: me.cardmarket, mtgstocks: me.mtgstocks, tcgplayer: me.tcgplayer)
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
        cardmarket: String?? = nil,
        mtgstocks: String?? = nil,
        tcgplayer: String?? = nil
        ) -> PurchaseUrls {
        return PurchaseUrls(
            cardmarket: cardmarket ?? self.cardmarket,
            mtgstocks: mtgstocks ?? self.mtgstocks,
            tcgplayer: tcgplayer ?? self.tcgplayer
        )
    }
    
    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

extension UpdateRuling {
    convenience init(data: Data) throws {
        let me = try newJSONDecoder().decode(UpdateRuling.self, from: data)
        self.init(date: me.date , text: me.text)
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
        date: String? = nil,
        text: String? = nil
        ) -> UpdateRuling {
        return UpdateRuling(
            date: date ?? self.date,
            text: text ?? self.text
        )
    }
    
    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}
extension Array where Element == UpdateRuling {
    init(data: Data) throws {
        self = try newJSONDecoder().decode([UpdateRuling].self, from: data)
    }
    
    init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }
    
    init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }
    
    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}
extension UpdateMeta {
    convenience init(data: Data) throws {
        let me = try newJSONDecoder().decode(UpdateMeta.self, from: data)
        self.init(date: me.date , pricesDate: me.pricesDate, version: me.version)
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
        date: String? = nil,
        pricesDate: String? = nil,
        version: String? = nil
        ) -> UpdateMeta {
        return UpdateMeta(
            date: date ?? self.date,
            pricesDate: pricesDate ?? self.pricesDate,
            version: version ?? self.version
        )
    }
}

extension UpdateToken {
 
    
    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

extension Translations {
    
    
    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

