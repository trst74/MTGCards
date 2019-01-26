//
//  SetList.swift
//  MTGCards
//
//  Created by Joseph Smith on 1/17/19.
//  Copyright © 2019 Robotic Snail Software. All rights reserved.
//

// To parse the JSON, add this file to your project and do:
//
//   let setList = try SetList(json)

import Foundation

typealias SetList = [SetListElement]

class SetListElement: Codable {
    let code: String?
    let name: String?
    let releaseDate: String?
    
    enum CodingKeys: String, CodingKey {
        case code = "code"
        case name = "name"
        case releaseDate = "releaseDate"
    }
    
    init(code: String?, name: String?, releaseDate: String?) {
        self.code = code
        self.name = name
        self.releaseDate = releaseDate
    }
}

// MARK: Convenience initializers and mutators

extension SetListElement {
    convenience init(data: Data) throws {
        let me = try newJSONDecoder().decode(SetListElement.self, from: data)
        self.init(code: me.code, name: me.name, releaseDate: me.releaseDate)
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
        code: String?? = nil,
        name: String?? = nil,
        releaseDate: String?? = nil
        ) -> SetListElement {
        return SetListElement(
            code: code ?? self.code,
            name: name ?? self.name,
            releaseDate: releaseDate ?? self.releaseDate
        )
    }
    
    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

extension Array where Element == SetList.Element {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(SetList.self, from: data)
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

