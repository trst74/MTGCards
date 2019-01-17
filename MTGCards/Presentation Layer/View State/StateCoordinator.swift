/// Copyright (c) 2018 Razeware LLC
/// 
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation cards (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
/// 
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
/// 
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
/// 
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import UIKit

// 1
protocol StateCoordinatorDelegate: class {
  func gotoState(_ nextState: SelectionState, card: Card?)
}

// 2
class StateCoordinator: NSObject {
  // 3
    static let shared = StateCoordinator()
    
  private(set) var state: SelectionState = .noSelection
  public weak var delegate: StateCoordinatorDelegate?
  
  init(delegate: StateCoordinatorDelegate) {
    self.delegate = delegate
  }
    private override init() {
        
    }
  // 4
//  private(set) var selectedCard: Card? {
//    didSet {
//      guard let card = selectedCard else {
//        state = .noSelection
//        return
//      }
//      state = card.isFolder ? .folderSelected : .cardSelected
//    }
//  }
//
//  // 5
//  var selectedFolder: Card? {
//    guard let card = selectedCard else {
//      return nil
//    }
//    return card.isFolder ? card : card.parent
//  }
}

extension  StateCoordinator {
    func didSelectCollection(collection: String){
        var card = Card()
        
        card.name = collection
        delegate?.gotoState(state, card: card)
    }
    func didSelectCard(c: String){
        var card = Card()
        
        card.name = c
        delegate?.gotoState(SelectionState.cardSelected, card: card)
    
    }
//  func didSelectCard(_ card: Card?) {
//    selectedCard = card
//    delegate?.gotoState(state, card: selectedCard)
//  }
//  
//  func didDeleteCard(parentFolder: Card?) {
//    selectedCard = parentFolder
//    state = .noSelection
//    delegate?.gotoState(state, card: selectedCard)
//  }
}
