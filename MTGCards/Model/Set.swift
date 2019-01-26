// To parse the JSON, add this file to your project and do:
//
//   let sets = try Sets(json)

import Foundation
import CoreData
import UIKit

typealias Sets = [Set]

class Set: Codable {
    let baseSetSize: Int?
    let block: String?
    let cards: [Card]?
    let code: String?
    let meta: Meta?
    let mtgoCode: String?
    let name: String?
    let releaseDate: String?
    let tcgplayerGroupID: Int?
    let tokens: [Token]?
    let totalSetSize: Int?
    let type: String?
    
    enum CodingKeys: String, CodingKey {
        case baseSetSize = "baseSetSize"
        case block = "block"
        case cards = "cards"
        case code = "code"
        case meta = "meta"
        case mtgoCode = "mtgoCode"
        case name = "name"
        case releaseDate = "releaseDate"
        case tcgplayerGroupID = "tcgplayerGroupId"
        case tokens = "tokens"
        case totalSetSize = "totalSetSize"
        case type = "type"
    }
    
    init(baseSetSize: Int?, block: String?, cards: [Card]?, code: String?, meta: Meta?, mtgoCode: String?, name: String?, releaseDate: String?, tcgplayerGroupID: Int?, tokens: [Token]?, totalSetSize: Int?, type: String?) {
        self.baseSetSize = baseSetSize
        self.block = block
        self.cards = cards
        self.code = code
        self.meta = meta
        self.mtgoCode = mtgoCode
        self.name = name
        self.releaseDate = releaseDate
        self.tcgplayerGroupID = tcgplayerGroupID
        self.tokens = tokens
        self.totalSetSize = totalSetSize
        self.type = type
    }
}



class ForeignDatum: Codable {
    let flavorText: String?
    let language: String?
    let multiverseID: Int?
    let name: String?
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
    
    init(flavorText: String?, language: String?, multiverseID: Int?, name: String?, text: String?, type: String?) {
        self.flavorText = flavorText
        self.language = language
        self.multiverseID = multiverseID
        self.name = name
        self.text = text
        self.type = type
    }
}

class Legalities: Codable {
    let the1V1: String?
    let brawl: String?
    let commander: String?
    let duel: String?
    let frontier: String?
    let future: String?
    let legacy: String?
    let modern: String?
    let pauper: String?
    let penny: String?
    let standard: String?
    let vintage: String?
    
    enum CodingKeys: String, CodingKey {
        case the1V1 = "1v1"
        case brawl = "brawl"
        case commander = "commander"
        case duel = "duel"
        case frontier = "frontier"
        case future = "future"
        case legacy = "legacy"
        case modern = "modern"
        case pauper = "pauper"
        case penny = "penny"
        case standard = "standard"
        case vintage = "vintage"
    }
    
    init(the1V1: String?, brawl: String?, commander: String?, duel: String?, frontier: String?, future: String?, legacy: String?, modern: String?, pauper: String?, penny: String?, standard: String?, vintage: String?) {
        self.the1V1 = the1V1
        self.brawl = brawl
        self.commander = commander
        self.duel = duel
        self.frontier = frontier
        self.future = future
        self.legacy = legacy
        self.modern = modern
        self.pauper = pauper
        self.penny = penny
        self.standard = standard
        self.vintage = vintage
    }
}
public extension CodingUserInfoKey {
    // Helper property to retrieve the Core Data managed object context
    static let managedObjectContext = CodingUserInfoKey(rawValue: "managedObjectContext")
}

class Meta: Codable {
    let date: String?
    let version: String?
    
    enum CodingKeys: String, CodingKey {
        case date = "date"
        case version = "version"
    }
    
    init(date: String?, version: String?) {
        self.date = date
        self.version = version
    }
}

class Token: Codable {
    let artist: String?
    let borderColor: String?
    let colorIdentity: [String]?
    let colors: [String]?
    let name: String?
    let number: String?
    let power: String?
    let reverseRelated: [String]?
    let scryfallID: String?
    let text: String?
    let toughness: String?
    let type: String?
    let uuid: String?
    let watermark: String?
    
    enum CodingKeys: String, CodingKey {
        case artist = "artist"
        case borderColor = "borderColor"
        case colorIdentity = "colorIdentity"
        case colors = "colors"
        case name = "name"
        case number = "number"
        case power = "power"
        case reverseRelated = "reverseRelated"
        case scryfallID = "scryfallId"
        case text = "text"
        case toughness = "toughness"
        case type = "type"
        case uuid = "uuid"
        case watermark = "watermark"
    }
    
    init(artist: String?, borderColor: String?, colorIdentity: [String]?, colors: [String]?, name: String?, number: String?, power: String?, reverseRelated: [String]?, scryfallID: String?, text: String?, toughness: String?, type: String?, uuid: String?, watermark: String?) {
        self.artist = artist
        self.borderColor = borderColor
        self.colorIdentity = colorIdentity
        self.colors = colors
        self.name = name
        self.number = number
        self.power = power
        self.reverseRelated = reverseRelated
        self.scryfallID = scryfallID
        self.text = text
        self.toughness = toughness
        self.type = type
        self.uuid = uuid
        self.watermark = watermark
    }
}

// MARK: Convenience initializers and mutators

