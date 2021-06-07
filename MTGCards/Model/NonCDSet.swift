// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let mTGSets = try MTGSets(json)

import Foundation

// MARK: - NonCDMTGSet
struct NonCDMTGSet: Codable {
    let data: NonCDDataClass?
    let meta: NonCDMeta?
    
    enum CodingKeys: String, CodingKey {
        case data = "data"
        case meta = "meta"
    }
}

// MARK: NonCDMTGSet convenience initializers and mutators

extension NonCDMTGSet {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(NonCDMTGSet.self, from: data)
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
    
    func with(
        data: NonCDDataClass?? = nil,
        meta: NonCDMeta?? = nil
    ) -> NonCDMTGSet {
        return NonCDMTGSet(
            data: data ?? self.data,
            meta: meta ?? self.meta
        )
    }
    
    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - NonCDDataClass
struct NonCDDataClass: Codable {
    let baseSetSize: Int?
    let block: String?
    let booster: NonCDDataBooster?
    let cards: [NonCDCard]?
    let code: String?
    let isFoilOnly: Bool?
    let isOnlineOnly: Bool?
    let keyruneCode: String?
    let mcmID: Int?
    let mcmName: String?
    let mtgoCode: String?
    let name: String?
    let releaseDate: String?
    let tcgplayerGroupID: Int?
    let tokens: [NonCDToken]?
    let totalSetSize: Int?
    let translations: NonCDTranslations?
    let type: String?
    
    enum CodingKeys: String, CodingKey {
        case baseSetSize = "baseSetSize"
        case block = "block"
        case booster = "booster"
        case cards = "cards"
        case code = "code"
        case isFoilOnly = "isFoilOnly"
        case isOnlineOnly = "isOnlineOnly"
        case keyruneCode = "keyruneCode"
        case mcmID = "mcmId"
        case mcmName = "mcmName"
        case mtgoCode = "mtgoCode"
        case name = "name"
        case releaseDate = "releaseDate"
        case tcgplayerGroupID = "tcgplayerGroupId"
        case tokens = "tokens"
        case totalSetSize = "totalSetSize"
        case translations = "translations"
        case type = "type"
    }
}

// MARK: NonCDDataClass convenience initializers and mutators

extension NonCDDataClass {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(NonCDDataClass.self, from: data)
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
    
    func with(
        baseSetSize: Int?? = nil,
        block: String?? = nil,
        booster: NonCDDataBooster?? = nil,
        cards: [NonCDCard]?? = nil,
        code: String?? = nil,
        isFoilOnly: Bool?? = nil,
        isOnlineOnly: Bool?? = nil,
        keyruneCode: String?? = nil,
        mcmID: Int?? = nil,
        mcmName: String?? = nil,
        mtgoCode: String?? = nil,
        name: String?? = nil,
        releaseDate: String?? = nil,
        tcgplayerGroupID: Int?? = nil,
        tokens: [NonCDToken]?? = nil,
        totalSetSize: Int?? = nil,
        translations: NonCDTranslations?? = nil,
        type: String?? = nil
    ) -> NonCDDataClass {
        return NonCDDataClass(
            baseSetSize: baseSetSize ?? self.baseSetSize,
            block: block ?? self.block,
            booster: booster ?? self.booster,
            cards: cards ?? self.cards,
            code: code ?? self.code,
            isFoilOnly: isFoilOnly ?? self.isFoilOnly,
            isOnlineOnly: isOnlineOnly ?? self.isOnlineOnly,
            keyruneCode: keyruneCode ?? self.keyruneCode,
            mcmID: mcmID ?? self.mcmID,
            mcmName: mcmName ?? self.mcmName,
            mtgoCode: mtgoCode ?? self.mtgoCode,
            name: name ?? self.name,
            releaseDate: releaseDate ?? self.releaseDate,
            tcgplayerGroupID: tcgplayerGroupID ?? self.tcgplayerGroupID,
            tokens: tokens ?? self.tokens,
            totalSetSize: totalSetSize ?? self.totalSetSize,
            translations: translations ?? self.translations,
            type: type ?? self.type
        )
    }
    
    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - NonCDDataBooster
struct NonCDDataBooster: Codable {
    let boosterDefault: Default?
    
    enum CodingKeys: String, CodingKey {
        case boosterDefault = "default"
    }
}

// MARK: NonCDDataBooster convenience initializers and mutators

extension NonCDDataBooster {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(NonCDDataBooster.self, from: data)
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
    
    func with(
        boosterDefault: Default?? = nil
    ) -> NonCDDataBooster {
        return NonCDDataBooster(
            boosterDefault: boosterDefault ?? self.boosterDefault
        )
    }
    
    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - Default
struct Default: Codable {
    let boosters: [BoosterElement]?
    let boostersTotalWeight: Int?
    let sheets: Sheets?
    
    enum CodingKeys: String, CodingKey {
        case boosters = "boosters"
        case boostersTotalWeight = "boostersTotalWeight"
        case sheets = "sheets"
    }
}

// MARK: Default convenience initializers and mutators

extension Default {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(Default.self, from: data)
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
    
    func with(
        boosters: [BoosterElement]?? = nil,
        boostersTotalWeight: Int?? = nil,
        sheets: Sheets?? = nil
    ) -> Default {
        return Default(
            boosters: boosters ?? self.boosters,
            boostersTotalWeight: boostersTotalWeight ?? self.boostersTotalWeight,
            sheets: sheets ?? self.sheets
        )
    }
    
    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - BoosterElement
struct BoosterElement: Codable {
    let contents: Contents?
    let weight: Int?
    
    enum CodingKeys: String, CodingKey {
        case contents = "contents"
        case weight = "weight"
    }
}

// MARK: BoosterElement convenience initializers and mutators

extension BoosterElement {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(BoosterElement.self, from: data)
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
    
