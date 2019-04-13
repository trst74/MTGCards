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
        case 3:
            switch indexPath.row {
            case 0:
                if let url = URL(string: "http://www.mymtg.app/privacy"){
                    UIApplication.shared.open(url, options:[:], completionHandler: nil)
                }
            case 1:
                if let url = URL(string: "http://www.mymtg.app"){
                    UIApplication.shared.open(url, options:[:], completionHandler: nil)
                }
            case 2:
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
}
