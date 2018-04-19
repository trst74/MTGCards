//
//  CDTranslations+Custom.swift
//  MTGCards
//
//  Created by Joseph Smith on 3/15/18.
//  Copyright © 2018 Robotic Snail Software. All rights reserved.
//

import Foundation
import CoreData

extension CDTranslation{
    convenience init(from source: Translations, inContext context: NSManagedObjectContext){
        self.init(context: context)
        self.de = source.de
        self.es = source.es
        self.fr = source.fr
        self.it = source.it
        self.pt = source.pt
        self.ru = source.ru
        
    }
}