    func with(
        contents: Contents?? = nil,
        weight: Int?? = nil
    ) -> BoosterElement {
        return BoosterElement(
            contents: contents ?? self.contents,
            weight: weight ?? self.weight
        )
    }
    
    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - Contents
struct Contents: Codable {
    let common: Int?
    let land: Int?
    let rareMythic: Int?
    let uncommon: Int?
    let foil: Int?
    let rare: Int?
    let basic: Int?
    let unhingedFoil: Int?
    
    enum CodingKeys: String, CodingKey {
        case common = "common"
        case land = "land"
        case rareMythic = "rareMythic"
        case uncommon = "uncommon"
        case foil = "foil"
        case rare = "rare"
        case basic = "basic"
        case unhingedFoil = "unhingedFoil"
    }
}

// MARK: Contents convenience initializers and mutators

extension Contents {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(Contents.self, from: data)
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
    
    func with(
        common: Int?? = nil,
        land: Int?? = nil,
        rareMythic: Int?? = nil,
        uncommon: Int?? = nil,
        foil: Int?? = nil,
        rare: Int?? = nil,
        basic: Int?? = nil,
        unhingedFoil: Int?? = nil
    ) -> Contents {
        return Contents(
            common: common ?? self.common,
            land: land ?? self.land,
            rareMythic: rareMythic ?? self.rareMythic,
            uncommon: uncommon ?? self.uncommon,
            foil: foil ?? self.foil,
            rare: rare ?? self.rare,
            basic: basic ?? self.basic,
            unhingedFoil: unhingedFoil ?? self.unhingedFoil
        )
    }
    
    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - Sheets
struct Sheets: Codable {
    let common: Common?
    let foil: Basic?
    let land: Basic?
    let rareMythic: Basic?
    let uncommon: Basic?
    let rare: Basic?
    let basic: Basic?
    let unhingedFoil: Basic?
    
    enum CodingKeys: String, CodingKey {
        case common = "common"
        case foil = "foil"
        case land = "land"
        case rareMythic = "rareMythic"
        case uncommon = "uncommon"
        case rare = "rare"
        case basic = "basic"
        case unhingedFoil = "unhingedFoil"
    }
}

// MARK: Sheets convenience initializers and mutators

extension Sheets {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(Sheets.self, from: data)
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
    
    func with(
        common: Common?? = nil,
        foil: Basic?? = nil,
        land: Basic?? = nil,
        rareMythic: Basic?? = nil,
        uncommon: Basic?? = nil,
        rare: Basic?? = nil,
        basic: Basic?? = nil,
        unhingedFoil: Basic?? = nil
    ) -> Sheets {
        return Sheets(
            common: common ?? self.common,
            foil: foil ?? self.foil,
            land: land ?? self.land,
            rareMythic: rareMythic ?? self.rareMythic,
            uncommon: uncommon ?? self.uncommon,
            rare: rare ?? self.rare,
            basic: basic ?? self.basic,
            unhingedFoil: unhingedFoil ?? self.unhingedFoil
        )
    }
    
    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - Basic
struct Basic: Codable {
    let cards: [String: Int]?
    let foil: Bool?
    let totalWeight: Int?
    
    enum CodingKeys: String, CodingKey {
        case cards = "cards"
        case foil = "foil"
        case totalWeight = "totalWeight"
    }
}

// MARK: Basic convenience initializers and mutators

extension Basic {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(Basic.self, from: data)
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
    
    func with(
        cards: [String: Int]?? = nil,
        foil: Bool?? = nil,
        totalWeight: Int?? = nil
    ) -> Basic {
        return Basic(
            cards: cards ?? self.cards,
            foil: foil ?? self.foil,
            totalWeight: totalWeight ?? self.totalWeight
        )
    }
    
    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - Common
struct Common: Codable {
    let balanceColors: Bool?
    let cards: [String: Int]?
    let foil: Bool?
    let totalWeight: Int?
    
    enum CodingKeys: String, CodingKey {
        case balanceColors = "balanceColors"
        case cards = "cards"
        case foil = "foil"
        case totalWeight = "totalWeight"
    }
}

// MARK: Common convenience initializers and mutators

extension Common {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(Common.self, from: data)
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
    
    func with(
        balanceColors: Bool?? = nil,
        cards: [String: Int]?? = nil,
        foil: Bool?? = nil,
        totalWeight: Int?? = nil
    ) -> Common {
        return Common(
            balanceColors: balanceColors ?? self.balanceColors,
            cards: cards ?? self.cards,
            foil: foil ?? self.foil,
            totalWeight: totalWeight ?? self.totalWeight
        )
    }
    
    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - NonCDCard
struct NonCDCard: Codable {
    let artist: String?
    let availability: [String]?
    let borderColor: String?
    let colorIdentity: [String]?
    let colors: [String]?
    let convertedManaCost: Double?
    let edhrecRank: Int?
    let flavorText: String?
    let foreignData: [NonCDForeignDatum]?
    let frameVersion: String?
    let hasFoil: Bool?
    let hasNonFoil: Bool?
    let identifiers: NonCDCardIdentifiers?
    let isReprint: Bool?
    let layout: String?
    let legalities: CardLegalities?
    let manaCost: String?
    let name: String?
    let number: String?
    let originalText: String?
    let originalType: String?
    let printings: [String]?
    let purchaseUrls: CardPurchaseUrls?
    let rarity: String?
    let rulings: [NonCDRuling]?
    let setCode: String?
    let subtypes: [String]?
    let supertypes: [String]?
    let text: String?
    let type: String?
    let types: [String]?
    let uuid: String?
    let watermark: String?
    let keywords: [String]?
    let power: String?
    let toughness: String?
    let variations: [String]?
    let faceConvertedManaCost: Int?
    let faceName: String?
    let otherFaceIDS: [String]?
    let side: String?
    let isStarter: Bool?
    let leadershipSkills: LeadershipSkills?
    let loyalty: String?
    let isStorySpotlight: Bool?
    let frameEffects: [String]?
    let hasAlternativeDeckLimit: Bool?
    let isPromo: Bool?
    let promoTypes: [String]?
    let isAlternative: Bool?
    let isFullArt: Bool?
    let asciiName: String?
    let isReserved: Bool?
    
