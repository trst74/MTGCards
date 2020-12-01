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
    static let SELECTEDCARDIMAGEQUALITY = "selectedcardimagequality"
    static let EXCLUDEONLINEONLYCARDS = "excludeonlineonly"
    static let LASTTIMEUPDATED = "lasttimeupdated"
    
    static func isFirstTimeOpening() -> Bool {
        let result = defaults.bool(forKey: HASOPENED)
        return !result
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
    static func selectedCardImageQuality() -> String {
        return defaults.string(forKey: SELECTEDCARDIMAGEQUALITY) ?? "high"
    }
    static func setSelectedCardImageQuality( quality: String){
        defaults.set(quality, forKey: SELECTEDCARDIMAGEQUALITY)
    }
    static func setExcludeOnlineOnly(exclude: Bool){
        defaults.set(exclude, forKey: EXCLUDEONLINEONLYCARDS)
    }
    static func areOnlineOnlyCardsExcluded() -> Bool {
        return defaults.bool(forKey: EXCLUDEONLINEONLYCARDS)
    }
    static func getLastTimeUpdated() -> Date? {
        if let temp = defaults.object(forKey: LASTTIMEUPDATED) as? Date {
            return temp
        }
        return Date(timeIntervalSince1970: 0)
    }
    static func setLastTimeUpdated(updateDate: Date) {
        defaults.setValue(updateDate, forKey: LASTTIMEUPDATED)
    }
}
