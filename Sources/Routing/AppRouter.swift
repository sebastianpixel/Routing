/// Concrete implementation of the `Router` protocol.
/// It accepts `Route` instances and forwards instances of its generic `View` type
/// as returned by the `Route`'s `RouteHandler`. The instances are then passed along
/// with the `Route`'s `Transition` to a `Navigator` type which represents the actual
/// UI component that executes the navigation. `Route`'s need to be registed via their
/// respective `RouteHandler`.
public final class AppRouter<View>: Router {

    public var root: View {
        _ = setUpOnce
        return navigator.root
    }

    // visible for testing
    let navigator: AnyNavigator
    var routeHandlers = [ObjectIdentifier: AnyRouteHandler]()
    var rootElements = [Route]()

    private lazy var setUpOnce: Void = {
        if let registering = self as? RouteHandlerRegistering {
            registering.registerRoutes()
        }

        let rootElements = self.rootElements
            .compactMap { route -> (View, RootItem)?  in
                guard let handler = self.handler(for: route),
                      case let .root(route: _, rootItem: rootItem) = type(of: route).transition else {
                    return nil
                }
                return (
                    handler.view(for: route),
                    rootItem
                )
            }
        if !rootElements.isEmpty {
            navigator.setUp(rootElements: rootElements)
        }
    }()

    public init<N: Navigator>(navigator: N) where N.View == View {
        self.navigator = AnyNavigator(navigator)
    }

    public func register<Handler: RouteHandler>(_ handler: Handler) where Handler.View == View {
        let identifier = ObjectIdentifier(Handler.ConcreteRoute.self)
        routeHandlers[identifier] = AnyRouteHandler(handler)

        if case let .root(route: route, rootItem: _) = Handler.ConcreteRoute.transition {
            rootElements.append(route)
        }
    }

    public func callAsFunction<ConcreteRoute: Route>(_ route: ConcreteRoute) {
        guard let handler = handler(for: route) else {
            return
        }
        navigator(
            view: handler.view(for: route),
            transition: ConcreteRoute.transition
        )
    }

    private func handler(for route: Any) -> AnyRouteHandler? {
        let identifier = ObjectIdentifier(type(of: route))
        guard let handler = routeHandlers[identifier] else {
            print("⚠️ No handler registered for route \(route).")
            return nil
        }
        return handler
    }
}

// visible for testing

extension AppRouter {

    struct AnyRouteHandler {

        private let viewForRoute: (Route) -> View

        init<Handler: RouteHandler>(_ handler: Handler) where Handler.View == View {
            viewForRoute = { route in
                guard let concreteRoute = route as? Handler.ConcreteRoute else {
                    preconditionFailure("Registered route of type \(type(of: route)) does not match handler's route type \(Handler.ConcreteRoute.self).")
                }
                return handler.view(for: concreteRoute)
            }
        }

        func view(for route: Route) -> View {
            viewForRoute(route)
        }
    }

    struct AnyNavigator: Navigator {

        private let navigatorRoot: () -> View
        private let navigatorSetUp: ([(View, RootItem)]) -> Void
        private let navigatorCallAsFunction: (() -> View, Transition) -> Void

        var root: View {
            navigatorRoot()
        }

        func setUp(rootElements: [(View, RootItem)]) {
            navigatorSetUp(rootElements)
        }

        func callAsFunction(view: @autoclosure () -> View, transition: Transition) {
            navigatorCallAsFunction(view, transition)
        }

        init<N: Navigator>(_ navigator: N) where N.View == View {
            navigatorRoot = { navigator.root }
            navigatorSetUp = navigator.setUp
            navigatorCallAsFunction = navigator.callAsFunction
        }
    }
}
