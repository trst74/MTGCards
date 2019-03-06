import UIKit

protocol StateCoordinatorDelegate: class {
    func gotoState(_ nextState: SelectionState, s: Card?)
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
        func didSelectCollection(collection: String) {

            delegate?.gotoState(state, s: nil)
        }
        func didSelectCard(c: Card) {

            delegate?.gotoState(SelectionState.cardSelected, s: c)
        }

}
