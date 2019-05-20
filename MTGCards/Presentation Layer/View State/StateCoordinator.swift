import UIKit
import CoreData

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
        func didSelectCollection(collection: NSManagedObjectID) {

            delegate?.gotoState(SelectionState.collectionSelected, s: collection)
        }
        func didSelectCard(id: NSManagedObjectID) {

            delegate?.gotoState(SelectionState.cardSelected, s: id)
        }
        func didSelectDeck(d: NSManagedObjectID) {
            
            delegate?.gotoState(SelectionState.deckSelected, s: d)
        }
        func didSelectTool(tool: String){
            delegate?.gotoState(SelectionState.toolSelected, s: tool as AnyObject)
        }
}
