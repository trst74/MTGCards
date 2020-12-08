//
//  Filters.swift
//  MTGCards
//
//  Created by Joseph Smith on 4/7/19.
//  Copyright © 2019 Robotic Snail Software. All rights reserved.
//

import Foundation

class Filters {
    static let current = Filters.init()
    
    private var selectedSets: [String] = []
    private var selectedTypes: [String] = []
    private var selectedSubTypes: [String] = []
    private var selectedSuperTypes: [String] = []
    private var selectedLegalities: [String] = []
    private var selectedColorIdentities: [String] = []
    private var selectedKeywords: [String] = []
    private var isPromo: Bool = false
    
    func selectSet(setCode: String) {
        if !isSetSelected(setCode: setCode){
            selectedSets.append(setCode)
        }
    }
    func deselectSet(setCode: String) {
        if isSetSelected(setCode: setCode) {
            if let index = selectedSets.firstIndex(of: setCode) {
                selectedSets.remove(at: index)
            }
        }
    }
    func isSetSelected(setCode: String) -> Bool {
        return selectedSets.contains(setCode)
    }
    func getSelectedSetsDescription() -> String {
        return selectedSets.formattedDescription()
    }
    
    func selectKeyword(keyword: String){
        if !isKeywordSelected(keyword: keyword){
            selectedKeywords.append(keyword)
        }
    }
    func deselectKeyword(keyword: String) {
        if isKeywordSelected(keyword: keyword){
            if let index = selectedKeywords.firstIndex(of: keyword) {
                selectedKeywords.remove(at: index)
            }
        }
    }
    
    
    func isKeywordSelected(keyword: String) -> Bool {
        return selectedKeywords.contains(keyword)
    }
    func getSelectedKeywordsDescription() -> String {
        return selectedKeywords.formattedDescription()
    }
    func getSelectedKeywords() -> String {
        return selectedKeywords.formattedDescription()
    }
    
    func selectType(type: String){
        if !isTypeSelected(type: type){
            selectedTypes.append(type)
        }
    }
    func deselectType(type: String){
        if isTypeSelected(type: type) {
            if let index = selectedTypes.firstIndex(of: type){
                selectedTypes.remove(at: index)
            }
        }
    }
    func isTypeSelected(type: String) -> Bool {
        return selectedTypes.contains(type)
    }
    func getSelectedTypesDescription() -> String {
        return selectedTypes.formattedDescription()
    }
    
    func selectSubType(type: String){
        if !isSubTypeSelected(type: type){
            selectedSubTypes.append(type)
        }
    }
    func deselectSubType(type: String){
        if isSubTypeSelected(type: type) {
            if let index = selectedSubTypes.firstIndex(of: type){
                selectedSubTypes.remove(at: index)
            }
        }
    }
    func isSubTypeSelected(type: String) -> Bool {
        return selectedSubTypes.contains(type)
    }
    func getSelectedSubtypesDescription() -> String {
        return selectedSubTypes.formattedDescription()
    }
    
    func selectSuperType(type: String){
        if !isSuperTypeSelected(type: type){
            selectedSuperTypes.append(type)
        }
    }
    func deselectSuperType(type: String){
        if isSuperTypeSelected(type: type) {
            if let index = selectedSuperTypes.firstIndex(of: type){
                selectedSuperTypes.remove(at: index)
            }
        }
    }
    func isSuperTypeSelected(type: String) -> Bool {
        return selectedSuperTypes.contains(type)
    }
    func getSelectedSuperTypesDescription() -> String {
        return selectedSuperTypes.formattedDescription()
    }
    func selectLegality(legality: String){
        if !isLegalitySelected(legality: legality){
            selectedLegalities.append(legality)
        }
    }
    func deselectLegality(legality: String){
        if isLegalitySelected(legality: legality) {
            if let index = selectedLegalities.firstIndex(of: legality){
                selectedLegalities.remove(at: index)
            }
        }
    }
    func isLegalitySelected(legality: String) -> Bool {
        return selectedLegalities.contains(legality)
    }
    func getSelectedLegalitiesDescription() -> String {
        return selectedLegalities.formattedDescription()
    }
    func selectColorIdentity(color: String){
        if !isColorIdentitySelected(color: color){
            selectedColorIdentities.append(color)
        }
    }
    func deselectColorIdentity(color: String){
        if isColorIdentitySelected(color: color) {
            if let index = selectedColorIdentities.firstIndex(of: color){
                selectedColorIdentities.remove(at: index)
            }
        }
    }
    func isColorIdentitySelected(color: String) -> Bool {
        return selectedColorIdentities.contains(color)
    }
    
