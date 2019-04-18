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

typealias SetList = [SetListElement]

class SetListElement: Codable {
    let code: String
    let meta: SetMeta
    let name: String
    let releaseDate: String
    let type: String
    let parentCode: String?
    
    enum CodingKeys: String, CodingKey {
        case code = "code"
        case meta = "meta"
        case name = "name"
        case releaseDate = "releaseDate"
        case type = "type"
        case parentCode = "parentCode"
    }
    
    init(code: String, meta: SetMeta, name: String, releaseDate: String, type: String, parentCode: String?) {
        self.code = code
        self.meta = meta
        self.name = name
        self.releaseDate = releaseDate
        self.type = type
        self.parentCode = parentCode
    }
}

class SetMeta: Codable {
    let date: String
    let version: String
    
    enum CodingKeys: String, CodingKey {
        case date = "date"
        case version = "version"
    }
    
    init(date: String, version: String) {
        self.date = date
        self.version = version
    }
}

// MARK: Convenience initializers and mutators

extension SetListElement {
    convenience init(data: Data) throws {
        let me = try newJSONDecoder().decode(SetListElement.self, from: data)
        self.init(code: me.code, meta: me.meta, name: me.name, releaseDate: me.releaseDate, type: me.type, parentCode: me.parentCode)
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
        code: String? = nil,
        meta: SetMeta? = nil,
        name: String? = nil,
        releaseDate: String? = nil,
        type: String? = nil,
        parentCode: String?? = nil
        ) -> SetListElement {
        return SetListElement(
            code: code ?? self.code,
            meta: meta ?? self.meta,
            name: name ?? self.name,
            releaseDate: releaseDate ?? self.releaseDate,
            type: type ?? self.type,
            parentCode: parentCode ?? self.parentCode
        )
    }
    
    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

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
