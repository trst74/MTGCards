//
//  CardVC.swift
//  MTGCards
//
//  Created by Joseph Smith on 9/1/20.
//  Copyright © 2020 Robotic Snail Software. All rights reserved.
//

import SwiftUI

struct CardVC: View {
    let keyWindow = UIApplication.shared.connectedScenes
        .filter({$0.activationState == .foregroundActive})
        .map({$0 as? UIWindowScene})
        .compactMap({$0})
        .first?.windows
        .filter({$0.isKeyWindow}).first
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
    @State var showSheet = false
    @State var showpop = false
    @State var optionsMenu: OptionsMenu = .share
    
    enum OptionsMenu { case share, add }
    var idiom = UIDevice.current.userInterfaceIdiom
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    
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
                            if UserDefaultsHandler.SELECTEDCARDIMAGEQUALITY != "none" {
                                loadImage()
                                    .onTapGesture {
                                        
                                    }
                                    .onLongPressGesture {
                                        shareImage()
                                        print("Long pressed!")
                                    }
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
                        }
                        CardDetailsView(card: card)
                            .onTapGesture {
                                
                            }
                            .onLongPressGesture {
                                let con = Sharing.shareText(text: card.text ?? "", nil)
                                keyWindow?.rootViewController?.present(con, animated: true, completion: nil)
                                print("Long pressed!")
                            }
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
                        optionsMenu = .share
                        self.showSheet.toggle()
                    }, label: {
                        Image(systemName: "square.and.arrow.up")
                    })
                        .actionSheet(isPresented: $showSheet, content: {
                            
                            var sheet: ActionSheet = ActionSheet(title: Text("temp"))
                            if optionsMenu == .share {
                                sheet = ActionSheet(title: Text("Share"), message: Text(""), buttons: [
                                    .default(
                                        Text("Image"),
                                        action: {
                                    shareImage()
                                    print("Share Image")
                                }
                                    ),
                                    .cancel()
                                ] )
                            }
                            else if optionsMenu == .add {
                                sheet =  ActionSheet(title: Text("Add"), message: Text("Add this card to a Deck or Collection"), buttons: [
                                    .default(
                                        Text("Deck"),
                                        action: {
                                    
                                    print("Share Image")
                                }
                                    ),
                                    .cancel()
                                ] )
                            }
                            return sheet
                        })
                }
                ToolbarItem(placement: .bottomBar) {
                    Spacer()
                }
                ToolbarItem(placement: .bottomBar) {
                    Button(action: {
                        optionsMenu = .add
                        self.showSheet.toggle()
                    }, label: {
                        Image(systemName: "plus")
                    })
                        .actionSheet(isPresented: $showSheet, content: {
                            
                            var sheet: ActionSheet = ActionSheet(title: Text("temp"))
                            if optionsMenu == .share {
                                sheet = ActionSheet(title: Text("Share"), message: Text(""), buttons: [
                                    .default(
                                        Text("Image"),
                                        action: {
                                    shareImage()
                                    print("Share Image")
                                }
                                    ),
                                    .cancel()
                                ] )
                            }
                            else if optionsMenu == .add {
                                sheet =  ActionSheet(title: Text("Add"), message: Text("Add this card to a Deck or Collection"), buttons: [
                                    .default(
                                        Text("Deck"),
                                        action: {
                                    print("Share Image")
                                }
                                    ),
                                    .cancel()
                                ] )
                            }
                            return sheet
                        }
                        )
                }
            }
        }
    }
    
    func shareButton() -> some View {
        if idiom == .phone ||  horizontalSizeClass == .compact {
            return AnyView(Button(action: {
                optionsMenu = .share
                self.showSheet.toggle()
            }, label: {
                Image(systemName: "square.and.arrow.up")
            }))
        } else {
            return AnyView(Button(action: {
                optionsMenu = .share
                self.showpop.toggle()
            }, label: {
                Image(systemName: "square.and.arrow.up")
            })
                            .popover(isPresented: $showpop, content: {
                if optionsMenu == .share {
                    Text("Test Share")
                }
                else if optionsMenu == .add {
                    Text("Test add")
                }
            }))
        }
    }
    func addButton() -> some View {
        if idiom == .phone ||  horizontalSizeClass == .compact {
            return AnyView(Button(action: {
                optionsMenu = .add
                self.showSheet.toggle()
            }, label: {
                Image(systemName: "plus")
            }))
        } else {
            return AnyView(Button(action: {
                optionsMenu = .add
                self.showpop.toggle()
            }, label: {
                Image(systemName: "plus")
            })
                            .popover(isPresented: $showpop, content: {
                if optionsMenu == .share {
                    Text("Test Share")
                }
                else if optionsMenu == .add {
                    Text("Test add")
                }
            }))
        }
    }
    func share(){
        let keyWindow = UIApplication.shared.connectedScenes
            .filter({$0.activationState == .foregroundActive})
            .map({$0 as? UIWindowScene})
            .compactMap({$0})
            .first?.windows
            .filter({$0.isKeyWindow}).first
        
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
                print(tcg)
            }))
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
            
            keyWindow?.rootViewController?.dismiss(animated: true, completion: nil)
        }))
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            //let popover = alert.popoverPresentationController
            //popover?.sourceView =
            keyWindow?.rootViewController?.present(alert, animated: true)
        } else {
            
        }
        
        keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
    }
    func shareImage() {
        //UIApplication.shared.windows.first?.rootViewController?.dismiss(animated: true, completion: nil)
        guard let image = getImageURL(Key: card.uuid ?? "") else {return}
        let av = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        
        let keyWindow = UIApplication.shared.connectedScenes
            .filter({$0.activationState == .foregroundActive})
            .map({$0 as? UIWindowScene})
            .compactMap({$0})
            .first?.windows
            .filter({$0.isKeyWindow}).first
        
        keyWindow?.rootViewController?.present(av, animated: true, completion: nil)
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

