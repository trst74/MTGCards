//
//  DataManager.swift
//  MTGCards
//
//  Created by Joseph Smith on 1/17/19.
//  Copyright © 2019 Robotic Snail Software. All rights reserved.
//

import Foundation
import CoreData
import UIKit

public class DataManager {
    
    static func getSet(setCode: String, completion: @escaping (_ success: Bool) -> Void) {
        
        let setURL = URL(string: "https://mtgjson.com/api/v5/\(setCode).json")
        do {
            let data = try Data(contentsOf: setURL!)
            let d = data
            
            guard let codingUserInfoKeyManagedObjectContext = CodingUserInfoKey.managedObjectContext else {
                fatalError("Failed to retrieve context")
            }
            let decoder = newJSONDecoder()
            let managedObjectContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
            managedObjectContext.persistentStoreCoordinator = CoreDataStack.handler.storeContainer.persistentStoreCoordinator
            
            decoder.userInfo[codingUserInfoKeyManagedObjectContext] = managedObjectContext
            managedObjectContext.perform {
                do {
                    try autoreleasepool {
                        let set = try decoder.decode(MTGSet.self, from: d)
                        print("\(setCode): \(set.cards.count)")
                    }
                    do {
                        try managedObjectContext.save()
                        
                    } catch {
                        print(error)
                    }
                    managedObjectContext.parent?.reset()
                    
                    
                    completion(true)
                } catch let error {
                    print(error)
                    completion(false)
                }
            }
        } catch let error {
            print("Download error: \(error)")
            completion(false)
        }
    }
    static func getSetUpdate(setCode: String) -> UpdateSet? {
        
        let setURL = URL(string: "https://mtgjson.com/json/\(setCode).json")
        do {
            let data = try Data(contentsOf: setURL!)
            let d = data
            
            let decoder = newJSONDecoder()
            
            
            return try decoder.decode(UpdateSet.self, from: d)
        } catch {
            print(error)
            return nil
        }
    }
    static func getSetList() -> SetList? {
        let setListURL = URL(string: "https://mtgjson.com/api/v5/SetList.json")
        let setList = try? SetList.init(fromURL: setListURL!)
        return setList
    }
    static func getCollectionsFromCoreData() -> [Collection] {
        let request = NSFetchRequest<Collection>(entityName: "Collection")
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        request.sortDescriptors = [sortDescriptor]
        do {
            let results = try CoreDataStack.handler.privateContext.fetch(request)
            return results
        } catch {
            print(error)
        }
        return []
    }
    static func getDecksFromCoreData() -> [Deck] {
        let request = NSFetchRequest<Deck>(entityName: "Deck")
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        request.sortDescriptors = [sortDescriptor]
        do {
            let results = try CoreDataStack.handler.privateContext.fetch(request)
            return results
        } catch {
            print(error)
        }
        return []
    }
    static private func getCard(byUUID: String) -> Card? {
        var card: Card?
        let request = NSFetchRequest<Card>(entityName: "Card")
        request.predicate = NSPredicate(format: "uuid == %@", byUUID)
        do {
            let results = try CoreDataStack.handler.privateContext.fetch(request)
            if results.count > 1 {
                print("Too many items with uuid \(byUUID)")
            } else {
                card = results[0]
            }
        } catch {
            print(error)
            card = nil
        }
        return card
    }
    static func getSets() -> [MTGSet] {
        let request = NSFetchRequest<MTGSet>(entityName: "MTGSet")
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        request.sortDescriptors = [sortDescriptor]
        
        do {
            let results = try CoreDataStack.handler.managedObjectContext.fetch(request)
            return results
        } catch {
            print(error)
        }
        return []
    }
    static func getCollection() -> Collection? {
        let request = NSFetchRequest<Collection>(entityName: "Collection")
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        request.sortDescriptors = [sortDescriptor]
        do {
            let results = try CoreDataStack.handler.privateContext.fetch(request)
            return results[0]
        } catch {
            print(error)
        }
        return nil
    }
    static func getWishList() -> Collection? {
        let request = NSFetchRequest<Collection>(entityName: "Collection")
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        request.sortDescriptors = [sortDescriptor]
        do {
            let results = try CoreDataStack.handler.privateContext.fetch(request)
            return results[1]
        } catch {
            print(error)
        }
        return nil
    }
    static func addCardToCollection(id: NSManagedObjectID) {
        if let card = CoreDataStack.handler.privateContext.object(with: id) as? Card {
            if let collection = getCollection() {
                guard  let entity = NSEntityDescription.entity(forEntityName: "CollectionCard", in:  CoreDataStack.handler.privateContext) else {
                    fatalError("Failed to decode Card")
                }
                let collectionCard = CollectionCard.init(entity: entity, insertInto: CoreDataStack.handler.privateContext)
                collectionCard.card = card
                collectionCard.quantity = 1
                collection.addToCards(collectionCard)
                do {
                    try CoreDataStack.handler.privateContext.save()
                } catch {
                    print(error)
                }
            }
        }
    }
    static func addCardToWishList(id: NSManagedObjectID) {
        if let card = CoreDataStack.handler.privateContext.object(with: id) as? Card {
            if let collection = getWishList(){
                guard  let entity = NSEntityDescription.entity(forEntityName: "CollectionCard", in:  CoreDataStack.handler.privateContext) else {
                    fatalError("Failed to decode Card")
                }
                let collectionCard = CollectionCard.init(entity: entity, insertInto: CoreDataStack.handler.privateContext)
                collectionCard.card = card
                collectionCard.quantity = 1
                collection.addToCards(collectionCard)
                do {
                    try CoreDataStack.handler.privateContext.save()
                } catch {
                    print(error)
                }
            }
        }
    }
    static func addCardToDeck(deckId: NSManagedObjectID, cardId: NSManagedObjectID) {
        if let card = CoreDataStack.handler.privateContext.object(with: cardId) as? Card {
            if let deck = CoreDataStack.handler.privateContext.object(with: deckId) as? Deck {
                guard  let entity = NSEntityDescription.entity(forEntityName: "DeckCard", in:  CoreDataStack.handler.privateContext) else {
                    fatalError("Failed to decode Card")
                }
                let deckCard = DeckCard.init(entity: entity, insertInto: CoreDataStack.handler.privateContext)
                deckCard.card = card
                deckCard.quantity = 1
                deck.addToCards(deckCard)
                do {
                    try CoreDataStack.handler.privateContext.save()
                } catch {
                    print(error)
                }
            }
        }
    }
    static func removeCardFromDeck(cardId: NSManagedObjectID){
        if let card = CoreDataStack.handler.privateContext.object(with: cardId) as? DeckCard {
            if let deck = card.deck {
                deck.removeFromCards(card)
                do {
                    try CoreDataStack.handler.privateContext.save()
                } catch {
                    print(error)
                }
            }
        }
    }
}
public extension CodingUserInfoKey {
    // Helper property to retrieve the context
    static let managedObjectContext = CodingUserInfoKey(rawValue: "managedObjectContext")
}