extension Set {
    convenience init(data: Data) throws {
        let me = try newJSONDecoder().decode(Set.self, from: data)
        self.init(baseSetSize: me.baseSetSize, block: me.block, cards: me.cards, code: me.code, meta: me.meta, mtgoCode: me.mtgoCode, name: me.name, releaseDate: me.releaseDate, tcgplayerGroupID: me.tcgplayerGroupID, tokens: me.tokens, totalSetSize: me.totalSetSize, type: me.type)
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
        baseSetSize: Int?? = nil,
        block: String?? = nil,
        cards: [Card]?? = nil,
        code: String?? = nil,
        meta: Meta?? = nil,
        mtgoCode: String?? = nil,
        name: String?? = nil,
        releaseDate: String?? = nil,
        tcgplayerGroupID: Int?? = nil,
        tokens: [Token]?? = nil,
        totalSetSize: Int?? = nil,
        type: String?? = nil
        ) -> Set {
        return Set(
            baseSetSize: baseSetSize ?? self.baseSetSize,
            block: block ?? self.block,
            cards: cards ?? self.cards,
            code: code ?? self.code,
            meta: meta ?? self.meta,
            mtgoCode: mtgoCode ?? self.mtgoCode,
            name: name ?? self.name,
            releaseDate: releaseDate ?? self.releaseDate,
            tcgplayerGroupID: tcgplayerGroupID ?? self.tcgplayerGroupID,
            tokens: tokens ?? self.tokens,
            totalSetSize: totalSetSize ?? self.totalSetSize,
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


extension ForeignDatum {
    convenience init(data: Data) throws {
        let me = try newJSONDecoder().decode(ForeignDatum.self, from: data)
        self.init(flavorText: me.flavorText, language: me.language, multiverseID: me.multiverseID, name: me.name, text: me.text, type: me.type)
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
        flavorText: String?? = nil,
        language: String?? = nil,
        multiverseID: Int?? = nil,
        name: String?? = nil,
        text: String?? = nil,
        type: String?? = nil
        ) -> ForeignDatum {
        return ForeignDatum(
            flavorText: flavorText ?? self.flavorText,
            language: language ?? self.language,
            multiverseID: multiverseID ?? self.multiverseID,
            name: name ?? self.name,
            text: text ?? self.text,
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

extension Legalities {
    convenience init(data: Data) throws {
        let me = try newJSONDecoder().decode(Legalities.self, from: data)
        self.init(the1V1: me.the1V1, brawl: me.brawl, commander: me.commander, duel: me.duel, frontier: me.frontier, future: me.future, legacy: me.legacy, modern: me.modern, pauper: me.pauper, penny: me.penny, standard: me.standard, vintage: me.vintage)
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
        the1V1: String?? = nil,
        brawl: String?? = nil,
        commander: String?? = nil,
        duel: String?? = nil,
        frontier: String?? = nil,
        future: String?? = nil,
        legacy: String?? = nil,
        modern: String?? = nil,
        pauper: String?? = nil,
        penny: String?? = nil,
        standard: String?? = nil,
        vintage: String?? = nil
        ) -> Legalities {
        return Legalities(
            the1V1: the1V1 ?? self.the1V1,
            brawl: brawl ?? self.brawl,
            commander: commander ?? self.commander,
            duel: duel ?? self.duel,
            frontier: frontier ?? self.frontier,
            future: future ?? self.future,
            legacy: legacy ?? self.legacy,
            modern: modern ?? self.modern,
            pauper: pauper ?? self.pauper,
            penny: penny ?? self.penny,
            standard: standard ?? self.standard,
            vintage: vintage ?? self.vintage
        )
    }
    
    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

extension Meta {
    convenience init(data: Data) throws {
        let me = try newJSONDecoder().decode(Meta.self, from: data)
        self.init(date: me.date, version: me.version)
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
        date: String?? = nil,
        version: String?? = nil
        ) -> Meta {
        return Meta(
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

extension Token {
    convenience init(data: Data) throws {
        let me = try newJSONDecoder().decode(Token.self, from: data)
        self.init(artist: me.artist, borderColor: me.borderColor, colorIdentity: me.colorIdentity, colors: me.colors, name: me.name, number: me.number, power: me.power, reverseRelated: me.reverseRelated, scryfallID: me.scryfallID, text: me.text, toughness: me.toughness, type: me.type, uuid: me.uuid, watermark: me.watermark)
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
        name: String?? = nil,
        number: String?? = nil,
        power: String?? = nil,
        reverseRelated: [String]?? = nil,
        scryfallID: String?? = nil,
        text: String?? = nil,
        toughness: String?? = nil,
        type: String?? = nil,
        uuid: String?? = nil,
        watermark: String?? = nil
        ) -> Token {
        return Token(
            artist: artist ?? self.artist,
            borderColor: borderColor ?? self.borderColor,
            colorIdentity: colorIdentity ?? self.colorIdentity,
            colors: colors ?? self.colors,
            name: name ?? self.name,
            number: number ?? self.number,
            power: power ?? self.power,
            reverseRelated: reverseRelated ?? self.reverseRelated,
            scryfallID: scryfallID ?? self.scryfallID,
            text: text ?? self.text,
            toughness: toughness ?? self.toughness,
            type: type ?? self.type,
            uuid: uuid ?? self.uuid,
            watermark: watermark ?? self.watermark
        )
    }
    
    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

extension Array where Element == Sets.Element {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(Sets.self, from: data)
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

func newJSONDecoder() -> JSONDecoder {
    let decoder = JSONDecoder()
    if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
        decoder.dateDecodingStrategy = .iso8601
    }
    return decoder
}

func newJSONEncoder() -> JSONEncoder {
    let encoder = JSONEncoder()
    if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
        encoder.dateEncodingStrategy = .iso8601
    }
    return encoder
}
