/// `Transition` determines the way the view should be presented:
public enum Transition {
    /// The view is among the set of initially shown views, e.g. as tabs in a tab bar.
    case root(route: Route, rootItem: RootItem)
    /// The view should be pushed on a navigation stack.
    case stack
    /// The view should be presented modally.
    case modal
}
