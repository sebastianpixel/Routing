/// The navigator provides the UI component responsible for executing the actual navigation.
/// This might be a tab bar or drawer navigation.
public protocol Navigator {
    associatedtype View

    var root: View { get }
    func setUp(rootElements: [(View, RootItem)])
    func callAsFunction(view: @autoclosure () -> View, transition: Transition)
}
