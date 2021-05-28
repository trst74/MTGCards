
import Foundation

class Backup: Codable {
    let collection: [String]
    let wishlist: [String]
    let deckBackups: [DeckBackup]
    
    enum CodingKeys: String, CodingKey {
        case collection = "collection"
        case wishlist = "wishlist"
        case deckBackups = "deckBackups"
    }
    
    init(collection: [String], wishlist: [String], deckBackups: [DeckBackup]) {
        self.collection = collection
        self.wishlist = wishlist
        self.deckBackups = deckBackups
    }
}

class DeckBackup: Codable {
    let name: String
    let format: String
    let cardBackups: [CardBackup]
    
    enum CodingKeys: String, CodingKey {
        case name = "name"
        case format = "format"
        case cardBackups = "cardBackups"
    }
    
    init(name: String, format: String, cardBackups: [CardBackup]) {
        self.name = name
        self.format = format
        self.cardBackups = cardBackups
    }
}

class CardBackup: Codable {
    let uuid: String
    let quantity: Int
    let isCommander: Bool
    let isSideboard: Bool
    
    enum CodingKeys: String, CodingKey {
        case uuid = "uuid"
        case quantity = "quantity"
        case isCommander = "isCommander"
        case isSideboard = "isSideboard"
    }
    
    init(uuid: String, quantity: Int, isCommander: Bool, isSideboard: Bool) {
        self.uuid = uuid
        self.quantity = quantity
        self.isCommander = isCommander
        self.isSideboard = isSideboard
    }
}

// MARK: Convenience initializers and mutators

extension Backup {
    convenience init(data: Data) throws {
        let me = try newJSONDecoder().decode(Backup.self, from: data)
        self.init(collection: me.collection, wishlist: me.wishlist, deckBackups: me.deckBackups)
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
        collection: [String]? = nil,
        wishlist: [String]? = nil,
        deckBackups: [DeckBackup]? = nil
        ) -> Backup {
        return Backup(
            collection: collection ?? self.collection,
            wishlist: wishlist ?? self.wishlist,
            deckBackups: deckBackups ?? self.deckBackups
        )
    }
    
    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

extension DeckBackup {
    convenience init(data: Data) throws {
        let me = try newJSONDecoder().decode(DeckBackup.self, from: data)
        self.init(name: me.name, format: me.format, cardBackups: me.cardBackups)
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
        name: String? = nil,
        format: String? = nil,
        cardBackups: [CardBackup]? = nil
        ) -> DeckBackup {
        return DeckBackup(
            name: name ?? self.name,
            format: format ?? self.format,
            cardBackups: cardBackups ?? self.cardBackups
        )
    }
    
    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

extension CardBackup {
    convenience init(data: Data) throws {
        let me = try newJSONDecoder().decode(CardBackup.self, from: data)
        self.init(uuid: me.uuid, quantity: me.quantity, isCommander: me.isCommander, isSideboard: me.isSideboard)
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
        uuid: String? = nil,
        quantity: Int? = nil,
        isCommander: Bool? = nil,
        isSideboard: Bool? = nil
        ) -> CardBackup {
        return CardBackup(
            uuid: uuid ?? self.uuid,
            quantity: quantity ?? self.quantity,
            isCommander: isCommander ?? self.isCommander,
            isSideboard: isSideboard ?? self.isSideboard
        )
    }
    
    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}
