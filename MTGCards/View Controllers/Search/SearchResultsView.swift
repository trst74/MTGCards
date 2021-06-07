////
////  SearchResultsView.swift
////  MTGCards
////
////  Created by Joseph Smith on 5/29/21.
////
//
//import SwiftUI
//import CoreData
//
//
//
//struct SearchResultsView: View {
//    @State private var searchText = "Elf"
//    //@Environment(\.managedObjectContext) var managedObjectContext
////    @FetchRequest(
////        // 2
////        entity: Card.entity(),
////        // 3
////        sortDescriptors: [
////            NSSortDescriptor(keyPath: \Card.name, ascending: true), NSSortDescriptor(key: "set.name", ascending: true)
////        ]
////        //,
////        // 4
////        //predicate: NSCompoundPredicate(type: NSCompoundPredicate.LogicalType.and, subpredicates: self.getPrediccates())
////
////    ) var cards: FetchedResults<Card>
//    
//    
//    var body: some View {
//        ZStack {
//        VStack{
//            SearchBar(text: $searchText)
//            //            List{
//            //                ForEach(cards, id: \.self) { card in
////                                HStack(alignment: .center){
////                                    VStack(alignment: .leading) {
////                                        Text(getCardName(card: card))
////                                        Text(card.set.name ?? "Set Name Failed")
////                                            .font(.system(size: 12.0))
////                                    }
////                                    Spacer()
////                                    Text(showFrameEffects(card: card) ? "✨": "")
////
////                                }
////                                .padding(8)
////                                .padding(.leading, 12)
////                                .frame(
////                                    minWidth: 0,
////                                    maxWidth: .infinity,
////                                    minHeight: 0,
////                                    maxHeight: .infinity,
////                                    alignment: .topLeading
////                                )
////                                .background(
////                                    LinearGradient(gradient: Gradient(colors: getGradiantColors(card: card)), startPoint: .leading, endPoint: .trailing)
////                                )
////                                .listRowInsets(EdgeInsets())
////                            }
//            //            }
//            FilteredList(filterKey: "name", filterValue: searchText) { (card: Card) in
//                HStack(alignment: .center){
//                    VStack(alignment: .leading) {
//                        Text(getCardName(card: card))
//                        Text(card.set.name ?? "Set Name Failed")
//                            .font(.system(size: 12.0))
//                    }
//                    Spacer()
//                    Text(showFrameEffects(card: card) ? "✨": "")
//                    
//                }
//                .padding(8)
//                .padding(.leading, 12)
//                .frame(
//                    minWidth: 0,
//                    maxWidth: .infinity,
//                    minHeight: 0,
//                    maxHeight: .infinity,
//                    alignment: .topLeading
//                )
//                .background(
//                    LinearGradient(gradient: Gradient(colors: getGradiantColors(card: card)), startPoint: .leading, endPoint: .trailing)
//                )
//                .listRowInsets(EdgeInsets())
//            
//            }
//        }
//        //.navigationTitle("Search (\(cards.count))")
//        }
//    }
//    private func getPrediccates() -> [NSPredicate] {
//        var filterPredicates = Filters.current.getPredicates()
//        var searchPred = NSPredicate(format: "name contains[c] %@", searchText)
//        filterPredicates.append(searchPred)
//        return filterPredicates
//    }
//    private func getCardName(card: Card) -> String {
//        var effectiveName = ""
//        if let name = card.name {
//            if name.contains("//") {
//                let parts = name.components(separatedBy: " // ")
//                if card.side == "a" {
//                    effectiveName = parts.first ?? ""
//                } else {
//                    effectiveName = parts[1]
//                }
//            } else {
//                effectiveName = card.name ?? ""
//            }
//        }
//        return effectiveName
//    }
//    private func showFrameEffects(card: Card) -> Bool {
//        if card.frameEffects?.count ?? 0 > 0 {
//            if card.frameEffects?.count == 1 && (card.frameEffects?.allObjects[0] as? CardFrameEffect)?.effect == "legendary" {
//                return false
//            } else {
//                return true
//            }
//        } else if card.borderColor == "borderless" || card.isFullArt {
//            return true
//            //cell.frameEffectIndicator?.text = "✨"
//        } else {
//            return false
//        }
//    }
//    private func getGradiantColors(card: Card) -> [Color] {
//        if let colorIdentities = card.colorIdentity?.allObjects as? [ColorIdentity] {
//            let identities: [String?] = colorIdentities.map ({ $0.color })
//            var colors: [Color] = []
//            if identities.contains("W") {
//                colors.append(Color(UIColor(named: "Plains") ?? .white))
//            }
//            if identities.contains("U") {
//                colors.append(Color(UIColor(named: "Islands") ?? UIColor.white))
//            }
//            if identities.contains("B") {
//                colors.append(Color(UIColor(named: "Swamps") ?? UIColor.white))
//            }
//            if identities.contains("R") {
//                colors.append(Color(UIColor(named: "Mountains") ?? UIColor.white))
//            }
//            if identities.contains("G") {
//                colors.append(Color(UIColor(named: "Forests") ?? UIColor.white))
//            }
//            if colors.count == 0 {
//                if card.type == "Land" {
//                    colors = [Color(UIColor(named: "Lands") ?? UIColor.white)]
//                    
//                } else {
//                    colors = [Color(UIColor(named: "Artifacts") ?? UIColor.white)]
//                }
//            }
//            if colors.count == 1 {
//                colors += colors
//            }
//            return colors
//        }
//        return []
//    }
//}
//
//
//struct FilteredList<T: NSManagedObject, Content: View>: View {
//    var fetchRequest: FetchRequest<T>
//    var cards: FetchedResults<T> { fetchRequest.wrappedValue }
//    
//    // this is our content closure; we'll call this once for each item in the list
//    let content: (T) -> Content
//    
//    var body: some View {
//        List(fetchRequest.wrappedValue, id: \.self) { card in
//            self.content(card)
//                .listRowInsets(EdgeInsets())
//        }
//        .listRowInsets(EdgeInsets())
//    }
//    
//    init(filterKey: String, filterValue: String, @ViewBuilder content: @escaping (T) -> Content) {
//        var predicate: NSPredicate
//        if filterValue.count > 0 {
//          predicate = NSPredicate(format: "name contains[c] %@", " ")
//        }
//        fetchRequest = FetchRequest<T>(entity: T.entity(), sortDescriptors:[NSSortDescriptor(keyPath: \Card.name, ascending: true), NSSortDescriptor(key: "set.name", ascending: true)], predicate: filterValue.count > 0 ? NSPredicate(format: "name contains[c] %@", filterValue) : nil)
//        self.content = content
//    }
//}
