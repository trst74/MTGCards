//
//  TokenDetailsView.swift
//  MTGCards
//
//  Created by Joseph Smith on 7/12/21.
//

import SwiftUI

struct TokenDetailsView: View {
    var token: Token
    var body: some View {
        VStack {
            if token.type != "Card" {
                Text(token.type ?? "Failure")
                    .padding(.init(top: 2.0, leading: 0, bottom: 2.0, trailing: 0))
            }
            Text(token.set.name ?? "Failure").font(.system(size: 10.0, weight: .thin))
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.init(top: 2.0, leading: 0, bottom: 2.0, trailing: 0))
            if token.text != nil && token.text != "" {
            replaceSymbols(text: token.text ?? "")
                .lineLimit(100)
                .fixedSize(horizontal: false, vertical: true)
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.init(top: 2.0, leading: 0, bottom: 2.0, trailing: 0))
            }
            if let flavor = token.flavorText {
            Text(flavor)
                .font(.subheadline)
                .fontWeight(.light)
                .italic()
                .lineLimit(100)
                .fixedSize(horizontal: false, vertical: true)
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.init(top: 2.0, leading: 0, bottom: 2.0, trailing: 0))
            }
            HStack{
                if let artist = token.artist {
                    Text(artist).italic()
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                if token.power != nil && token.toughness != nil {
                    Text("\(token.power!)/\(token.toughness!)")
                }
            }
        }
        .fixedSize(horizontal: false, vertical: true)
        .padding(.init(top: 8.0, leading: 16.0, bottom: 8.0, trailing: 16.0))
        .background(Color(UIColor.secondarySystemBackground))
        .cornerRadius(10)
    }
    func replaceSymbols(text: String) -> some View {
        //        for keyword in card.keywords! {
        //            let k = keyword as! CardKeyword
        //            print(k.keyword)
        //        }
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
