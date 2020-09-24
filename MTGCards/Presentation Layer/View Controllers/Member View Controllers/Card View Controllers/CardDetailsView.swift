//
//  CardDetailsView.swift
//  MTGCards
//
//  Created by Joseph Smith on 9/9/20.
//  Copyright © 2020 Robotic Snail Software. All rights reserved.
//

import SwiftUI

struct CardDetailsView: View {
    var card: Card
    var reserved: Bool {
        get {
            if card.isReserved {
                return true
            }
            return false
        }
    }
    var body: some View {
        VStack{
            replaceSymbols(text: card.manaCost ?? "")
                .padding(.init(top: 2.0, leading: 0, bottom: 2.0, trailing: 0))
            Text(card.type ?? "Failure")
                .padding(.init(top: 2.0, leading: 0, bottom: 2.0, trailing: 0))
            (Text(card.set.name ?? "Failure").font(.system(size: 10.0, weight: .thin)) + Text(" - ").font(.system(size: 10.0, weight: .thin)) + Text(card.rarity?.capitalized ?? "Failure").font(.system(size: 10.0, weight: .thin)))
                .padding(.init(top: 2.0, leading: 0, bottom: 2.0, trailing: 0))
            replaceSymbols(text: card.text ?? "")
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.init(top: 2.0, leading: 0, bottom: 2.0, trailing: 0))
            HStack{
                Text(card.artist ?? "Failure").italic()
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                if card.power != nil && card.toughness != nil {
                    Text("\(card.power!)/\(card.toughness!)")
                        .frame(maxWidth: .infinity, alignment: .trailing)
                }
                
                
            }
            HStack {
                if card.isReserved {
                    Text("Reserved")
                }
            }
            
            .padding(.init(top: 2.0, leading: 4.0, bottom: 2.0, trailing: 0))
        }
        .padding(.init(top: 8.0, leading: 16.0, bottom: 8.0, trailing: 16.0))
        .background(Color(UIColor.secondarySystemBackground))
        .cornerRadius(10)
    }
    func replaceSymbols(text: String) -> some View {
        var result = Text("")
        let parts = text.components(separatedBy: "{")
        for part in parts {
            if part.contains("}") {
                if part.contains("}") {
                    let pieces = part.split(separator: "}")
                    var temp = pieces[0]
                    while let range = temp.range(of: "/") {
                        temp.removeSubrange(range.lowerBound..<range.upperBound)
                    }
                    var width = 17
                    #if targetEnvironment(macCatalyst)
                    width = 15
                    #endif
                    if temp == "100" {
                        width = 32
                    } else if temp == "1000000" {
                        width = 86
                    } else if temp == "HR" || temp == "HW" {
                        width = 8
                    }
                    result = result + Text(Image(uiImage: getImage(width: width, name: String(temp)))).baselineOffset(-2)
                    if pieces.count > 1 {
                        result = result + Text(String(pieces[1]))
                    }
                }
            } else {
                result = result + Text(part)
            }
        }
        
        return result
    }
    func getImage(width: Int, name: String) -> UIImage {
        let image = UIImage(named: name)
        var height = 17
        #if targetEnvironment(macCatalyst)
        height = 15
        #endif
        let sizeChange = CGSize(width: width, height: height)
        let hasAlpha = true
        let scale: CGFloat = 0.0
        UIGraphicsBeginImageContextWithOptions(sizeChange, !hasAlpha, scale)
        image?.draw(in: CGRect(origin: CGPoint(x: 0, y: 0), size: sizeChange))
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return scaledImage!
    }
    
}

