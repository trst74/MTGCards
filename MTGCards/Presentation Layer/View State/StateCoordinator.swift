import UIKit

protocol StateCoordinatorDelegate: class {
    func gotoState(_ nextState: SelectionState, s: AnyObject?)
}

class StateCoordinator: NSObject {
    static let shared = StateCoordinator()

    private(set) var state: SelectionState = .noSelection
    public weak var delegate: StateCoordinatorDelegate?

    init(delegate: StateCoordinatorDelegate) {
        self.delegate = delegate
    }
    private override init() {

    }

}
    extension  StateCoordinator {
        func didSelectCollection(collection: Collection) {

            delegate?.gotoState(SelectionState.collectionSelected, s: collection)
        }
        func didSelectCard(c: Card) {

            delegate?.gotoState(SelectionState.cardSelected, s: c)
        }
        func didSelectDeck(d: Deck) {
            
            delegate?.gotoState(SelectionState.deckSelected, s: d)
        }
        func didSelectTool(tool: String){
            delegate?.gotoState(SelectionState.toolSelected, s: tool as AnyObject)
        }
}
