/// `Router` is the interface for all navigation actions within the app.
/// It resolves instances of `Route` types that were registered via their
/// respective `RouteHandler`.
/// The associated type `View` determines the type of view that should be
/// used for routing - a `UIKit.UIViewController`, `AppKit.NSViewController`
/// or `SwiftUI.AnyView`.
public protocol Router {
    associatedtype View

    var root: View { get }
    func register<Handler: RouteHandler>(_ handler: Handler) where Handler.View == View
    func callAsFunction<ConcreteRoute: Route>(_ route: ConcreteRoute)
}
