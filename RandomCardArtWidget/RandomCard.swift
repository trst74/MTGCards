// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let randomCard = try RandomCard(json)

//
// To read values from URLs:
//
//   let task = URLSession.shared.randomCardTask(with: url) { randomCard, response, error in
//     if let randomCard = randomCard {
//       ...
//     }
//   }
//   task.resume()

import Foundation

// MARK: - RandomCard
class RandomCard: Codable {
    let object, id, name: String
    let uri, scryfallURI: String
    let layout: String
    let highresImage: Bool
    let imageUris: ImageUris
    
    enum CodingKeys: String, CodingKey {
        case object, id, name, uri
        case scryfallURI = "scryfall_uri"
        case layout
        case highresImage = "highres_image"
        case imageUris = "image_uris"
    }
    
    init(object: String, id: String, name: String, uri: String, scryfallURI: String, layout: String, highresImage: Bool, imageUris: ImageUris) {
        self.object = object
        self.id = id
        self.name = name
        self.uri = uri
        self.scryfallURI = scryfallURI
        self.layout = layout
        self.highresImage = highresImage
        self.imageUris = imageUris
    }
}

// MARK: RandomCard convenience initializers and mutators

extension RandomCard {
    convenience init(data: Data) throws {
        let me = try newJSONDecoder().decode(RandomCard.self, from: data)
        self.init(object: me.object, id: me.id, name: me.name, uri: me.uri, scryfallURI: me.scryfallURI, layout: me.layout, highresImage: me.highresImage, imageUris: me.imageUris)
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
        object: String? = nil,
        id: String? = nil,
        name: String? = nil,
        uri: String? = nil,
        scryfallURI: String? = nil,
        layout: String? = nil,
        highresImage: Bool? = nil,
        imageUris: ImageUris? = nil
    ) -> RandomCard {
        return RandomCard(
            object: object ?? self.object,
            id: id ?? self.id,
            name: name ?? self.name,
            uri: uri ?? self.uri,
            scryfallURI: scryfallURI ?? self.scryfallURI,
            layout: layout ?? self.layout,
            highresImage: highresImage ?? self.highresImage,
            imageUris: imageUris ?? self.imageUris
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
//   let task = URLSession.shared.imageUrisTask(with: url) { imageUris, response, error in
//     if let imageUris = imageUris {
//       ...
//     }
//   }
//   task.resume()

// MARK: - ImageUris
class ImageUris: Codable {
    let small, normal, large: String
    let png: String
    let artCrop, borderCrop: String
    
    enum CodingKeys: String, CodingKey {
        case small, normal, large, png
        case artCrop = "art_crop"
        case borderCrop = "border_crop"
    }
    
    init(small: String, normal: String, large: String, png: String, artCrop: String, borderCrop: String) {
        self.small = small
        self.normal = normal
        self.large = large
        self.png = png
        self.artCrop = artCrop
        self.borderCrop = borderCrop
    }
}

// MARK: ImageUris convenience initializers and mutators

extension ImageUris {
    convenience init(data: Data) throws {
        let me = try newJSONDecoder().decode(ImageUris.self, from: data)
        self.init(small: me.small, normal: me.normal, large: me.large, png: me.png, artCrop: me.artCrop, borderCrop: me.borderCrop)
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
        small: String? = nil,
        normal: String? = nil,
        large: String? = nil,
        png: String? = nil,
        artCrop: String? = nil,
        borderCrop: String? = nil
    ) -> ImageUris {
        return ImageUris(
            small: small ?? self.small,
            normal: normal ?? self.normal,
            large: large ?? self.large,
            png: png ?? self.png,
            artCrop: artCrop ?? self.artCrop,
            borderCrop: borderCrop ?? self.borderCrop
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
    
    func randomCardTask(with url: URL, completionHandler: @escaping (RandomCard?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        return self.codableTask(with: url, completionHandler: completionHandler)
    }
}
