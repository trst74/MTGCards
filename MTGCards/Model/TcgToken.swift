//
//  TcgToken.swift
//  MTGCards
//
//  Created by Joseph Smith on 3/6/19.
//  Copyright © 2019 Robotic Snail Software. All rights reserved.
//

import Foundation

class TcgToken: Codable {
    let accessToken: String
    let tokenType: String
    let expiresIn: Int
    let userName: String
    let issued: String
    let expires: String
    
    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case tokenType = "token_type"
        case expiresIn = "expires_in"
        case userName = "userName"
        case issued = ".issued"
        case expires = ".expires"
    }
    
    init(accessToken: String, tokenType: String, expiresIn: Int, userName: String, issued: String, expires: String) {
        self.accessToken = accessToken
        self.tokenType = tokenType
        self.expiresIn = expiresIn
        self.userName = userName
        self.issued = issued
        self.expires = expires
    }
    func isValid() -> Bool {
        let formatter = DateFormatter()
        formatter.dateFormat = "E, dd MMM yyyy H:mm:ss zzz"
        if let expirationDate = formatter.date(from: expires) {
            let fm = DateFormatter()
            fm.timeZone = TimeZone(identifier: "GMT")
            if let gmt = TimeZone(abbreviation: "GMT"), expirationDate >= Date().convertToTimeZone(initTimeZone: TimeZone.current, timeZone: gmt){
                return true
            }
        }
        return false
        
        
    }
}
extension Date {
    func convertToTimeZone(initTimeZone: TimeZone, timeZone: TimeZone) -> Date {
        let delta = TimeInterval(timeZone.secondsFromGMT() - initTimeZone.secondsFromGMT())
        return addingTimeInterval(delta)
    }
}
