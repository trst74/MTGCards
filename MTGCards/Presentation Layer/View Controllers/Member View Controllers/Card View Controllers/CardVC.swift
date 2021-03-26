//
//  CardVC.swift
//  MTGCards
//
//  Created by Joseph Smith on 9/1/20.
//  Copyright © 2020 Robotic Snail Software. All rights reserved.
//

import SwiftUI

struct CardVC: View {
    
    @State public var card: Card
    private var cardLegalities: [Format] {
        get {
            var leg: [Format] = []
            leg.append(Format(name: "Standard", legality: card.legalities?.standard ?? "Not Legal"))
            leg.append(Format(name: "Pioneer", legality: card.legalities?.pioneer ?? "Not Legal"))
            leg.append(Format(name: "Modern", legality: card.legalities?.modern ?? "Not Legal"))
            leg.append(Format(name: "Legacy", legality: card.legalities?.legacy ?? "Not Legal"))
            leg.append(Format(name: "Vintage", legality: card.legalities?.vintage ?? "Not Legal"))
            leg.append(Format(name: "Commander", legality: card.legalities?.commander ?? "Not Legal"))
            leg.append(Format(name: "Frontier", legality: card.legalities?.frontier ?? "Not Legal"))
            leg.append(Format(name: "Pauper", legality: card.legalities?.pauper ?? "Not Legal"))
            leg.append(Format(name: "Penny", legality: card.legalities?.penny ?? "Not Legal"))
            leg.append(Format(name: "Duel", legality: card.legalities?.duel ?? "Not Legal"))
            return leg
        }
    }
    private var rulings: [Ruling] {
        get {
            if let rs = card.rulings.allObjects as? [Ruling] {
                return rs
            }
            return []
        }
    }
    private var effectiveNane: String {
        get {
            if let name = card.name {
                if name.contains("//") {
                    let parts = name.components(separatedBy: " // ")
                    if card.side == "a" {
                        return parts.first ?? ""
                    } else {
                        return parts[1]
                    }
                }
            }
            return card.name ?? ""
        }
    }
    @State var showingShare = false
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView{
                VStack(alignment: .center){
                    if geometry.size.width > 500 {
                        HStack(alignment: .top){
                            ZStack {
                                loadImage()
                                if card.otherFaceIds?.count ?? 0 > 0 {
                                    VStack {
                                        //Spacer()
                                        HStack{
                                            Spacer()
                                            Button(action: {
                                                if let otherside = DataManager.getCard(byUUID: card.otherFaceIds?[0] ?? "")
                                                {
                                                    card = otherside
                                                }
                                            }) {
                                                Image(systemName: "arrow.uturn.left")
                                            }
                                            .padding()
                                            .background(Color(UIColor.secondarySystemBackground))
                                            .cornerRadius(10)
                                            .shadow(color: Color.black.opacity(0.3),
                                                    radius: 3,
                                                    x: 3,
                                                    y: 3)
                                        }
                                        .padding()
                                    }
                                }
                            }
                            VStack{
                                CardDetailsView(card: card)
                                PricesView(cardIDs: [card.tcgplayerProductID], card: card)
                            }
                            
                        }
                        HStack(alignment: .top){
                            if rulings.count > 0 {
                                VStack{
                                    Text("Rulings").bold()
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .padding(.init(top: 6.0, leading: 4.0, bottom: 0, trailing: 0))
                                    RulingsView(rulings: rulings)
                                        
                                }
                            }
                            VStack{
                                Text("Legalities").bold()
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding(.init(top: 6.0, leading: 4.0, bottom: 0, trailing: 0))
                                DeckLegalities(formats: self.cardLegalities)
                            }
                        }
                    }
                    else {
                        //GeometryReader { geometry in
                        ZStack {
                            loadImage()
                            if card.otherFaceIds?.count ?? 0 > 0 {
                                VStack {
                                    //Spacer()
                                    HStack{
                                        Spacer()
                                        Button(action: {
                                            if let otherside = DataManager.getCard(byUUID: card.otherFaceIds?[0] ?? "")
                                            {
                                                card = otherside
                                            }
                                        }) {
                                            Image(systemName: "arrow.uturn.left")
                                        }
                                        .padding()
                                        .background(Color(UIColor.secondarySystemBackground))
                                        .cornerRadius(10)
                                        .shadow(color: Color.black.opacity(0.3),
                                                radius: 3,
                                                x: 3,
                                                y: 3)
                                        
                                    }
                                    .padding()
                                }
                                
                            }
                        }
                        CardDetailsView(card: card)
                        PricesView(cardIDs: [card.tcgplayerProductID], card: card)
                        if rulings.count > 0 {
                            Text("Rulings").bold()
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.init(top: 6.0, leading: 4.0, bottom: 0, trailing: 0))
                            RulingsView(rulings: rulings)
                        }
                        Text("Legalities").bold()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.init(top: 6.0, leading: 4.0, bottom: 0, trailing: 0))
                        DeckLegalities(formats: self.cardLegalities)
                    }
                    
                }
                .padding(.init(top: 8.0, leading: 16.0, bottom: 8.0, trailing: 16.0))
            }
            .navigationTitle(Text("\(self.effectiveNane)"))
            .toolbar {
                ToolbarItem(placement: .bottomBar) {
                    Button(action: {
                        share()
                    }) {
                        Image(systemName: "square.and.arrow.up")
                    }
                }
                ToolbarItem(placement: .bottomBar) {
                    Spacer()
                }
                ToolbarItem(placement: .bottomBar) {
                    Button(action: {
                        print("Edit button was tapped")
                    }) {
                        Image(systemName: "plus")
                    }
                }
            }
        }
    }
    func share(){
        let alert = UIAlertController(title: "Share", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Image", style: .default, handler: { action in
            //self.shareImage(self.shareButton)
            self.shareImage()
        }))
        if card.multiverseID > 0 {
            alert.addAction(UIAlertAction(title: "Gatherer", style: .default, handler: { action in
                if let url = URL(string:  "http://gatherer.wizards.com/Pages/Card/Details.aspx?multiverseid=\(card.multiverseID)"){
                    self.shareURL(url: url)
                }
            }))
        }
        if let tcg = card.tcgplayerPurchaseURL {
            alert.addAction(UIAlertAction(title: "TCGPlayer", style: .default, handler: { action in
                //self.shareText(text: tcg, self.shareButton)
            }))
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
            
            UIApplication.shared.windows.first?.rootViewController?.dismiss(animated: true, completion: nil)
        }))
        if let popoverController = alert.popoverPresentationController {
            //popoverController.barButtonItem = shareButton
        }
        UIApplication.shared.windows.first?.rootViewController?.present(alert, animated: true, completion: nil)
    }
    func shareImage() {
        UIApplication.shared.windows.first?.rootViewController?.dismiss(animated: true, completion: nil)
        guard let image = getImage(Key: card.uuid ?? "") else {return}
        let av = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        UIApplication.shared.windows.first?.rootViewController?.present(av, animated: true, completion: nil)
    }
    func shareURL(url: URL) {
        UIApplication.shared.windows.first?.rootViewController?.dismiss(animated: true, completion: nil)
        
        let av = UIActivityViewController(activityItems: [url], applicationActivities: nil)
        UIApplication.shared.windows.first?.rootViewController?.present(av, animated: true, completion: nil)
    }
    func actionSheet() {
        guard let data = URL(string: "https://www.apple.com") else { return }
        let av = UIActivityViewController(activityItems: [data], applicationActivities: nil)
        UIApplication.shared.windows.first?.rootViewController?.present(av, animated: true, completion: nil)
    }
    func loadImage() -> some View{
        if var key = card.uuid {
            if card.side == "b" && card.layout != "adventure"{
                key += "b"
            }
            let image = getImage(Key: key)
            if let image = image {
                //cardImage.image = image
                return AnyView(Image(uiImage: image).resizable().aspectRatio(contentMode: .fit).cornerRadius(20))
            } else {
                if let id = card.scryfallID {
                    do {
                        let version = UserDefaultsHandler.selectedCardImageQuality()
                        if version != "none" {
                            var url = "https://api.scryfall.com/cards/\(id)?format=image&version=\(version)"
                            if card.side == "b" && card.layout != "split" && card.layout != "flip" && card.layout != "meld" && card.layout != "adventure"{
                                url += "&face=back"
                            }
                            
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
            print("loaded from cache")
            return UIImage(contentsOfFile: filename.path)
        }
        return nil
    }
    
    private func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}

