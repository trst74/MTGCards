//
//  DebugBorder.swift
//  MTGCards
//
//  Created by Joseph Smith on 9/17/20.
//  Copyright © 2020 Robotic Snail Software. All rights reserved.
//

import Foundation
import SwiftUI

struct DebugBorder: ViewModifier {
    let color: Color
    
    func body(content: Content) -> some View {
        content.overlay(Rectangle().stroke(color))
    }
}

extension View {
    func debugBorder(color: Color = .blue) -> some View {
        #if DEBUG
        return self.overlay(Rectangle().stroke(color))
        #else
        return self
        #endif
    }
}



