// To parse the JSON, add this file to your project and do:
//
//   let sets = try Sets(json)

import Foundation
import CoreData
import UIKit

typealias Sets = [Set]

class Set: NSManagedObject, Codable {
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
    required convenience init(from decoder: Decoder) throws {
        guard let managedObjectContext = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext,
            let entity = NSEntityDescription.entity(forEntityName: "Set", in: managedObjectContext) else {
                fatalError("Failed to decode Set")
        }
        
        self.init(entity: entity, insertInto: managedObjectContext)
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        if let bss = try container.decodeIfPresent(Int16.self, forKey: .baseSetSize) {
                  self.baseSetSize = bss
        }
        self.block = try container.decodeIfPresent(String.self, forKey: .block)
        if let cards = try container.decodeIfPresent([Card].self, forKey: .cards) {
            for card in cards {
                card.set = self
            }
               self.cards.addingObjects(from: cards)
        }
        self.code = try container.decodeIfPresent(String.self, forKey: .code)
        self.meta = try container.decodeIfPresent(Meta.self, forKey: .meta)
        self.mtgoCode = try container.decodeIfPresent(String.self, forKey: .mtgoCode)
        self.name = try container.decodeIfPresent(String.self, forKey: .name)
        self.releaseDate = try container.decodeIfPresent(String.self, forKey: .releaseDate)
        if let tcgpGID = try container.decodeIfPresent(Int16.self, forKey: .tcgplayerGroupID) {
                    self.tcgplayerGroupID = tcgpGID
        }

        if let tokens = try container.decodeIfPresent([Token].self, forKey: .tokens){
                    self.tokens.addingObjects(from: tokens)
        }
        self.totalSetSize = try container.decodeIfPresent(Int16.self, forKey: .totalSetSize)!
        self.type = try container.decodeIfPresent(String.self, forKey: .type)
        
        
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
    //    init(baseSetSize: Int?, block: String?, cards: [Card]?, code: String?, meta: Meta?, mtgoCode: String?, name: String?, releaseDate: String?, tcgplayerGroupID: Int?, tokens: [Token]?, totalSetSize: Int?, type: String?) {
    //        self.baseSetSize = baseSetSize
    //        self.block = block
    //        self.cards = cards
    //        self.code = code
    //        self.meta = meta
    //        self.mtgoCode = mtgoCode
    //        self.name = name
    //        self.releaseDate = releaseDate
    //        self.tcgplayerGroupID = tcgplayerGroupID
    //        self.tokens = tokens
    //        self.totalSetSize = totalSetSize
    //        self.type = type
    //    }
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
