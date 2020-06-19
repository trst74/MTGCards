// To parse the JSON, add this file to your project and do:
//
//   let sets = try Sets(json)

import Foundation
import CoreData
import UIKit

typealias Sets = [MTGSet]

class MTGSet: NSManagedObject, Codable {
    @NSManaged var baseSetSize: Int16
    @NSManaged var block: String?
    @NSManaged var cards: NSSet
    @NSManaged var code: String?
    @NSManaged var meta: Meta?
    @NSManaged var mtgoCode: String?
    @NSManaged var name: String?
    @NSManaged var releaseDate: String?
    @NSManaged var tcgplayerGroupID: Int16
    @NSManaged var tokens: NSSet
    @NSManaged var totalSetSize: Int16
    @NSManaged var type: String?
    @NSManaged var isFoilOnly: Bool
    @NSManaged var isOnlineOnly: Bool
    private var data: DataClass? = nil
    
    enum CodingKeys: String, CodingKey {

        case meta = "meta"
        case data = "data"
        case mtgoCode = "mtgoCode"
        case name = "name"
        case releaseDate = "releaseDate"
        case tcgplayerGroupID = "tcgplayerGroupId"
        case tokens = "tokens"
        case totalSetSize = "totalSetSize"
        case type = "type"
        case isFoilOnly = "isFoilOnly"
        case isOnlineOnly = "isOnlineOnly"
        case baseSetSize = "baseSetSize"
        case block = "block"
        case cards = "cards"
        case code = "code"
    }
    required convenience init(from decoder: Decoder) throws {
        guard let codingUserInfoKeyManagedObjectContext = CodingUserInfoKey.managedObjectContext,
            let managedObjectContext = decoder.userInfo[codingUserInfoKeyManagedObjectContext] as? NSManagedObjectContext,
            let entity = NSEntityDescription.entity(forEntityName: "MTGSet", in: managedObjectContext) else {
                fatalError("Failed to decode User")
        }
        self.init(entity: entity, insertInto: managedObjectContext)
        
          let container = try decoder.container(keyedBy: CodingKeys.self)
//        if let bss = try container.decodeIfPresent(Int16.self, forKey: .baseSetSize) {
//            self.baseSetSize = bss
//        }
//        self.block = try container.decodeIfPresent(String.self, forKey: .block)
//        if let cards = try container.decodeIfPresent([Card].self, forKey: .cards) {
//            for card in cards {
//                card.set = self
//            }
//            self.cards.addingObjects(from: cards)
//        }
//        self.code = try container.decodeIfPresent(String.self, forKey: .code)
        self.meta = try container.decodeIfPresent(Meta.self, forKey: .meta)
        self.data = try container.decodeIfPresent(DataClass.self, forKey: .data)
//        self.mtgoCode = try container.decodeIfPresent(String.self, forKey: .mtgoCode)
//        self.name = try container.decodeIfPresent(String.self, forKey: .name)
//        self.releaseDate = try container.decodeIfPresent(String.self, forKey: .releaseDate)
//        if let tcgpGID = try container.decodeIfPresent(Int16.self, forKey: .tcgplayerGroupID) {
//            self.tcgplayerGroupID = tcgpGID
//        }
//
//        if let tokens = try container.decodeIfPresent([Token].self, forKey: .tokens) {
//            for token in tokens {
//                token.set = self
//            }
//            self.tokens.addingObjects(from: tokens)
//        }
//        self.totalSetSize = try container.decodeIfPresent(Int16.self, forKey: .totalSetSize)!
//        self.type = try container.decodeIfPresent(String.self, forKey: .type)
//        if let isFoil = try container.decodeIfPresent(Bool.self, forKey: .isFoilOnly) {
//            self.isFoilOnly = isFoil
//        }
//        if let isOnline = try container.decodeIfPresent(Bool.self, forKey: .isOnlineOnly) {
//            self.isOnlineOnly = isOnline
//        }
        self.baseSetSize = Int16(data?.baseSetSize ?? 0)
        self.block = data?.block ?? ""
        //cards
        if let cards = data?.cards{
                    for card in cards {
                        card.set = self
                    }
                    self.cards.addingObjects(from: cards)
                }
        self.code = data?.code ?? ""
        self.mtgoCode = data?.mtgoCode ?? ""
        self.name = data?.name ?? ""
        self.releaseDate = data?.releaseDate ?? ""
        self.tcgplayerGroupID = Int16(data?.tcgplayerGroupID ?? 0)
        //tokens
        if let tokens = data?.tokens {
                    for token in tokens {
                        token.set = self
                    }
                    self.tokens.addingObjects(from: tokens)
                }
        self.totalSetSize = Int16(data?.totalSetSize ?? 0)
        self.type = data?.type ?? ""
        self.isFoilOnly = data?.isFoilOnly ?? false
        self.isOnlineOnly = data?.isOnlineOnly ?? false
        
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(baseSetSize, forKey: .baseSetSize)
        try container.encode(block, forKey: .block)
        //try container.encode(cards, forKey: .cards)
        try container.encode(code, forKey: .code)
        try container.encode(meta, forKey: .meta)
        try container.encode(mtgoCode, forKey: .mtgoCode)
        try container.encode(name, forKey: .name)
        try container.encode(releaseDate, forKey: .releaseDate)
        try container.encode(tcgplayerGroupID, forKey: .tcgplayerGroupID)
        //try container.encode(tokens, forKey: .tokens)
        try container.encode(totalSetSize, forKey: .totalSetSize)
        try container.encode(type, forKey: .type)
        
    }
}
// MARK: Convenience initializers and mutators

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
        encoder.outputFormatting = .prettyPrinted
    }
    return encoder
}

