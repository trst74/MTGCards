// To parse the JSON, add this file to your project and do:
//
//   let mTGSets = try MTGSets(json)

import Foundation

typealias MTGSets = [MTGSet]

class MTGSet: Codable {
    let name: String?
    let code: String?
    let magicCardsInfoCode: String?
    let releaseDate: String?
    let border: String?
    let type: String?
    let block: String?
    let translations: Translations?
    let mkmName: String?
    let mkmID: Int16?
    let cards: [Card]?
    
    enum CodingKeys: String, CodingKey {
        case name = "name"
        case code = "code"
        case magicCardsInfoCode = "magicCardsInfoCode"
        case releaseDate = "releaseDate"
        case border = "border"
        case type = "type"
        case block = "block"
        case translations = "translations"
        case mkmName = "mkm_name"
        case mkmID = "mkm_id"
        case cards = "cards"
    }
    
    init(name: String?, code: String?, magicCardsInfoCode: String?, releaseDate: String?, border: String?, type: String?, block: String?,  translations: Translations?, mkmName: String?, mkmID: Int16?, cards: [Card]?) {
        self.name = name
        self.code = code
        self.magicCardsInfoCode = magicCardsInfoCode
        self.releaseDate = releaseDate
        self.border = border
        self.type = type
        self.block = block
        self.translations = translations
        self.mkmName = mkmName
        self.mkmID = mkmID
        self.cards = cards
    }
}

class Card: Codable {
    let artist: String?
    let cmc: Double?
    let colorIdentity: [String]?
    let colors: [String]?
    let foreignNames: [ForeignName]?
    let id: String?
    let imageName: String?
    let layout: String?
    let manaCost: String?
    let multiverseid: Int?
    let name: String?
    let number: String?
    let mciNumber: String?
    let originalText: String?
    let originalType: String?
    let printings: [String]?
    let rarity: String?
    let rulings: [Ruling]?
    let text: String?
    let type: String?
    let types: [String]?
    let power: String?
    let subtypes: [String]?
    let toughness: String?
    let flavor: String?
    let legalities: [Legality]?
    let supertypes: [String]?
    let loyalty: Int?
    let names: [String]?
    let watermark: String?
    
    enum CodingKeys: String, CodingKey {
        case artist = "artist"
        case cmc = "cmc"
        case colorIdentity = "colorIdentity"
        case colors = "colors"
        case foreignNames = "foreignNames"
        case id = "id"
        case imageName = "imageName"
        case layout = "layout"
        case manaCost = "manaCost"
        case multiverseid = "multiverseid"
        case mciNumber = "mciNumber"
        case name = "name"
        case number = "number"
        case originalText = "originalText"
        case originalType = "originalType"
        case printings = "printings"
        case rarity = "rarity"
        case rulings = "rulings"
        case text = "text"
        case type = "type"
        case types = "types"
        case power = "power"
        case subtypes = "subtypes"
        case toughness = "toughness"
        case flavor = "flavor"
        case legalities = "legalities"
        case supertypes = "supertypes"
        case loyalty = "loyalty"
        case names = "names"
        case watermark = "watermark"
    }
    
    init(artist: String?, cmc: Double?, colorIdentity: [String]?, colors: [String]?, foreignNames: [ForeignName]?, id: String?, imageName: String?, layout: String?, manaCost: String?, mciNumber: String?, multiverseid: Int?, name: String?, number: String?, originalText: String?, originalType: String?, printings: [String]?, rarity: String?, rulings: [Ruling]?, text: String?, type: String?, types: [String]?, power: String?, subtypes: [String]?, toughness: String?, flavor: String?, legalities: [Legality]?, supertypes: [String]?, loyalty: Int?, names: [String]?, watermark: String?) {
        self.artist = artist
        self.cmc = cmc
        self.colorIdentity = colorIdentity
        self.colors = colors
        self.foreignNames = foreignNames
        self.id = id
        self.imageName = imageName
        self.layout = layout
        self.manaCost = manaCost
        self.multiverseid = multiverseid
        self.name = name
        self.number = number
        self.mciNumber = mciNumber
        self.originalText = originalText
        self.originalType = originalType
        self.printings = printings
        self.rarity = rarity
        self.rulings = rulings
        self.text = text
        self.type = type
        self.types = types
        self.power = power
        self.subtypes = subtypes
        self.toughness = toughness
        self.flavor = flavor
        self.legalities = legalities
        self.supertypes = supertypes
        self.loyalty = loyalty
        self.names = names
        self.watermark = watermark
    }
}

