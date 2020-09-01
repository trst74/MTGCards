//
//  SettingsTableViewController.swift
//  MTGCards
//
//  Created by Joseph Smith on 3/6/19.
//  Copyright © 2019 Robotic Snail Software. All rights reserved.
//

import UIKit
import CoreData
import MobileCoreServices
import CoreServices
import CoreSpotlight
import StoreKit

class SettingsTableViewController: UITableViewController, UIDocumentPickerDelegate {
    
    @IBOutlet weak var fileInfoLabel: UILabel!
    @IBOutlet weak var noImageSwitch: UISwitch!
    @IBOutlet weak var lowQualitySwitch: UISwitch!
    @IBOutlet weak var normalQualitySwitch: UISwitch!
    @IBOutlet weak var highQualitySwitch: UISwitch!
    @IBOutlet weak var excludeOnlineSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        updateFileInfoLabel()
        setImageQuality(quality: UserDefaultsHandler.selectedCardImageQuality())
        excludeOnlineSwitch.isOn = UserDefaultsHandler.areOnlineOnlyCardsExcluded()
    }
    @IBAction func close(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func clearImageCache(_ sender: Any) {
        let fileManager = FileManager.default
        do {
            let filelist = try fileManager.contentsOfDirectory(atPath: getDocumentsDirectory().path)
            
            for filename in filelist {
                if filename.contains(".png") {
                    do {
                        print(filename)
                        try fileManager.removeItem(at: getDocumentsDirectory().appendingPathComponent(filename))
                    } catch let error {
                        print("Error: \(error.localizedDescription)")
                    }
                }
            }
        } catch let error {
            print("Error: \(error.localizedDescription)")
        }
        updateFileInfoLabel()
    }
    func updateFileInfoLabel() {
        let fileInfo = getFileCountAndSize()
        print("Count: \(fileInfo.count)")
        print("Size: \(fileInfo.size / 1000000.0)")
        fileInfoLabel.text = "\(fileInfo.count) files, using \(fileInfo.size / 1000000.0) MBs"
    }
    func getFileCountAndSize() -> (count: Int, size: Double) {
        let fileManager = FileManager.default
        var count = 0
        var size = 0.0
        do {
            let filelist = try fileManager.contentsOfDirectory(atPath: getDocumentsDirectory().path)
            
            for filename in filelist {
                if filename.contains(".png") {
                    do {
                        count += 1
                        if let attribute = try fileManager.attributesOfItem(atPath: getDocumentsDirectory().appendingPathComponent(filename).path)[FileAttributeKey.size] as? NSNumber {
                            size += attribute.doubleValue
                        }
                    } catch let error {
                        print("Error: \(error.localizedDescription)")
                    }
                }
            }
        } catch let error {
            print("Error: \(error.localizedDescription)")
        }
        return (count, size)
    }
    private func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
//    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        if section == 4 {
//            return 60
//        } else {
//            return 30
//        }
//    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            return
        case 1:
            return
        case 3:
            switch indexPath.row {
            case 0:
                if let url = URL(string: "https://www.raywenderlich.com/7212-multiple-uisplitviewcontroller-tutorial"){
                    UIApplication.shared.open(url, options:[:], completionHandler: nil)
                }
            case 1:
                if let url = URL(string: "https://quicktype.io"){
                    UIApplication.shared.open(url, options:[:], completionHandler: nil)
                }
            case 2:
                if let url = URL(string: "https://mtgjson.com"){
                    UIApplication.shared.open(url, options:[:], completionHandler: nil)
                }
            case 3:
                if let url = URL(string: "https://medium.com/@andrea.prearo/working-with-codable-and-core-data-83983e77198e"){
                    UIApplication.shared.open(url, options:[:], completionHandler: nil)
                }
            case 4:
                if let url = URL(string: "https://medium.com/@sakhabaevegor/create-a-color-gradient-on-the-storyboard-18ccfd8158c2"){
                    UIApplication.shared.open(url, options:[:], completionHandler: nil)
                }
            case 5:
                if let url = URL(string: "https://swiftwithmajid.com/2019/08/14/building-barchart-with-shape-api-in-swiftui/"){
                    UIApplication.shared.open(url, options:[:], completionHandler: nil)
                }
            default:
                return
            }
        case 4:
            switch indexPath.row {
            case 0:
                if let url = URL(string: "https://www.reddit.com/r/Mymtgapp/"){
                    UIApplication.shared.open(url, options:[:], completionHandler: nil)
                }
            case 1:
                if let window = self.view.window?.windowScene {
                    SKStoreReviewController.requestReview(in: window)
                }
            case 2:
                if let url = URL(string: "https://roboticsnailsoftware.com/my-mtg/privacy"){
                    UIApplication.shared.open(url, options:[:], completionHandler: nil)
                }
            case 3:
                if let url = URL(string: "http://www.mymtg.app"){
                    UIApplication.shared.open(url, options:[:], completionHandler: nil)
                }
            case 4:
                if let url = URL(string: "https://www.roboticsnailsoftware.com"){
                    UIApplication.shared.open(url, options:[:], completionHandler: nil)
                }
                
            default:
                return
            }
        default:
            return
        }
    }
    
    func getDataFromUrl(url: URL, completion: @escaping (_ data: Data?, _  response: URLResponse?, _ error: Error?) -> Void) {
        URLSession.shared.dataTask(with: url) {
            (data, response, error) in
            completion(data, response, error)
        }.resume()
    }
    func saveImage(image: UIImage, Key: String, dir: String) {
        if let data = image.pngData() {
            let fileManager = FileManager.default
            let paths = getDocumentsDirectory().appendingPathComponent(dir)
            try! fileManager.createDirectory(at: paths, withIntermediateDirectories: true, attributes: nil)
            let filename = getDocumentsDirectory().appendingPathComponent("\(dir)/\(Key).png")
            print(filename)
            try? data.write(to: filename)
        }
    }
    @IBAction func noImagesChanged(_ sender: UISwitch) {
        if sender.isOn {
            lowQualitySwitch.isOn = false
            normalQualitySwitch.isOn = false
            highQualitySwitch.isOn = false
            UserDefaultsHandler.setSelectedCardImageQuality(quality: "none")
        } else {
            checkIfASwitchIsOnAndDefault()
        }
    }
    @IBAction func lowQualityChanged(_ sender: UISwitch) {
        if sender.isOn {
            noImageSwitch.isOn = false
            normalQualitySwitch.isOn = false
            highQualitySwitch.isOn = false
            UserDefaultsHandler.setSelectedCardImageQuality(quality: "small")
        } else {
            checkIfASwitchIsOnAndDefault()
        }
    }
    @IBAction func normalQualityChanged(_ sender: UISwitch) {
        if sender.isOn {
            noImageSwitch.isOn = false
            lowQualitySwitch.isOn = false
            highQualitySwitch.isOn = false
            UserDefaultsHandler.setSelectedCardImageQuality(quality: "normal")
        } else {
            checkIfASwitchIsOnAndDefault()
        }
    }
    @IBAction func highQualityChanged(_ sender: UISwitch) {
        if sender.isOn {
            noImageSwitch.isOn = false
            normalQualitySwitch.isOn = false
            lowQualitySwitch.isOn = false
            UserDefaultsHandler.setSelectedCardImageQuality(quality: "large")
        } else {
            checkIfASwitchIsOnAndDefault()
        }
    }
    func checkIfASwitchIsOnAndDefault(){
        if !noImageSwitch.isOn && !lowQualitySwitch.isOn && !normalQualitySwitch.isOn && !highQualitySwitch.isOn {
            highQualitySwitch.isOn = true
        }
    }
    func setImageQuality(quality: String){
        switch quality {
        case "none":
            noImageSwitch.isOn = true
        case "small":
            lowQualitySwitch.isOn = true
        case "normal":
            normalQualitySwitch.isOn = true
        case "large":
            highQualitySwitch.isOn = true
        default:
            highQualitySwitch.isOn = true
        }
    }
    @IBAction func excludeSwitchChanged(_ sender: UISwitch) {
        UserDefaultsHandler.setExcludeOnlineOnly(exclude: sender.isOn)
    }
    @IBAction func manualUpdate(_ sender: Any) {
        
        let decoder = newJSONDecoder()
        let managedObjectContext = CoreDataStack.handler.managedObjectContext
        managedObjectContext.persistentStoreCoordinator = CoreDataStack.handler.storeContainer.persistentStoreCoordinator
        guard let codingUserInfoKeyManagedObjectContext = CodingUserInfoKey.managedObjectContext else {
            fatalError("Failed to retrieve context")
        }
        decoder.userInfo[codingUserInfoKeyManagedObjectContext] = managedObjectContext
        DispatchQueue.global(qos: .default).async {
            guard let setlist = DataManager.getSetList() else { return }
            let localSets = DataManager.getSets()
            for sourceSet in setlist {
                let localSet = localSets.first {
                    $0.code == sourceSet.code
                }
                if localSet == nil {
                    print("set missing locally: \(sourceSet.code)")
                    DataManager.getSet(setCode: sourceSet.code) { success in
                        CoreDataStack.handler.privateContext.parent?.reset()
                        CoreDataStack.handler.privateContext.reset()
                    }
                }
                if localSet?.meta?.date != sourceSet.setMeta?.date {
                    print("\(sourceSet.code ) local version: \(localSet?.meta?.date ?? "") || source version: \(sourceSet.setMeta?.date ?? "")")
                    
                    let setUpdate = DataManager.getSetUpdate(setCode: sourceSet.code)
                    
                    if let setUpdate = setUpdate {
                        let updateCards = setUpdate.cards
                        if let localSetCards = localSet?.cards.allObjects as? [Card]  {
                            //existing cards?
                            let existingCards = updateCards.filter {
                                let uuid = $0.uuid
                                return localSetCards.contains { $0.uuid == uuid }
                            }
                            for eCard in existingCards {
                                
                                let localCard = localSetCards.first {
                                    $0.uuid == eCard.uuid
                                }
                                if let localCard = localCard {
                                    //rulings
                                    localCard.removeFromRulings(localCard.rulings)
                                    do {
                                        let json = try eCard.rulings.jsonData()
                                        let newRulings = try decoder.decode([Ruling].self, from: json)
                                        newRulings.forEach { $0.card = localCard }
                                        if newRulings.count > 0 {
                                            localCard.addToRulings(NSSet.init(array: newRulings))
                                        }
                                    } catch {
                                        print(error)
                                    }
                                    //legalities
                                    localCard.legalities?.commander = eCard.legalities.commander
                                    localCard.legalities?.duel = eCard.legalities.duel
                                    localCard.legalities?.frontier = eCard.legalities.frontier
                                    localCard.legalities?.future = eCard.legalities.future
                                    localCard.legalities?.legacy = eCard.legalities.legacy
                                    localCard.legalities?.modern = eCard.legalities.modern
                                    localCard.legalities?.pauper = eCard.legalities.pauper
                                    localCard.legalities?.penny = eCard.legalities.penny
                                    localCard.legalities?.standard = eCard.legalities.standard
                                    localCard.legalities?.vintage = eCard.legalities.vintage
                                    
                                    //types
                                    if let types = localCard.types {
                                        localCard.removeFromTypes(types)
                                    }
                                    
                                    for type in eCard.types {
                                        guard  let entity = NSEntityDescription.entity(forEntityName: "CardType", in: managedObjectContext) else {
                                            fatalError("Failed to decode Card")
                                        }
                                        let tempType = CardType.init(entity: entity, insertInto: managedObjectContext)
                                        tempType.type = type
                                        tempType.card = localCard
                                        localCard.addToTypes(tempType)
                                    }
                                    
                                    //coloridentity
                                    if let colors = localCard.colorIdentity {
                                        localCard.removeFromColorIdentity(colors)
                                    }
                                    for i in eCard.colorIdentity{
                                        guard  let entity = NSEntityDescription.entity(forEntityName: "ColorIdentity", in: managedObjectContext) else {
                                            fatalError("Failed to decode Card")
                                        }
                                        let tempColor = ColorIdentity.init(entity: entity, insertInto: managedObjectContext)
                                        tempColor.color = i
                                        tempColor.card = localCard
                                        localCard.addToColorIdentity(tempColor)
                                    }
                                    //card subtypes
                                    if let types = localCard.cardsubtypes {
                                        localCard.removeFromCardsubtypes(types)
                                    }
                                    for sub in eCard.subtypes {
                                        guard  let entity = NSEntityDescription.entity(forEntityName: "CardSubtype", in: managedObjectContext) else {
                                            fatalError("Failed to decode Card")
                                        }
                                        let tempsub = CardSubtype.init(entity: entity, insertInto: managedObjectContext)
                                        tempsub.subtype = sub
                                        tempsub.card = localCard
                                        localCard.addToCardsubtypes(tempsub)
                                    }
                                    //card super types
                                    if let types = localCard.cardsupertypes {
                                        localCard.removeFromCardsupertypes(types)
                                    }
                                    for superType in eCard.supertypes {
                                        guard  let entity = NSEntityDescription.entity(forEntityName: "CardSupertype", in: managedObjectContext) else {
                                            fatalError("Failed to decode Card")
                                        }
                                        let tempsub = CardSupertype.init(entity: entity, insertInto: managedObjectContext)
                                        tempsub.supertype = superType
                                        tempsub.card = localCard
                                        localCard.addToCardsupertypes(tempsub)
                                    }
                                    //card Data
                                    localCard.artist = eCard.artist
                                    localCard.borderColor = eCard.borderColor
                                    localCard.colors = eCard.colors
                                    localCard.convertedManaCost = Float(eCard.convertedManaCost ?? 0)
                                    localCard.flavorText = eCard.flavorText
                                    localCard.frameVersion = eCard.frameVersion
                                    localCard.hasFoil = eCard.hasFoil
                                    localCard.hasNonFoil = eCard.hasNonFoil
                                    localCard.layout = eCard.layout
                                    localCard.manaCost = eCard.manaCost
                                    localCard.multiverseID = Int32(eCard.multiverseID ?? 0)
                                    localCard.name = eCard.name
                                    localCard.number = eCard.number
                                    localCard.originalText = eCard.originalText
                                    localCard.originalType = eCard.originalType
                                    localCard.power = eCard.power
                                    localCard.printings = eCard.printings
                                    localCard.rarity = eCard.rarity
                                    localCard.scryfallID = eCard.scryfallID
                                    localCard.tcgplayerProductID = Int32(eCard.tcgplayerProductID ?? 0)
                                    localCard.text = eCard.text
                                    localCard.toughness = eCard.toughness
                                    localCard.type = eCard.type
                                    localCard.watermark = eCard.watermark
                                    localCard.names = eCard.names
                                    localCard.loyalty = eCard.loyalty
                                    localCard.faceConvertedManaCost = Float(eCard.faceConvertedManaCost ?? 0)
                                    localCard.side = eCard.side
                                    localCard.variations = eCard.variations
                                    localCard.starter = eCard.isStarter ?? false
                                    localCard.isReserved = eCard.isReserved ?? false
                                }
                            }
                            //new cards?
                            let newCards = updateCards.filter {
                                let uuid = $0.uuid
                                return !localSetCards.contains { $0.uuid == uuid }
                            }
                            
                            for card in newCards {
                                do {
                                    let c1 = try card.jsonData()
                                    let newCard = try decoder.decode(Card.self, from: c1)
                                    if let localSet = localSet {
                                        newCard.set = localSet
                                        localSet.cards.addingObjects(from: [newCard])
                                        let attributeSet = CSSearchableItemAttributeSet(itemContentType: kUTTypeData as String)
                                        attributeSet.title = newCard.name
                                        attributeSet.contentDescription = newCard.set.name
                                        
                                        if let uuid = newCard.uuid {
                                            let item = CSSearchableItem(uniqueIdentifier: "\(uuid)", domainIdentifier: "com.roboticsnailsoftware.MTGCollection", attributeSet: attributeSet)
                                            CSSearchableIndex.default().indexSearchableItems([item]) { error in
                                                if let error = error {
                                                    print("Indexing error: \(error.localizedDescription)")
                                                } else {
                                                    print("Search item successfully indexed!")
                                                }
                                            }
                                            
                                        }
                                    }
                                } catch {
                                    print(error)
                                }
                            }
                            
                            //deleted cards?
                            let deletedCards = localSetCards.filter {
                                let uuid = $0.uuid
                                return !updateCards.contains { $0.uuid == uuid }
                            }
                            
                            for dcard in deletedCards {
                                managedObjectContext.delete(dcard)
                            }
                            //update set data
                            localSet?.baseSetSize = Int16(setUpdate.baseSetSize)
                            localSet?.block = setUpdate.block
                            localSet?.code = setUpdate.code
                            localSet?.isFoilOnly = setUpdate.isFoilOnly
                            localSet?.isOnlineOnly = setUpdate.isOnlineOnly
                            localSet?.meta?.date = setUpdate.meta.date
                            localSet?.meta?.version = setUpdate.meta.version
                            localSet?.mtgoCode = setUpdate.mtgoCode
                            localSet?.name = setUpdate.name
                            localSet?.releaseDate = setUpdate.releaseDate
                            localSet?.tcgplayerGroupID = Int16(setUpdate.tcgplayerGroupID ?? 0)
                            //tokens
                            localSet?.totalSetSize = Int16(setUpdate.totalSetSize)
                            localSet?.type = setUpdate.type
                            
                            do {
                                try managedObjectContext.save()
                            } catch {
                                print(error)
                            }
                        }
                        
                    }
                }
                
            }
            
        }
        
    }
    
    @IBAction func backupPersonalData(_ sender: Any) {
        let path = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("myMTG.json")
        var content = ""
        let collections = DataManager.getCollectionsFromCoreData()
        let collectionUUIDs = (collections[0].cards?.allObjects as? [CollectionCard])?.map { $0.card?.uuid ?? ""} ?? []
        let wishListUUIDs = (collections[1].cards?.allObjects as? [CollectionCard])?.map { $0.card?.uuid ?? "" } ?? []
        let deckBackups = DataManager.getDecksFromCoreData().map { $0.getDeckBackup() }
        let backup = Backup(collection: collectionUUIDs, wishlist: wishListUUIDs, deckBackups: deckBackups)
        
        do {
            try content = backup.jsonString() ?? ""
            try content.write(to: path, atomically: true, encoding: String.Encoding.utf8)
            let vc = UIActivityViewController(activityItems: [path], applicationActivities: [])
            let systemTint = UIButton.appearance().tintColor
            UIButton.appearance().tintColor = UIColor(red: 14.0/255.0, green: 122.0/255.0, blue: 254.0/255.0, alpha: 1.0)
            self.present(vc, animated: true){
                UIButton.appearance().tintColor = systemTint
            }
        } catch {
            print("Failed to export")
        }
    }
    @IBAction func importPersonalData(_ sender: Any) {
        let documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: [.text])
        documentPicker.delegate = self
        self.present(documentPicker, animated: true)
    }
    
    
}