class DataClass: Codable {
    let baseSetSize: Int?
    let block: String?

    let cards: [Card]?
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
    let tokens: [Token]?
    let totalSetSize: Int?
    let translations: Translations?
    let type: String?

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
        case mtgoCode = "mtgoCode"
        case name = "name"
        case releaseDate = "releaseDate"
        case tcgplayerGroupID = "tcgplayerGroupId"
        case tokens = "tokens"
        case totalSetSize = "totalSetSize"
        case translations = "translations"
        case type = "type"
    }

    init(baseSetSize: Int?, block: String?,  cards: [Card]?, code: String?, isFoilOnly: Bool?, isOnlineOnly: Bool?, keyruneCode: String?, mcmID: Int?, mcmName: String?, mtgoCode: String?, name: String?, releaseDate: String?, tcgplayerGroupID: Int?, tokens: [Token]?, totalSetSize: Int?, translations: Translations?, type: String?) {
        self.baseSetSize = baseSetSize
        self.block = block
        self.cards = cards
        self.code = code
        self.isFoilOnly = isFoilOnly
        self.isOnlineOnly = isOnlineOnly
        self.keyruneCode = keyruneCode
        self.mcmID = mcmID
        self.mcmName = mcmName
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

// MARK: DataClass convenience initializers and mutators

extension DataClass {
    convenience init(data: Data) throws {
        let me = try newJSONDecoder().decode(DataClass.self, from: data)
        self.init(baseSetSize: me.baseSetSize, block: me.block, cards: me.cards, code: me.code, isFoilOnly: me.isFoilOnly, isOnlineOnly: me.isOnlineOnly, keyruneCode: me.keyruneCode, mcmID: me.mcmID, mcmName: me.mcmName, mtgoCode: me.mtgoCode, name: me.name, releaseDate: me.releaseDate, tcgplayerGroupID: me.tcgplayerGroupID, tokens: me.tokens, totalSetSize: me.totalSetSize, translations: me.translations, type: me.type)
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
        isFoilOnly: Bool?? = nil,
        isOnlineOnly: Bool?? = nil,
        keyruneCode: String?? = nil,
        mcmID: Int?? = nil,
        mcmName: String?? = nil,
        mtgoCode: String?? = nil,
        name: String?? = nil,
        releaseDate: String?? = nil,
        tcgplayerGroupID: Int?? = nil,
        tokens: [Token]?? = nil,
        totalSetSize: Int?? = nil,
        translations: Translations?? = nil,
        type: String?? = nil
    ) -> DataClass {
        return DataClass(
            baseSetSize: baseSetSize ?? self.baseSetSize,
            block: block ?? self.block,

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