    enum CodingKeys: String, CodingKey {
        case artist = "artist"
        case availability = "availability"
        case borderColor = "borderColor"
        case colorIdentity = "colorIdentity"
        case colors = "colors"
        case convertedManaCost = "convertedManaCost"
        case edhrecRank = "edhrecRank"
        case flavorText = "flavorText"
        case foreignData = "foreignData"
        case frameVersion = "frameVersion"
        case hasFoil = "hasFoil"
        case hasNonFoil = "hasNonFoil"
        case identifiers = "identifiers"
        case isReprint = "isReprint"
        case layout = "layout"
        case legalities = "legalities"
        case manaCost = "manaCost"
        case name = "name"
        case number = "number"
        case originalText = "originalText"
        case originalType = "originalType"
        case printings = "printings"
        case purchaseUrls = "purchaseUrls"
        case rarity = "rarity"
        case rulings = "rulings"
        case setCode = "setCode"
        case subtypes = "subtypes"
        case supertypes = "supertypes"
        case text = "text"
        case type = "type"
        case types = "types"
        case uuid = "uuid"
        case watermark = "watermark"
        case keywords = "keywords"
        case power = "power"
        case toughness = "toughness"
        case variations = "variations"
        case faceConvertedManaCost = "faceConvertedManaCost"
        case faceName = "faceName"
        case otherFaceIDS = "otherFaceIds"
        case side = "side"
        case isStarter = "isStarter"
        case leadershipSkills = "leadershipSkills"
        case loyalty = "loyalty"
        case isStorySpotlight = "isStorySpotlight"
        case frameEffects = "frameEffects"
        case hasAlternativeDeckLimit = "hasAlternativeDeckLimit"
        case isPromo = "isPromo"
        case promoTypes = "promoTypes"
        case isAlternative = "isAlternative"
        case isFullArt = "isFullArt"
        case asciiName = "asciiName"
        case isReserved = "isReserved"
    }
}

// MARK: NonCDCard convenience initializers and mutators

extension NonCDCard {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(NonCDCard.self, from: data)
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
    
