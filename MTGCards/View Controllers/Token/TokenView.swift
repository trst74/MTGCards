//
//  TokenView.swift
//  MTGCards
//
//  Created by Joseph Smith on 7/12/21.
//

import SwiftUI

struct TokenView: View {
    @State public var token: Token
    private var effectiveName: String {
        get {
            if let name = token.name {
                if name.contains("//") {
                    let parts = name.components(separatedBy: " // ")
                    if token.side == "a" {
                        return parts.first ?? ""
                    } else {
                        return parts[1]
                    }
                }
            }
            return token.name ?? ""
        }
    }
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView{
                VStack(alignment: .center){
                    if geometry.size.width > 500 {
                        HStack(alignment: .top){
                            ZStack {
                                if UserDefaultsHandler.SELECTEDCARDIMAGEQUALITY != "none" {
                                    loadImage()
                                        .frame(minWidth: 0, maxWidth: 390, minHeight: 0, alignment: .center)
                                    
                                }
                            }
                            VStack{
                                TokenDetailsView(token: token)
                            }
                        }
                    }
                    else {
                        ZStack {
                            if UserDefaultsHandler.SELECTEDCARDIMAGEQUALITY != "none" {
                                loadImage()
                                    .onTapGesture {
                                        
                                    }
                                    .onLongPressGesture {
                                        shareImage()
                                        print("Long pressed!")
                                    }
                            }
                        }
                        TokenDetailsView(token: token)
                            .onTapGesture {
                                
                            }
                            .onLongPressGesture {
//                                let con = Sharing.shareText(text: card.text ?? "", nil)
//                                keyWindow?.rootViewController?.present(con, animated: true, completion: nil)
//                                print("Long pressed!")
                            }
                    }
                }
                .padding(.init(top: 8.0, leading: 16.0, bottom: 8.0, trailing: 16.0))
            }
            .navigationTitle(Text(self.effectiveName))
        }
    }
    func shareImage() {
        //UIApplication.shared.windows.first?.rootViewController?.dismiss(animated: true, completion: nil)
        guard let image = getImageURL(Key: token.uuid ?? "") else {return}
        let av = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        
        let keyWindow = UIApplication.shared.connectedScenes
            .filter({$0.activationState == .foregroundActive})
            .map({$0 as? UIWindowScene})
            .compactMap({$0})
            .first?.windows
            .filter({$0.isKeyWindow}).first
        
        keyWindow?.rootViewController?.present(av, animated: true, completion: nil)
    }
    func loadImage() -> some View{
        if var key = token.uuid {
            if token.side == "b" {
                key += "b"
            }
            let image = getImage(Key: key)
            if let image = image {
                //cardImage.image = image
                return AnyView(Image(uiImage: image).resizable().aspectRatio(contentMode: .fit).cornerRadius(20))
            } else {
                if let id = token.scryfallID {
                    do {
                        let version = UserDefaultsHandler.selectedCardImageQuality()
                        if version != "none" {
                            var url = "https://api.scryfall.com/cards/\(id)?format=image&version=\(version)"
//                            if token.side == "b" && card.layout != "split" && card.layout != "flip" && card.layout != "meld" && card.layout != "adventure"{
//                                url += "&face=back"
//                            }
                            
                            return AnyView(URLImage(url: url, key: key))
                            
                        } else {
                            return AnyView(Text(""))
                            
                        }
                    }
                }
            }
        }
        return AnyView(Text(""))
    }
    
    func getImage(Key: String) -> UIImage? {
        let fileManager = FileManager.default
        let filename = getDocumentsDirectory().appendingPathComponent("\(Key).png")
        if fileManager.fileExists(atPath: filename.path) {
            return UIImage(contentsOfFile: filename.path)
        }
        return nil
    }
    func getImageURL(Key: String) -> URL? {
        let fileManager = FileManager.default
        let filename = getDocumentsDirectory().appendingPathComponent("\(Key).png")
        if fileManager.fileExists(atPath: filename.path) {
            return filename
        }
        return nil
    }
    
    private func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}
    
