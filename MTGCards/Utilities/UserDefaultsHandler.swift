//
//  UserDefaultsHandler.swift
//  MTGCards
//
//  Created by Joseph Smith on 3/9/19.
//  Copyright © 2019 Robotic Snail Software. All rights reserved.
//

import Foundation

class UserDefaultsHandler {
    static let defaults:UserDefaults = UserDefaults.standard
    
    static let HASOPENED = "hasopenedbefore"
    static let CARDDATADOWNLOADED = "hasdatabeendownloaded"
    
    static func isFirstTimeOpening() -> Bool {
        let result = defaults.bool(forKey: HASOPENED)
        return result
    }
    static func setHasOpened(opened: Bool){
        defaults.set(opened, forKey: HASOPENED)
    }
    static func hasDownloadedCardData() -> Bool {
        let result = defaults.bool(forKey: CARDDATADOWNLOADED)
        return result
    }
    static func setCardDataDownloaded(hasDownloaded: Bool){
          defaults.set(hasDownloaded, forKey: CARDDATADOWNLOADED)
    }
}
