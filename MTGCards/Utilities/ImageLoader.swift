//
//  ImageLoader.swift
//  MTGCards
//
//  Created by Joseph Smith on 9/9/20.
//  Copyright © 2020 Robotic Snail Software. All rights reserved.
//

import Foundation
import SwiftUI
import Combine

class ImageLoader: ObservableObject {
    
    var downloadedImage: UIImage?
    let objectWillChange = PassthroughSubject<ImageLoader?, Never>()
    
    func load(url: String, key: String) {
        
        guard let imageURL = URL(string: url) else {
            fatalError("ImageURL is not correct!")
        }
        
        URLSession.shared.dataTask(with: imageURL) { data, response, error in
            
            guard let data = data, error == nil else {
                DispatchQueue.main.async {
                    self.objectWillChange.send(nil)
                }
                return
            }
            
            self.downloadedImage = UIImage(data: data)
            if let dli = self.downloadedImage {
                self.saveImage(image: dli, Key: key)
            }
            DispatchQueue.main.async {
                self.objectWillChange.send(self)
            }
            
        }.resume()
        
    }
    func load(url: String) {
        
        guard let imageURL = URL(string: url) else {
            fatalError("ImageURL is not correct!")
        }
        
        URLSession.shared.dataTask(with: imageURL) { data, response, error in
            
            guard let data = data, error == nil else {
                DispatchQueue.main.async {
                    self.objectWillChange.send(nil)
                }
                return
            }
            
            self.downloadedImage = UIImage(data: data)
      
            DispatchQueue.main.async {
                self.objectWillChange.send(self)
            }
            
        }.resume()
        
    }
    func saveImage(image: UIImage, Key: String) {
        if let data = image.pngData() {
            let filename = getDocumentsDirectory().appendingPathComponent("\(Key).png")
            try? data.write(to: filename)
        }
    }
    private func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}
