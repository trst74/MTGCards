// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let setList = try SetList(json)

//
// To read values from URLs:
//
//   let task = URLSession.shared.setListTask(with: url) { setList, response, error in
//     if let setList = setList {
//       ...
//     }
//   }
//   task.resume()

import Foundation

// MARK: - SetList
class SetList: Codable {
    let data: [Datum]
    let meta: SetMeta
    
    init(data: [Datum], meta: SetMeta) {
        self.data = data
        self.meta = meta
    }
}

// MARK: SetList convenience initializers and mutators

extension SetList {
    convenience init(data: Data) throws {
        let me = try newJSONDecoder().decode(SetList.self, from: data)
        self.init(data: me.data, meta: me.meta)
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
        data: [Datum]? = nil,
        meta: SetMeta? = nil
    ) -> SetList {
        return SetList(
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

//
// To read values from URLs:
//
//   let task = URLSession.shared.datumTask(with: url) { datum, response, error in
//     if let datum = datum {
//       ...
//     }
//   }
//   task.resume()

// MARK: - Datum
class Datum: Codable {
    let baseSetSize: Int
    let code, name, releaseDate: String
    let totalSetSize: Int
    let type: TypeEnum
    let parentCode: String?
    let isPartialPreview: Bool?
    
    init(baseSetSize: Int, code: String, name: String, releaseDate: String, totalSetSize: Int, type: TypeEnum, parentCode: String?, isPartialPreview: Bool?) {
        self.baseSetSize = baseSetSize
        self.code = code
        self.name = name
        self.releaseDate = releaseDate
        self.totalSetSize = totalSetSize
        self.type = type
        self.parentCode = parentCode
        self.isPartialPreview = isPartialPreview
    }
}

// MARK: Datum convenience initializers and mutators

extension Datum {
    convenience init(data: Data) throws {
        let me = try newJSONDecoder().decode(Datum.self, from: data)
        self.init(baseSetSize: me.baseSetSize, code: me.code, name: me.name, releaseDate: me.releaseDate, totalSetSize: me.totalSetSize, type: me.type, parentCode: me.parentCode, isPartialPreview: me.isPartialPreview)
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
        baseSetSize: Int? = nil,
        code: String? = nil,
        name: String? = nil,
        releaseDate: String? = nil,
        totalSetSize: Int? = nil,
        type: TypeEnum? = nil,
        parentCode: String?? = nil,
        isPartialPreview: Bool?? = nil
    ) -> Datum {
        return Datum(
            baseSetSize: baseSetSize ?? self.baseSetSize,
            code: code ?? self.code,
            name: name ?? self.name,
            releaseDate: releaseDate ?? self.releaseDate,
            totalSetSize: totalSetSize ?? self.totalSetSize,
            type: type ?? self.type,
            parentCode: parentCode ?? self.parentCode,
            isPartialPreview: isPartialPreview ?? self.isPartialPreview
        )
    }
    
    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

enum TypeEnum: String, Codable {
    case archenemy = "archenemy"
    case box = "box"
    case commander = "commander"
    case core = "core"
    case draftInnovation = "draft_innovation"
    case duelDeck = "duel_deck"
    case expansion = "expansion"
    case fromTheVault = "from_the_vault"
    case funny = "funny"
    case masterpiece = "masterpiece"
    case masters = "masters"
    case memorabilia = "memorabilia"
    case planechase = "planechase"
    case premiumDeck = "premium_deck"
    case promo = "promo"
    case spellbook = "spellbook"
    case starter = "starter"
    case token = "token"
    case treasureChest = "treasure_chest"
    case vanguard = "vanguard"
}

//
// To read values from URLs:
//
//   let task = URLSession.shared.metaTask(with: url) { meta, response, error in
//     if let meta = meta {
//       ...
//     }
//   }
//   task.resume()

// MARK: - Meta
class SetMeta: Codable {
    let date, version: String
    
    init(date: String, version: String) {
        self.date = date
        self.version = version
    }
}

// MARK: Meta convenience initializers and mutators

extension SetMeta {
    convenience init(data: Data) throws {
        let me = try newJSONDecoder().decode(SetMeta.self, from: data)
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
        date: String? = nil,
        version: String? = nil
    ) -> SetMeta {
        return SetMeta(
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

// MARK: - Helper functions for creating encoders and decoders



// MARK: - URLSession response handlers

extension URLSession {
    fileprivate func codableTask<T: Codable>(with url: URL, completionHandler: @escaping (T?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        return self.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                completionHandler(nil, response, error)
                return
            }
            completionHandler(try? newJSONDecoder().decode(T.self, from: data), response, nil)
        }
    }
    
    func setListTask(with url: URL, completionHandler: @escaping (SetList?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        return self.codableTask(with: url, completionHandler: completionHandler)
    }
}