    func with(
        artist: String?? = nil,
        availability: [String]?? = nil,
        borderColor: String?? = nil,
        colorIdentity: [String]?? = nil,
        colors: [String]?? = nil,
        convertedManaCost: Double?? = nil,
        edhrecRank: Int?? = nil,
        flavorText: String?? = nil,
        foreignData: [NonCDForeignDatum]?? = nil,
        frameVersion: String?? = nil,
        hasFoil: Bool?? = nil,
        hasNonFoil: Bool?? = nil,
        identifiers: NonCDCardIdentifiers?? = nil,
        isReprint: Bool?? = nil,
        layout: String?? = nil,
        legalities: CardLegalities?? = nil,
        manaCost: String?? = nil,
        name: String?? = nil,
        number: String?? = nil,
        originalText: String?? = nil,
        originalType: String?? = nil,
        printings: [String]?? = nil,
        purchaseUrls: CardPurchaseUrls?? = nil,
        rarity: String?? = nil,
        rulings: [NonCDRuling]?? = nil,
        setCode: String?? = nil,
        subtypes: [String]?? = nil,
        supertypes: [String]?? = nil,
        text: String?? = nil,
        type: String?? = nil,
        types: [String]?? = nil,
        uuid: String?? = nil,
        watermark: String?? = nil,
        keywords: [String]?? = nil,
        power: String?? = nil,
        toughness: String?? = nil,
        variations: [String]?? = nil,
        faceConvertedManaCost: Int?? = nil,
        faceName: String?? = nil,
        otherFaceIDS: [String]?? = nil,
        side: String?? = nil,
        isStarter: Bool?? = nil,
        leadershipSkills: LeadershipSkills?? = nil,
        loyalty: String?? = nil,
        isStorySpotlight: Bool?? = nil,
        frameEffects: [String]?? = nil,
        hasAlternativeDeckLimit: Bool?? = nil,
        isPromo: Bool?? = nil,
        promoTypes: [String]?? = nil,
        isAlternative: Bool?? = nil,
        isFullArt: Bool?? = nil,
        asciiName: String?? = nil,
        isReserved: Bool?? = nil
    ) -> NonCDCard {
        return NonCDCard(
            artist: artist ?? self.artist,
            availability: availability ?? self.availability,
            borderColor: borderColor ?? self.borderColor,
            colorIdentity: colorIdentity ?? self.colorIdentity,
            colors: colors ?? self.colors,
            convertedManaCost: convertedManaCost ?? self.convertedManaCost,
            edhrecRank: edhrecRank ?? self.edhrecRank,
            flavorText: flavorText ?? self.flavorText,
            foreignData: foreignData ?? self.foreignData,
            frameVersion: frameVersion ?? self.frameVersion,
            hasFoil: hasFoil ?? self.hasFoil,
            hasNonFoil: hasNonFoil ?? self.hasNonFoil,
            identifiers: identifiers ?? self.identifiers,
            isReprint: isReprint ?? self.isReprint,
            layout: layout ?? self.layout,
            legalities: legalities ?? self.legalities,
            manaCost: manaCost ?? self.manaCost,
            name: name ?? self.name,
            number: number ?? self.number,
            originalText: originalText ?? self.originalText,
            originalType: originalType ?? self.originalType,
            printings: printings ?? self.printings,
            purchaseUrls: purchaseUrls ?? self.purchaseUrls,
            rarity: rarity ?? self.rarity,
            rulings: rulings ?? self.rulings,
            setCode: setCode ?? self.setCode,
            subtypes: subtypes ?? self.subtypes,
            supertypes: supertypes ?? self.supertypes,
            text: text ?? self.text,
            type: type ?? self.type,
            types: types ?? self.types,
            uuid: uuid ?? self.uuid,
            watermark: watermark ?? self.watermark,
            keywords: keywords ?? self.keywords,
            power: power ?? self.power,
            toughness: toughness ?? self.toughness,
            variations: variations ?? self.variations,
            faceConvertedManaCost: faceConvertedManaCost ?? self.faceConvertedManaCost,
            faceName: faceName ?? self.faceName,
            otherFaceIDS: otherFaceIDS ?? self.otherFaceIDS,
            side: side ?? self.side,
            isStarter: isStarter ?? self.isStarter,
            leadershipSkills: leadershipSkills ?? self.leadershipSkills,
            loyalty: loyalty ?? self.loyalty,
            isStorySpotlight: isStorySpotlight ?? self.isStorySpotlight,
            frameEffects: frameEffects ?? self.frameEffects,
            hasAlternativeDeckLimit: hasAlternativeDeckLimit ?? self.hasAlternativeDeckLimit,
            isPromo: isPromo ?? self.isPromo,
            promoTypes: promoTypes ?? self.promoTypes,
            isAlternative: isAlternative ?? self.isAlternative,
            isFullArt: isFullArt ?? self.isFullArt,
            asciiName: asciiName ?? self.asciiName,
            isReserved: isReserved ?? self.isReserved
        )
    }
    
    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
    func compareTo(card: NonCDCard) -> Bool {
        if artist != card.artist ||
            availability != card.availability ||
            borderColor != card.borderColor ||
            colorIdentity != card.colorIdentity ||
            colors?.count != card.colors?.count ||
            convertedManaCost != card.convertedManaCost ||
            flavorText != card.flavorText ||
            foreignData?.count != card.foreignData?.count ||
            frameVersion != card.frameVersion ||
            hasFoil != card.hasFoil ||
            hasNonFoil != card.hasNonFoil ||
            isReprint != card.isReprint ||
            layout != card.layout ||
            manaCost != card.manaCost ||
            name != card.name ||
            number != card.number ||
            originalText != card.originalText ||
            originalType != card.originalType ||
            printings?.count != card.printings?.count ||
            rarity != card.rarity ||
            rulings?.count != card.rulings?.count ||
            setCode != card.setCode ||
            subtypes?.count != card.subtypes?.count ||
            supertypes?.count != card.supertypes?.count ||
            text != card.text ||
            type != card.type ||
            types?.count != card.types?.count ||
            uuid != card.uuid ||
            watermark != card.watermark ||
            keywords?.count != card.keywords?.count ||
            power != card.power ||
            toughness != card.toughness ||
            variations?.count != card.variations?.count ||
            faceConvertedManaCost != card.faceConvertedManaCost ||
            faceName != card.faceName ||
            otherFaceIDS?.count != card.otherFaceIDS?.count ||
            side != card.side ||
            isStarter != card.isStarter ||
            loyalty != card.loyalty ||
            isStorySpotlight != card.isStorySpotlight ||
            frameEffects?.count != card.frameEffects?.count ||
            hasAlternativeDeckLimit != card.hasAlternativeDeckLimit ||
            isPromo != card.isPromo ||
            promoTypes?.count != card.promoTypes?.count ||
            isAlternative != card.isAlternative ||
            isFullArt != card.isFullArt ||
            asciiName != card.asciiName ||
            leadershipSkills?.brawl != card.leadershipSkills?.brawl ||
            leadershipSkills?.commander != card.leadershipSkills?.commander ||
            leadershipSkills?.oathbreaker != card.leadershipSkills?.oathbreaker ||
            purchaseUrls?.cardmarket != card.purchaseUrls?.cardmarket ||
            purchaseUrls?.cardKingdom != card.purchaseUrls?.cardKingdom ||
            purchaseUrls?.cardKingdomFoil != card.purchaseUrls?.cardKingdomFoil ||
            purchaseUrls?.tcgplayer != card.purchaseUrls?.tcgplayer ||
            legalities?.brawl != card.legalities?.brawl ||
            legalities?.commander != card.legalities?.commander ||
            legalities?.duel != card.legalities?.duel ||
            legalities?.future != card.legalities?.future ||
            legalities?.historic != card.legalities?.historic ||
            legalities?.legacy != card.legalities?.legacy ||
            legalities?.modern != card.legalities?.modern ||
            legalities?.pauper != card.legalities?.pauper ||
            legalities?.penny != card.legalities?.penny ||
            legalities?.pioneer != card.legalities?.pioneer ||
            legalities?.standard != card.legalities?.standard ||
            legalities?.vintage != card.legalities?.vintage ||
            identifiers?.cardKingdomFoilID != card.identifiers?.cardKingdomFoilID ||
            identifiers?.cardKingdomID != card.identifiers?.cardKingdomID ||
            identifiers?.mcmID != card.identifiers?.mcmID ||
            identifiers?.mcmMetaID != card.identifiers?.mcmMetaID ||
            identifiers?.mtgArenaID != card.identifiers?.mtgArenaID ||
            identifiers?.mtgjsonV4ID != card.identifiers?.mtgjsonV4ID ||
            identifiers?.mtgoFoilID != card.identifiers?.mtgoFoilID ||
            identifiers?.mtgoID != card.identifiers?.mtgoID ||
            identifiers?.multiverseID != card.identifiers?.multiverseID ||
            identifiers?.scryfallID != card.identifiers?.scryfallID ||
            identifiers?.scryfallIllustrationID != card.identifiers?.scryfallIllustrationID ||
            identifiers?.scryfallOracleID != card.identifiers?.scryfallOracleID ||
            identifiers?.tcgplayerProductID != card.identifiers?.tcgplayerProductID
        {
            return false
        } else {
            //promoTypes: [String]?? = nil,
            if let pt = promoTypes?.sorted(), let oldpt = card.promoTypes?.sorted() {
                if !pt.elementsEqual(oldpt) {
                    return false
                }
            }
            //frameEffects: [String]?? = nil,
            if let n = frameEffects?.sorted(), let old = card.frameEffects?.sorted() {
                if !n.elementsEqual(old) {
                    return false
                }
            }
            //colors: [String]?? = nil,
            if let n = colors?.sorted(), let old = card.colors?.sorted() {
                if !n.elementsEqual(old) {
                    return false
                }
            }
            //otherFaceIDS: [String]?? = nil,
            if let n = otherFaceIDS?.sorted(), let old = card.otherFaceIDS?.sorted() {
                if !n.elementsEqual(old) {
                    return false
                }
            }
            //variations: [String]?? = nil,
            if let n = variations?.sorted(), let old = card.variations?.sorted() {
                if !n.elementsEqual(old) {
                    return false
                }
            }
            //keywords: [String]?? = nil,
            if let n = keywords?.sorted(), let old = card.keywords?.sorted() {
                if !n.elementsEqual(old) {
                    return false
                }
            }
            //types: [String]?? = nil,
            if let n = types?.sorted(), let old = card.types?.sorted() {
                if !n.elementsEqual(old) {
                    return false
                }
            }
            //supertypes: [String]?? = nil,
            if let n = supertypes?.sorted(), let old = card.supertypes?.sorted() {
                if !n.elementsEqual(old) {
                    return false
                }
            }
            //subtypes: [String]?? = nil,
            if let n = subtypes?.sorted(), let old = card.subtypes?.sorted() {
                if !n.elementsEqual(old) {
                    return false
                }
            }
            //printings: [String]?? = nil,
            if let n = printings?.sorted(), let old = card.printings?.sorted() {
                if !n.elementsEqual(old) {
                    return false
                }
            }
            if let newRulings = rulings, let oldRulings = card.rulings {
                for ruling in newRulings {
                    let old = oldRulings.first(where: { $0.date == ruling.date && $0.text == ruling.text })
                    if old != nil {
                        continue
                    } else {
                        return false
                    }
                }
            }
            return true
        }
    }
}

// MARK: - NonCDForeignDatum
struct NonCDForeignDatum: Codable {
    let flavorText: String?
    let language: String?
    let multiverseID: Int?
    let name: String?
    let text: String?
    let type: String?
    let faceName: String?
    
