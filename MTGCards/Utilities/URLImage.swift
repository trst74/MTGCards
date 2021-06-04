//
//  URLImage.swift
//  MTGCards
//
//  Created by Joseph Smith on 9/9/20.
//  Copyright © 2020 Robotic Snail Software. All rights reserved.
//

import Foundation
import SwiftUI

struct URLImage: View {
    
    @ObservedObject private var imageLoader = ImageLoader()
    
    var placeholder: Image
    
    init(url: String, placeholder: Image = Image(systemName: "photo"), key: String) {
        self.placeholder = placeholder
        self.imageLoader.load(url: url, key: key)
    }
    init(url: String, placeholder: Image = Image(systemName: "photo")) {
        self.placeholder = placeholder
        self.imageLoader.load(url: url)
    }
    var body: some View {
        if let uiImage = self.imageLoader.downloadedImage {
            return AnyView(Image(uiImage: uiImage).resizable().aspectRatio(contentMode: .fit).cornerRadius(20).frame(maxWidth: .infinity))
        } else {
            return AnyView(EmptyView())
        }
    }
    
}

