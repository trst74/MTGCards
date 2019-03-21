//
//  SettingsTableViewController.swift
//  MTGCards
//
//  Created by Joseph Smith on 3/6/19.
//  Copyright © 2019 Robotic Snail Software. All rights reserved.
//

import UIKit
import CoreData

class SettingsTableViewController: UITableViewController {
    
    @IBOutlet weak var fileInfoLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateFileInfoLabel()
        
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
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            return
        case 1:
            return
        case 2:
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
            default:
                return
            }
        default:
            return
        }
    }
    @IBAction func download(_ sender: Any) {
        var cardList: [Card] = []
        let fetchRequest: NSFetchRequest<Card> = NSFetchRequest<Card>(entityName: "Card")
        let managedContext = CoreDataStack.handler.managedObjectContext
        fetchRequest.predicate = NSPredicate(format: "set.code == %@", "RNA")
        let imageTypes = ["small","normal","large","png","art_crop","border_crop"]
        do {
            // Perform Fetch Request
            let c = try managedContext.fetch(fetchRequest)
       
            cardList = c
            for card in c {
          
                if let id = card.scryfallID{
                    var url = "https://api.scryfall.com/cards/\(id)?format=image"
                    if card.side == "b" {
                        url += "&face=back"
                    }
                    for type in imageTypes {
                        let imageurl = url+"&version=\(type)"
                        if let tempurl = URL(string: imageurl) {
                            getDataFromUrl(url: tempurl) { (data, _, error)  in
                                guard let data = data, error == nil else {
                                    return
                                    
                                }
                           
                                DispatchQueue.main.async { () -> Void in
                                    let image = UIImage(data: data)
                                    
                                    if let imageToDisplay = image {
                                        if let carduuid = card.uuid, let cardname = card.name{
                                            let imagename = carduuid + type
                                            self.saveImage(image: imageToDisplay, Key: imagename,dir: cardname)
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        } catch {
            print("Unable to Fetch Cards, (\(error))")
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
}
