//
//  SafariActivity.swift
//  MTGCards
//
//  Created by Joseph Smith on 3/7/19.
//  Copyright © 2019 Robotic Snail Software. All rights reserved.
//

import UIKit

final class SafariActivity: UIActivity {
    var url: URL?
    
    override var activityImage: UIImage? {
        return UIImage(named: "safari")!
    }
    
    override var activityTitle: String? {
        return NSLocalizedString("Open in Safari", comment:"")
    }
    
    override func canPerform(withActivityItems activityItems: [Any]) -> Bool {
        for item in activityItems {
            if
                let url = item as? URL,
                UIApplication.shared.canOpenURL(url)
            {
                return true
            }
        }
        return false
    }
    
    override func prepare(withActivityItems activityItems: [Any]) {
        for item in activityItems {
            if
                let url = item as? URL,
                UIApplication.shared.canOpenURL(url)
            {
                self.url = url
            }
        }
    }
    
    override func perform() {
        
        if let url = self.url {
            UIApplication.shared.open(url, options:[:])
        }
        
        activityDidFinish(true)
    }
}
