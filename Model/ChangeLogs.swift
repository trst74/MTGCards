//
//  ChangeLogs.swift
//  MTGCards
//
//  Created by Joseph Smith on 4/25/18.
//  Copyright © 2018 Robotic Snail Software. All rights reserved.
//

// To parse the JSON, add this file to your project and do:
//
//   let changeLogs = try ChangeLogs(json)

import Foundation

typealias ChangeLogs = [ChangeLog]

class ChangeLog: Codable {
    let version: String?
    let when: String?
    let changes: [String]?
    let updatedSetFiles: [String]?
    let whenAtom: String?
    let whenSiteMap: String?
    let uniqueID: Int?
    let atomContent: String?
    let newSetFiles: [String]?
    let removedSetFiles: [String]?
    
    enum CodingKeys: String, CodingKey {
        case version = "version"
        case when = "when"
        case changes = "changes"
        case updatedSetFiles = "updatedSetFiles"
        case whenAtom = "whenAtom"
        case whenSiteMap = "whenSiteMap"
        case uniqueID = "uniqueID"
        case atomContent = "atomContent"
        case newSetFiles = "newSetFiles"
        case removedSetFiles = "removedSetFiles"
    }
    
    init(version: String?, when: String?, changes: [String]?, updatedSetFiles: [String]?, whenAtom: String?, whenSiteMap: String?, uniqueID: Int?, atomContent: String?, newSetFiles: [String]?, removedSetFiles: [String]?) {
        self.version = version
        self.when = when
        self.changes = changes
        self.updatedSetFiles = updatedSetFiles
        self.whenAtom = whenAtom
        self.whenSiteMap = whenSiteMap
        self.uniqueID = uniqueID
        self.atomContent = atomContent
        self.newSetFiles = newSetFiles
        self.removedSetFiles = removedSetFiles
    }
}

// MARK: Convenience initializers

extension ChangeLog {
    convenience init(data: Data) throws {
        let me = try JSONDecoder().decode(ChangeLog.self, from: data)
        self.init(version: me.version, when: me.when, changes: me.changes, updatedSetFiles: me.updatedSetFiles, whenAtom: me.whenAtom, whenSiteMap: me.whenSiteMap, uniqueID: me.uniqueID, atomContent: me.atomContent, newSetFiles: me.newSetFiles, removedSetFiles: me.removedSetFiles)
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

extension Array where Element == ChangeLogs.Element {
    init(data: Data) throws {
        self = try JSONDecoder().decode(ChangeLogs.self, from: data)
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
