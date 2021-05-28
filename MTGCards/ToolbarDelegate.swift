//
//  UIToolbarDelegate.swift
//  MTGCards
//
//  Created by Joseph Smith on 4/8/21.
//

import UIKit

class ToolbarDelegate: NSObject {
    
}

#if targetEnvironment(macCatalyst)
extension ToolbarDelegate: NSToolbarDelegate {
    
    func toolbarDefaultItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
        let identifiers: [NSToolbarItem.Identifier] = [
            .toggleSidebar
        ]
        return identifiers
    }
    
}
#endif
