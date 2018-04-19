//
//  String+Custom.swift
//  MTGCards
//
//  Created by Joseph Smith on 3/19/18.
//  Copyright © 2018 Robotic Snail Software. All rights reserved.
//

import Foundation
import UIKit

extension String
{
    func toDate( dateFormat format  : String) -> NSDate
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone!
        return dateFormatter.date(from: self)! as NSDate
    }
    
}
extension UIColor
{
    struct Identity {
        static let Plains = UIColor(red:1.00, green:0.99, blue:0.85, alpha:1.00)
        static let Islands = UIColor(red:0.71, green:0.87, blue:0.97, alpha:1.00)
        static let Swamps = UIColor(red:0.79, green:0.76, blue:0.75, alpha:1.00)
        static let Mountains = UIColor(red:0.94, green:0.68, blue:0.58, alpha:1.00)
        static let Forests = UIColor(red:0.65, green:0.82, blue:0.69, alpha:1.00)
        static let Artifacts = UIColor(red:0.69, green:0.61, blue:0.49, alpha:1.00)
        static let Lands = UIColor(red:0.87, green:0.80, blue:0.71, alpha:1.00)
    }
}

extension Array where Iterator.Element == String
{
    func formattedDescription() -> String {
        return self.description.replacingOccurrences(of: "[", with: "").replacingOccurrences(of: "]", with: "").replacingOccurrences(of: "\"", with: "")
    }
}
