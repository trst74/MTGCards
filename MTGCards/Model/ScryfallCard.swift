//
//  ScryfallCard.swift
//  MTGCards
//
//  Created by Joseph Smith on 2/28/19.
//  Copyright © 2019 Robotic Snail Software. All rights reserved.
//

// To parse the JSON, add this file to your project and do:
//
//   let scryfallCard = try ScryfallCard(json)
//
// To read values from URLs:
//
//   let task = URLSession.shared.scryfallCardTask(with: url) { scryfallCard, response, error in
//     if let scryfallCard = scryfallCard {
//       ...
//     }
//   }
//   task.resume()
// To parse the JSON, add this file to your project and do:
//
//   let scryfallCard = try ScryfallCard(json)
//
// To read values from URLs:
//
//   let task = URLSession.shared.scryfallCardTask(with: url) { scryfallCard, response, error in
//     if let scryfallCard = scryfallCard {
//       ...
//     }
//   }
//   task.resume()

import Foundation

class ScryfallCard: Codable {
    let imageUris: ImageUris?
    let cardFaces: [CardFace]?
    let scryfallUri: String
    
    enum CodingKeys: String, CodingKey {
        case imageUris = "image_uris"
        case cardFaces = "card_faces"
        case scryfallUri = "scryfall_uri"
    }
    
    init(imageUris: ImageUris?, cardFaces: [CardFace]?, scryfallUri: String) {
        self.imageUris = imageUris
        self.cardFaces = cardFaces
        self.scryfallUri = scryfallUri
    }
}

class CardFace: Codable {
    let artist: String?
    let colors: [String]?
    let flavorText: String?
    let illustrationID: String?
    let imageUris: ImageUris?
    let manaCost: String?
    let name: String?
    let object: String?
    let oracleText: String?
    let typeLine: String?
    
    enum CodingKeys: String, CodingKey {
        case artist = "artist"
        case colors = "colors"
        case flavorText = "flavor_text"
        case illustrationID = "illustration_id"
        case imageUris = "image_uris"
        case manaCost = "mana_cost"
        case name = "name"
        case object = "object"
        case oracleText = "oracle_text"
        case typeLine = "type_line"
    }
    
    init(artist: String?, colors: [String]?, flavorText: String?, illustrationID: String?, imageUris: ImageUris?, manaCost: String?, name: String?, object: String?, oracleText: String?, typeLine: String?) {
        self.artist = artist
        self.colors = colors
        self.flavorText = flavorText
        self.illustrationID = illustrationID
        self.imageUris = imageUris
        self.manaCost = manaCost
        self.name = name
        self.object = object
        self.oracleText = oracleText
        self.typeLine = typeLine
    }
}

class ImageUris: Codable {
    let small: String
    let normal: String
    let large: String
    let png: String
    let artCrop: String
    let borderCrop: String
    
    enum CodingKeys: String, CodingKey {
        case small = "small"
        case normal = "normal"
        case large = "large"
        case png = "png"
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

// MARK: Convenience initializers and mutators

extension ScryfallCard {
    convenience init(data: Data) throws {
        let me = try newJSONDecoder().decode(ScryfallCard.self, from: data)
        self.init(imageUris: me.imageUris, cardFaces: me.cardFaces, scryfallUri: me.scryfallUri)
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
        imageUris: ImageUris?? = nil,
        cardFaces: [CardFace]?? = nil
        ) -> ScryfallCard {
        return ScryfallCard(
            imageUris: imageUris ?? self.imageUris,
            cardFaces: cardFaces ?? self.cardFaces,
            scryfallUri: scryfallUri ?? self.scryfallUri
        )
    }
    
    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

extension CardFace {
    convenience init(data: Data) throws {
        let me = try newJSONDecoder().decode(CardFace.self, from: data)
        self.init(artist: me.artist, colors: me.colors, flavorText: me.flavorText, illustrationID: me.illustrationID, imageUris: me.imageUris, manaCost: me.manaCost, name: me.name, object: me.object, oracleText: me.oracleText, typeLine: me.typeLine)
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
        artist: String? = nil,
        colors: [String]? = nil,
        flavorText: String?? = nil,
        illustrationID: String? = nil,
        imageUris: ImageUris? = nil,
        manaCost: String? = nil,
        name: String? = nil,
        object: String? = nil,
        oracleText: String? = nil,
        typeLine: String? = nil
        ) -> CardFace {
        return CardFace(
            artist: artist ?? self.artist,
            colors: colors ?? self.colors,
            flavorText: flavorText ?? self.flavorText,
            illustrationID: illustrationID ?? self.illustrationID,
            imageUris: imageUris ?? self.imageUris,
            manaCost: manaCost ?? self.manaCost,
            name: name ?? self.name,
            object: object ?? self.object,
            oracleText: oracleText ?? self.oracleText,
            typeLine: typeLine ?? self.typeLine
        )
    }
    
    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

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
    
    func scryfallCardTask(with url: URL, completionHandler: @escaping (ScryfallCard?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        return self.codableTask(with: url, completionHandler: completionHandler)
    }
}