class ForeignName: Codable {
    let language: String?
    let name: String?
    let multiverseid: Int?
    
    enum CodingKeys: String, CodingKey {
        case language = "language"
        case name = "name"
        case multiverseid = "multiverseid"
    }
    
    init(language: String?, name: String?, multiverseid: Int?) {
        self.language = language
        self.name = name
        self.multiverseid = multiverseid
    }
}

class Legality: Codable {
    let format: String?
    let legality: String?
    
    enum CodingKeys: String, CodingKey {
        case format = "format"
        case legality = "legality"
    }
    
    init(format: String?, legality: String?) {
        self.format = format
        self.legality = legality
    }
}

class Ruling: Codable {
    let date: String?
    let text: String?
    
    enum CodingKeys: String, CodingKey {
        case date = "date"
        case text = "text"
    }
    
    init(date: String?, text: String?) {
        self.date = date
        self.text = text
    }
}

class Translations: Codable {
    let de: String?
    let fr: String?
    let it: String?
    let es: String?
    let pt: String?
    let ru: String?
    
    enum CodingKeys: String, CodingKey {
        case de = "de"
        case fr = "fr"
        case it = "it"
        case es = "es"
        case pt = "pt"
        case ru = "ru"
    }
    
    init(de: String?, fr: String?, it: String?, es: String?, pt: String?, ru: String?) {
        self.de = de
        self.fr = fr
        self.it = it
        self.es = es
        self.pt = pt
        self.ru = ru
    }
}

// MARK: Convenience initializers

extension MTGSet {
    convenience init(data: Data) throws {
        let me = try JSONDecoder().decode(MTGSet.self, from: data)
        self.init(name: me.name, code: me.code, magicCardsInfoCode: me.magicCardsInfoCode, releaseDate: me.releaseDate, border: me.border, type: me.type, block: me.block, translations: me.translations, mkmName: me.mkmName, mkmID: me.mkmID, cards: me.cards)
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
    
    func jsonData() throws -> Data {
        return try JSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

extension Card {
    convenience init(data: Data) throws {
        let me = try JSONDecoder().decode(Card.self, from: data)
        self.init(artist: me.artist, cmc: me.cmc, colorIdentity: me.colorIdentity, colors: me.colors, foreignNames: me.foreignNames, id: me.id, imageName: me.imageName, layout: me.layout, manaCost: me.manaCost, mciNumber: me.mciNumber, multiverseid: me.multiverseid, name: me.name, number: me.number, originalText: me.originalText, originalType: me.originalType, printings: me.printings, rarity: me.rarity, rulings: me.rulings, text: me.text, type: me.type, types: me.types, power: me.power, subtypes: me.subtypes, toughness: me.toughness, flavor: me.flavor, legalities: me.legalities, supertypes: me.supertypes, loyalty: me.loyalty, names: me.names, watermark: me.watermark)
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
    
    func jsonData() throws -> Data {
        return try JSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

extension ForeignName {
    convenience init(data: Data) throws {
        let me = try JSONDecoder().decode(ForeignName.self, from: data)
        self.init(language: me.language, name: me.name, multiverseid: me.multiverseid)
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
    
    func jsonData() throws -> Data {
        return try JSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

extension Legality {
    convenience init(data: Data) throws {
        let me = try JSONDecoder().decode(Legality.self, from: data)
        self.init(format: me.format, legality: me.legality)
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
    
    func jsonData() throws -> Data {
        return try JSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

extension Ruling {
    convenience init(data: Data) throws {
        let me = try JSONDecoder().decode(Ruling.self, from: data)
        self.init(date: me.date, text: me.text)
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
    
    func jsonData() throws -> Data {
        return try JSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

extension Translations {
    convenience init(data: Data) throws {
        let me = try JSONDecoder().decode(Translations.self, from: data)
        self.init(de: me.de, fr: me.fr, it: me.it, es: me.es, pt: me.pt, ru: me.ru)
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
    
    func jsonData() throws -> Data {
        return try JSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

extension Array where Element == MTGSets.Element {
    init(data: Data) throws {
        self = try JSONDecoder().decode(MTGSets.self, from: data)
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
        return try JSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

