//
//  SettingsTableViewController.swift
//  MTGCards
//
//  Created by Joseph Smith on 3/6/19.
//  Copyright © 2019 Robotic Snail Software. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController {

    @IBOutlet weak var fileInfoLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateFileInfoLabel()
     
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
}