    enum CodingKeys: String, CodingKey {
        case flavorText = "flavorText"
        case language = "language"
        case multiverseID = "multiverseId"
        case name = "name"
        case text = "text"
        case type = "type"
        case faceName = "faceName"
    }
}

// MARK: NonCDForeignDatum convenience initializers and mutators

extension NonCDForeignDatum {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(NonCDForeignDatum.self, from: data)
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
    
    func with(
        flavorText: String?? = nil,
        language: String?? = nil,
        multiverseID: Int?? = nil,
        name: String?? = nil,
        text: String?? = nil,
        type: String?? = nil,
        faceName: String?? = nil
    ) -> NonCDForeignDatum {
        return NonCDForeignDatum(
            flavorText: flavorText ?? self.flavorText,
            language: language ?? self.language,
            multiverseID: multiverseID ?? self.multiverseID,
            name: name ?? self.name,
            text: text ?? self.text,
            type: type ?? self.type,
            faceName: faceName ?? self.faceName
        )
    }
    
    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - NonCDCardIdentifiers
struct NonCDCardIdentifiers: Codable {
    let cardKingdomFoilID: String?
    let cardKingdomID: String?
    let mcmID: String?
    let mcmMetaID: String?
    let mtgArenaID: String?
    let mtgjsonV4ID: String?
    let mtgoID: String?
    let multiverseID: String?
    let scryfallID: String?
    let scryfallIllustrationID: String?
    let scryfallOracleID: String?
    let tcgplayerProductID: String?
    let mtgoFoilID: String?
    
    enum CodingKeys: String, CodingKey {
        case cardKingdomFoilID = "cardKingdomFoilId"
        case cardKingdomID = "cardKingdomId"
        case mcmID = "mcmId"
        case mcmMetaID = "mcmMetaId"
        case mtgArenaID = "mtgArenaId"
        case mtgjsonV4ID = "mtgjsonV4Id"
        case mtgoID = "mtgoId"
        case multiverseID = "multiverseId"
        case scryfallID = "scryfallId"
        case scryfallIllustrationID = "scryfallIllustrationId"
        case scryfallOracleID = "scryfallOracleId"
        case tcgplayerProductID = "tcgplayerProductId"
        case mtgoFoilID = "mtgoFoilId"
    }
}

// MARK: NonCDCardIdentifiers convenience initializers and mutators

extension NonCDCardIdentifiers {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(NonCDCardIdentifiers.self, from: data)
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
    
    func with(
        cardKingdomFoilID: String?? = nil,
        cardKingdomID: String?? = nil,
        mcmID: String?? = nil,
        mcmMetaID: String?? = nil,
        mtgArenaID: String?? = nil,
        mtgjsonV4ID: String?? = nil,
        mtgoID: String?? = nil,
        multiverseID: String?? = nil,
        scryfallID: String?? = nil,
        scryfallIllustrationID: String?? = nil,
        scryfallOracleID: String?? = nil,
        tcgplayerProductID: String?? = nil,
        mtgoFoilID: String?? = nil
    ) -> NonCDCardIdentifiers {
        return NonCDCardIdentifiers(
            cardKingdomFoilID: cardKingdomFoilID ?? self.cardKingdomFoilID,
            cardKingdomID: cardKingdomID ?? self.cardKingdomID,
            mcmID: mcmID ?? self.mcmID,
            mcmMetaID: mcmMetaID ?? self.mcmMetaID,
            mtgArenaID: mtgArenaID ?? self.mtgArenaID,
            mtgjsonV4ID: mtgjsonV4ID ?? self.mtgjsonV4ID,
            mtgoID: mtgoID ?? self.mtgoID,
            multiverseID: multiverseID ?? self.multiverseID,
            scryfallID: scryfallID ?? self.scryfallID,
            scryfallIllustrationID: scryfallIllustrationID ?? self.scryfallIllustrationID,
            scryfallOracleID: scryfallOracleID ?? self.scryfallOracleID,
            tcgplayerProductID: tcgplayerProductID ?? self.tcgplayerProductID,
            mtgoFoilID: mtgoFoilID ?? self.mtgoFoilID
        )
    }
    
    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - LeadershipSkills
struct LeadershipSkills: Codable {
    let brawl: Bool?
    let commander: Bool?
    let oathbreaker: Bool?
    
