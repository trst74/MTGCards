//
//  PageTwoViewController.swift
//  MTGCards
//
//  Created by Joseph Smith on 3/9/19.
//  Copyright © 2019 Robotic Snail Software. All rights reserved.
//

import UIKit

class PageTwoViewController: UIViewController {
    @IBOutlet weak var downloadLabel: UILabel!
    @IBOutlet weak var downloadProgress: UIProgressView!
    @IBOutlet weak var doneButton: RoundButton!
    @IBOutlet weak var downloadButton: RoundButton!
    
    var pageOne: PageOneViewController? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func downloadData(_ sender: Any) {
        
        
        downloadSets()
    }
    @IBAction func done(_ sender: Any) {
        
        self.dismiss(animated: true){
            self.pageOne?.dismiss(animated: false, completion: nil)
        }
    }
    func downloadSets(){
        self.downloadLabel.isHidden = false
        self.downloadProgress.isHidden = false
        self.doneButton.isEnabled = false
        self.downloadButton.isEnabled = false

        let setlist = DataManager.getSetList()
        if let sl = setlist {
            print(sl.count)
            let setTotal = sl.count
            var completed = 0
            
            DispatchQueue.global(qos: .default).async {
                for s in sl {
                    DataManager.getSet(setCode: s.code!) { success in
                        DispatchQueue.main.async {
                            if success {
                                //save
                                completed += 1
                                let percent = Float(completed)/Float(setTotal)
                                print("\(Int(percent*100))%")
                                self.downloadProgress.setProgress(percent, animated: true)
                                self.downloadLabel.text = "\(Int(percent*100))%"
                                if completed == setTotal {
                                    self.doneButton.isEnabled = true
                                    self.downloadLabel.text = "Done!"
                                }
                            } 
                        }
                    }
               }
            }
        }
    }
}

