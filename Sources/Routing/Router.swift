/// `Router` is the interface for all navigation actions within the app.
/// It resolves instances of `Route` types that were registered via their
/// respective `RouteHandler`.
/// The associated type `View` determines the type of view that should be
/// used for routing - a `UIKit.UIViewController`, `AppKit.NSViewController`
/// or `SwiftUI.AnyView`.
///
///`Router` is a class so it can be specified as concrete type when the
/// concrete implementation should be rosolved via dependency injection:
/// ```
/// @Inject private var router: Router<UIViewController>
/// ```
open class Router<View> {
    open var root: View {
        fatalError("\(#function) needs to be overridden.")
    }
    open func register<Handler: RouteHandler>(_ handler: Handler) where Handler.View == View {
        fatalError("\(#function) needs to be overridden.")
    }
    open func callAsFunction<ConcreteRoute: Route>(_ route: ConcreteRoute) {
        fatalError("\(#function) needs to be overridden.")
    }
}