    enum CodingKeys: String, CodingKey {
        case brawl = "brawl"
        case commander = "commander"
        case oathbreaker = "oathbreaker"
    }
}

// MARK: LeadershipSkills convenience initializers and mutators

extension LeadershipSkills {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(LeadershipSkills.self, from: data)
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
    
    func with(
        brawl: Bool?? = nil,
        commander: Bool?? = nil,
        oathbreaker: Bool?? = nil
    ) -> LeadershipSkills {
        return LeadershipSkills(
            brawl: brawl ?? self.brawl,
            commander: commander ?? self.commander,
            oathbreaker: oathbreaker ?? self.oathbreaker
        )
    }
    
    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - CardLegalities
struct CardLegalities: Codable {
    let commander: String?
    let duel: String?
    let historic: String?
    let legacy: String?
    let modern: String?
    let pioneer: String?
    let vintage: String?
    let pauper: String?
    let penny: String?
    let brawl: String?
    let future: String?
    let standard: String?
    
    enum CodingKeys: String, CodingKey {
        case commander = "commander"
        case duel = "duel"
        case historic = "historic"
        case legacy = "legacy"
        case modern = "modern"
        case pioneer = "pioneer"
        case vintage = "vintage"
        case pauper = "pauper"
        case penny = "penny"
        case brawl = "brawl"
        case future = "future"
        case standard = "standard"
    }
}

// MARK: CardLegalities convenience initializers and mutators

extension CardLegalities {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(CardLegalities.self, from: data)
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
    
    func with(
        commander: String?? = nil,
        duel: String?? = nil,
        historic: String?? = nil,
        legacy: String?? = nil,
        modern: String?? = nil,
        pioneer: String?? = nil,
        vintage: String?? = nil,
        pauper: String?? = nil,
        penny: String?? = nil,
        brawl: String?? = nil,
        future: String?? = nil,
        standard: String?? = nil
    ) -> CardLegalities {
        return CardLegalities(
            commander: commander ?? self.commander,
            duel: duel ?? self.duel,
            historic: historic ?? self.historic,
            legacy: legacy ?? self.legacy,
            modern: modern ?? self.modern,
            pioneer: pioneer ?? self.pioneer,
            vintage: vintage ?? self.vintage,
            pauper: pauper ?? self.pauper,
            penny: penny ?? self.penny,
            brawl: brawl ?? self.brawl,
            future: future ?? self.future,
            standard: standard ?? self.standard
        )
    }
    
    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - CardPurchaseUrls
struct CardPurchaseUrls: Codable {
    let cardKingdom: String?
    let cardKingdomFoil: String?
    let cardmarket: String?
    let tcgplayer: String?
    
    enum CodingKeys: String, CodingKey {
        case cardKingdom = "cardKingdom"
        case cardKingdomFoil = "cardKingdomFoil"
        case cardmarket = "cardmarket"
        case tcgplayer = "tcgplayer"
    }
}

// MARK: CardPurchaseUrls convenience initializers and mutators

extension CardPurchaseUrls {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(CardPurchaseUrls.self, from: data)
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
    
