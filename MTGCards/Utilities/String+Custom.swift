//
//  String+Custom.swift
//  MTGCards
//
//  Created by Joseph Smith on 3/7/19.
//  Copyright © 2019 Robotic Snail Software. All rights reserved.
//

import Foundation
import UIKit

extension String {
    mutating func replaceSymbols() -> NSAttributedString {
        var result = NSMutableAttributedString()
        let parts = self.components(separatedBy: "{")
        for part in parts {
            if part.contains("}") {
                let a0 = NSTextAttachment()
                if part.contains("}") {
                    let pieces = part.split(separator: "}")
                    var temp = pieces[0]
                    while let range = temp.range(of: "/") {
                        temp.removeSubrange(range.lowerBound..<range.upperBound)
                    }
                    a0.image = UIImage(named: String(temp))
                    var width = 17
                    if temp == "100" {
                        width = 32
                    } else if temp == "1000000" {
                        width = 86
                    } else if temp == "HR" || temp == "HW" {
                        width = 8
                    }
                    a0.bounds = CGRect(x: 0, y: -3, width: width, height: 17)
                    result.append(NSAttributedString(attachment: a0))
                    if pieces.count > 1 {
                        result.append(NSAttributedString(string: String(pieces[1])))
                    }
                }
            } else {
                let detector = try! NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
                let matches = detector.matches(in: part, options: [], range: NSRange(location: 0, length: part.utf16.count))
                if matches.count > 0 {
                    for match in matches {
                        guard let range = Range(match.range, in: part) else { continue }
                        let url = part[range]
                        let attributedString = NSMutableAttributedString(string: part)
                        attributedString.addAttribute(.link, value: url, range: nsRange(from: range))
                        print(url)
                        result.append(attributedString)
                    }
                } else {
                    result.append(NSAttributedString(string: part))
                }
                
            }
        
        }
        
        return result
    }

    mutating func toDate() -> Date? {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        if let date = formatter.date(from: self) {
            return date
        }
        return nil
    }
}

extension StringProtocol where Index == String.Index {
    func nsRange(from range: Range<Index>) -> NSRange {
        return NSRange(range, in: self)
    }
}
