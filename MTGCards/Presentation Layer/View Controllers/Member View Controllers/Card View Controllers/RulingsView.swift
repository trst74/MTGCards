//
//  RulingsView.swift
//  MTGCards
//
//  Created by Joseph Smith on 9/9/20.
//  Copyright © 2020 Robotic Snail Software. All rights reserved.
//

import SwiftUI

struct RulingsView: View {
    var rulings: [Ruling]
    static let taskDateFormat: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter
    }()
    var body: some View {
        VStack{
            ForEach(rulings, id: \.self ) { ruling in
                VStack{
                    replaceSymbols(text: ruling.text ?? "")
                        .multilineTextAlignment(.leading)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.init(top: 2.0, leading: 0, bottom: 2.0, trailing: 0))
                    Text("\((ruling.date!).toDate() ?? Date(), formatter: Self.taskDateFormat)")
                        .font(.system(size: 10.0, weight: .thin))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.init(top: 2.0, leading: 0, bottom: 2.0, trailing: 0))
                }
                .padding(.init(top: 8.0, leading: 16.0, bottom: 8.0, trailing: 16.0))
                .background(Color(UIColor.secondarySystemBackground))
                .cornerRadius(10)
            }
            
        }
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