    func with(
        cardKingdom: String?? = nil,
        cardKingdomFoil: String?? = nil,
        cardmarket: String?? = nil,
        tcgplayer: String?? = nil
    ) -> CardPurchaseUrls {
        return CardPurchaseUrls(
            cardKingdom: cardKingdom ?? self.cardKingdom,
            cardKingdomFoil: cardKingdomFoil ?? self.cardKingdomFoil,
            cardmarket: cardmarket ?? self.cardmarket,
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

// MARK: - NonCDRuling
struct NonCDRuling: Codable {
    let date: String?
    let text: String?
    
    enum CodingKeys: String, CodingKey {
        case date = "date"
        case text = "text"
    }
}

// MARK: NonCDRuling convenience initializers and mutators

extension NonCDRuling {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(NonCDRuling.self, from: data)
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
    
    func with(
        date: String?? = nil,
        text: String?? = nil
    ) -> NonCDRuling {
        return NonCDRuling(
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

// MARK: - NonCDToken
struct NonCDToken: Codable {
    let artist: String?
    let availability: [String]?
    let borderColor: String?
    let colorIdentity: [String]?
    let colors: [String]?
    let frameVersion: String?
    let hasFoil: Bool?
    let hasNonFoil: Bool?
    let identifiers: TokenIdentifiers?
    let keywords: [String]?
    let layout: String?
    let name: String?
    let number: String?
    let power: String?
    let reverseRelated: [String]?
    let setCode: String?
    let subtypes: [String]?
    let supertypes: [String]?
    let text: String?
    let toughness: String?
    let type: String?
    let types: [String]?
    let uuid: String?
    let watermark: String?
    let isReprint: Bool?
    let convertedManaCost: Int?
    let edhrecRank: Int?
    let flavorText: String?
    let foreignData: [JSONAny]?
    let isPromo: Bool?
    let isStarter: Bool?
    let legalities: TokenLegalities?
    let manaCost: String?
    let printings: [String]?
    let promoTypes: [String]?
    let purchaseUrls: TokenPurchaseUrls?
    let rarity: String?
    let rulings: [NonCDRuling]?
    let isFullArt: Bool?
    let variations: [String]?
    let frameEffects: [String]?
    let leadershipSkills: LeadershipSkills?
    let originalReleaseDate: String?
    
    enum CodingKeys: String, CodingKey {
        case artist = "artist"
        case availability = "availability"
        case borderColor = "borderColor"
        case colorIdentity = "colorIdentity"
        case colors = "colors"
        case frameVersion = "frameVersion"
        case hasFoil = "hasFoil"
        case hasNonFoil = "hasNonFoil"
        case identifiers = "identifiers"
        case keywords = "keywords"
        case layout = "layout"
        case name = "name"
        case number = "number"
        case power = "power"
        case reverseRelated = "reverseRelated"
        case setCode = "setCode"
        case subtypes = "subtypes"
        case supertypes = "supertypes"
        case text = "text"
        case toughness = "toughness"
        case type = "type"
        case types = "types"
        case uuid = "uuid"
        case watermark = "watermark"
        case isReprint = "isReprint"
        case convertedManaCost = "convertedManaCost"
        case edhrecRank = "edhrecRank"
        case flavorText = "flavorText"
        case foreignData = "foreignData"
        case isPromo = "isPromo"
        case isStarter = "isStarter"
        case legalities = "legalities"
        case manaCost = "manaCost"
        case printings = "printings"
        case promoTypes = "promoTypes"
        case purchaseUrls = "purchaseUrls"
        case rarity = "rarity"
        case rulings = "rulings"
        case isFullArt = "isFullArt"
        case variations = "variations"
        case frameEffects = "frameEffects"
        case leadershipSkills = "leadershipSkills"
        case originalReleaseDate = "originalReleaseDate"
    }
}

// MARK: NonCDToken convenience initializers and mutators

extension NonCDToken {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(NonCDToken.self, from: data)
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
    
    func with(
        artist: String?? = nil,
        availability: [String]?? = nil,
        borderColor: String?? = nil,
        colorIdentity: [String]?? = nil,
        colors: [String]?? = nil,
        frameVersion: String?? = nil,
        hasFoil: Bool?? = nil,
        hasNonFoil: Bool?? = nil,
        identifiers: TokenIdentifiers?? = nil,
        keywords: [String]?? = nil,
        layout: String?? = nil,
        name: String?? = nil,
        number: String?? = nil,
        power: String?? = nil,
        reverseRelated: [String]?? = nil,
        setCode: String?? = nil,
        subtypes: [String]?? = nil,
        supertypes: [String]?? = nil,
        text: String?? = nil,
        toughness: String?? = nil,
        type: String?? = nil,
        types: [String]?? = nil,
        uuid: String?? = nil,
        watermark: String?? = nil,
        isReprint: Bool?? = nil,
        convertedManaCost: Int?? = nil,
        edhrecRank: Int?? = nil,
        flavorText: String?? = nil,
        foreignData: [JSONAny]?? = nil,
        isPromo: Bool?? = nil,
        isStarter: Bool?? = nil,
        legalities: TokenLegalities?? = nil,
        manaCost: String?? = nil,
        printings: [String]?? = nil,
        promoTypes: [String]?? = nil,
        purchaseUrls: TokenPurchaseUrls?? = nil,
        rarity: String?? = nil,
        rulings: [NonCDRuling]?? = nil,
        isFullArt: Bool?? = nil,
        variations: [String]?? = nil,
        frameEffects: [String]?? = nil,
        leadershipSkills: LeadershipSkills?? = nil,
        originalReleaseDate: String?? = nil
    ) -> NonCDToken {
        return NonCDToken(
            artist: artist ?? self.artist,
            availability: availability ?? self.availability,
            borderColor: borderColor ?? self.borderColor,
            colorIdentity: colorIdentity ?? self.colorIdentity,
            colors: colors ?? self.colors,
            frameVersion: frameVersion ?? self.frameVersion,
            hasFoil: hasFoil ?? self.hasFoil,
            hasNonFoil: hasNonFoil ?? self.hasNonFoil,
            identifiers: identifiers ?? self.identifiers,
            keywords: keywords ?? self.keywords,
            layout: layout ?? self.layout,
            name: name ?? self.name,
            number: number ?? self.number,
            power: power ?? self.power,
            reverseRelated: reverseRelated ?? self.reverseRelated,
            setCode: setCode ?? self.setCode,
            subtypes: subtypes ?? self.subtypes,
            supertypes: supertypes ?? self.supertypes,
            text: text ?? self.text,
            toughness: toughness ?? self.toughness,
            type: type ?? self.type,
            types: types ?? self.types,
            uuid: uuid ?? self.uuid,
            watermark: watermark ?? self.watermark,
            isReprint: isReprint ?? self.isReprint,
            convertedManaCost: convertedManaCost ?? self.convertedManaCost,
            edhrecRank: edhrecRank ?? self.edhrecRank,
            flavorText: flavorText ?? self.flavorText,
            foreignData: foreignData ?? self.foreignData,
            isPromo: isPromo ?? self.isPromo,
            isStarter: isStarter ?? self.isStarter,
            legalities: legalities ?? self.legalities,
            manaCost: manaCost ?? self.manaCost,
            printings: printings ?? self.printings,
            promoTypes: promoTypes ?? self.promoTypes,
            purchaseUrls: purchaseUrls ?? self.purchaseUrls,
            rarity: rarity ?? self.rarity,
            rulings: rulings ?? self.rulings,
            isFullArt: isFullArt ?? self.isFullArt,
            variations: variations ?? self.variations,
            frameEffects: frameEffects ?? self.frameEffects,
            leadershipSkills: leadershipSkills ?? self.leadershipSkills,
            originalReleaseDate: originalReleaseDate ?? self.originalReleaseDate
        )
    }
    
    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - TokenIdentifiers
struct TokenIdentifiers: Codable {
    let mtgjsonV4ID: String?
    let scryfallID: String?
    let scryfallIllustrationID: String?
    let scryfallOracleID: String?
    let tcgplayerProductID: String?
    let cardKingdomFoilID: String?
    let cardKingdomID: String?
    
    enum CodingKeys: String, CodingKey {
        case mtgjsonV4ID = "mtgjsonV4Id"
        case scryfallID = "scryfallId"
        case scryfallIllustrationID = "scryfallIllustrationId"
        case scryfallOracleID = "scryfallOracleId"
        case tcgplayerProductID = "tcgplayerProductId"
        case cardKingdomFoilID = "cardKingdomFoilId"
        case cardKingdomID = "cardKingdomId"
    }
}

// MARK: TokenIdentifiers convenience initializers and mutators

extension TokenIdentifiers {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(TokenIdentifiers.self, from: data)
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
    
    func with(
        mtgjsonV4ID: String?? = nil,
        scryfallID: String?? = nil,
        scryfallIllustrationID: String?? = nil,
        scryfallOracleID: String?? = nil,
        tcgplayerProductID: String?? = nil,
        cardKingdomFoilID: String?? = nil,
        cardKingdomID: String?? = nil
    ) -> TokenIdentifiers {
        return TokenIdentifiers(
            mtgjsonV4ID: mtgjsonV4ID ?? self.mtgjsonV4ID,
            scryfallID: scryfallID ?? self.scryfallID,
            scryfallIllustrationID: scryfallIllustrationID ?? self.scryfallIllustrationID,
            scryfallOracleID: scryfallOracleID ?? self.scryfallOracleID,
            tcgplayerProductID: tcgplayerProductID ?? self.tcgplayerProductID,
            cardKingdomFoilID: cardKingdomFoilID ?? self.cardKingdomFoilID,
            cardKingdomID: cardKingdomID ?? self.cardKingdomID
        )
    }
    
    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - TokenLegalities
struct TokenLegalities: Codable {
    let commander: String?
    let duel: String?
    let legacy: String?
    let modern: String?
    let pioneer: String?
    let vintage: String?
    let penny: String?
    let historic: String?
    
    enum CodingKeys: String, CodingKey {
        case commander = "commander"
        case duel = "duel"
        case legacy = "legacy"
        case modern = "modern"
        case pioneer = "pioneer"
        case vintage = "vintage"
        case penny = "penny"
        case historic = "historic"
    }
}

// MARK: TokenLegalities convenience initializers and mutators

extension TokenLegalities {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(TokenLegalities.self, from: data)
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
    
    func with(
        commander: String?? = nil,
        duel: String?? = nil,
        legacy: String?? = nil,
        modern: String?? = nil,
        pioneer: String?? = nil,
        vintage: String?? = nil,
        penny: String?? = nil,
        historic: String?? = nil
    ) -> TokenLegalities {
        return TokenLegalities(
            commander: commander ?? self.commander,
            duel: duel ?? self.duel,
            legacy: legacy ?? self.legacy,
            modern: modern ?? self.modern,
            pioneer: pioneer ?? self.pioneer,
            vintage: vintage ?? self.vintage,
            penny: penny ?? self.penny,
            historic: historic ?? self.historic
        )
    }
    
    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - TokenPurchaseUrls
struct TokenPurchaseUrls: Codable {
    let cardKingdom: String?
    let cardKingdomFoil: String?
    let tcgplayer: String?
    
    enum CodingKeys: String, CodingKey {
        case cardKingdom = "cardKingdom"
        case cardKingdomFoil = "cardKingdomFoil"
        case tcgplayer = "tcgplayer"
    }
}

// MARK: TokenPurchaseUrls convenience initializers and mutators

extension TokenPurchaseUrls {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(TokenPurchaseUrls.self, from: data)
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
    
    func with(
        cardKingdom: String?? = nil,
        cardKingdomFoil: String?? = nil,
        tcgplayer: String?? = nil
    ) -> TokenPurchaseUrls {
        return TokenPurchaseUrls(
            cardKingdom: cardKingdom ?? self.cardKingdom,
            cardKingdomFoil: cardKingdomFoil ?? self.cardKingdomFoil,
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

// MARK: - NonCDTranslations
struct NonCDTranslations: Codable {
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
}

// MARK: NonCDTranslations convenience initializers and mutators

extension NonCDTranslations {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(NonCDTranslations.self, from: data)
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
    
    func with(
        chineseSimplified: String?? = nil,
        chineseTraditional: String?? = nil,
        french: String?? = nil,
        german: String?? = nil,
        italian: String?? = nil,
        japanese: String?? = nil,
        korean: String?? = nil,
        portugueseBrazil: String?? = nil,
        russian: String?? = nil,
        spanish: String?? = nil
    ) -> NonCDTranslations {
        return NonCDTranslations(
            chineseSimplified: chineseSimplified ?? self.chineseSimplified,
            chineseTraditional: chineseTraditional ?? self.chineseTraditional,
            french: french ?? self.french,
            german: german ?? self.german,
            italian: italian ?? self.italian,
            japanese: japanese ?? self.japanese,
            korean: korean ?? self.korean,
            portugueseBrazil: portugueseBrazil ?? self.portugueseBrazil,
            russian: russian ?? self.russian,
            spanish: spanish ?? self.spanish
        )
    }
    
    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - NonCDMeta
struct NonCDMeta: Codable {
    let date: String?
    let version: String?
    
    enum CodingKeys: String, CodingKey {
        case date = "date"
        case version = "version"
    }
}

// MARK: NonCDMeta convenience initializers and mutators

extension NonCDMeta {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(NonCDMeta.self, from: data)
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
    
    func with(
        date: String?? = nil,
        version: String?? = nil
    ) -> NonCDMeta {
        return NonCDMeta(
            date: date ?? self.date,
            version: version ?? self.version
        )
    }
    
    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

extension Array where Element == NonCDRuling {
    init(data: Data) throws {
        self = try newJSONDecoder().decode([NonCDRuling].self, from: data)
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