    func toggleIsPromo() {
        isPromo = !isPromo
    }
    func isPromoSelected() -> Bool {
        return isPromo
    }
    
    func getPredicates() -> [NSPredicate] {
        var predicates: [NSPredicate] = []
        if selectedSets.count > 0 {
            let setsPredicate = NSPredicate(format: "set.code in %@", selectedSets)
            predicates.append(setsPredicate)
        }
        if selectedTypes.count > 0 {
            let typesPredicate = NSPredicate(format: "ANY types.type  in %@", selectedTypes)
            predicates.append(typesPredicate)
        }
        if selectedSubTypes.count > 0 {
            let subtypesPredicate = NSPredicate(format: "ANY cardsubtypes.subtype  in %@", selectedSubTypes)
            predicates.append(subtypesPredicate)
        }
        if selectedSuperTypes.count > 0 {
            let supertypesPredicate = NSPredicate(format: "ANY cardsupertypes.supertype  in %@", selectedSuperTypes)
            predicates.append(supertypesPredicate)
        }
        if selectedLegalities.count > 0 {
            var legalityPredicates: [NSPredicate] = []
            for legality in selectedLegalities{
                let p = NSPredicate(format: "legalities.%@ == 'Legal'", legality.lowercased())
                legalityPredicates.append(p)
            }
            let predicate = NSCompoundPredicate(type: .or, subpredicates: legalityPredicates)
            predicates.append(predicate)
            
        }
        if selectedKeywords.count > 0 {
            let keywordsPredicate = NSPredicate(format: "ANY keywords.keyword  in %@", selectedKeywords)
            predicates.append(keywordsPredicate)
        }
        if selectedColorIdentities.count > 0 && Set(selectedColorIdentities).subtracting(["nC"]).count < 5 {
            let colors = ["W","U","B","R","G"]
            var identityPredicates: [NSPredicate] = []
//            for color in selectedColorIdentities {
//                let temp = NSPredicate(format: "ANY colorIdentity.color == %@", color)
//                identityPredicates.append(temp)
//            }
//                identityPredicates.append(NSPredicate(format: "ANY colorIdentity.color in %@", selectedColorIdentities))
//            identityPredicates.append(NSPredicate(format: "NONE colorIdentity.color in %@", Set(colors).subtracting(selectedColorIdentities)))
            identityPredicates.append(NSPredicate(format: "SUBQUERY(colorIdentity, $i, $i.color in %@).@count > 0", selectedColorIdentities, selectedColorIdentities.count))
             identityPredicates.append(NSPredicate(format: "SUBQUERY(colorIdentity, $i, $i.color in %@).@count < 1", Set(colors).subtracting(selectedColorIdentities)))
//            for c in Set(colors).subtracting(selectedColorIdentities) {
//                let temp = NSPredicate(format: "ANY colorIdentity.color != %@", c)
//                identityPredicates.append(temp)
//            }
            let colorIdentitiesPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: identityPredicates)
                    let colorlessPredicate = NSPredicate(format: "colorIdentity.@count == 0")
                    let compoundColorPredicate = NSCompoundPredicate(orPredicateWithSubpredicates: [colorIdentitiesPredicate, colorlessPredicate])
                    predicates.append(compoundColorPredicate)
            
        }
        if isPromoSelected() {
            let promoPredicate = NSPredicate(format: "set.type == %@", "promo")
            predicates.append(promoPredicate)
        }
        if UserDefaultsHandler.areOnlineOnlyCardsExcluded() {
            let onlineOnlyPredicate = NSPredicate(format: "set.isOnlineOnly == false")
            predicates.append(onlineOnlyPredicate)
        }
        return predicates
    }
    
    func resetFilters(){
        selectedSets = []
        selectedTypes = []
        selectedSubTypes = []
        selectedSuperTypes = []
        selectedLegalities = []
        selectedColorIdentities = []
        isPromo = false
        selectedKeywords = []
    }
}
extension Array where Iterator.Element == String
{
    func formattedDescription() -> String {
        if self.count == 0 {
            return "All"
        }
        return self.description.replacingOccurrences(of: "[", with: "").replacingOccurrences(of: "]", with: "").replacingOccurrences(of: "\"", with: "")
    }
}
