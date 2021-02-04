/// Responsible for providing a concrete view for a given `Route` instance.
/// `Route`s are registered via their respective `RouteHandler` which is
/// generic over a concrete `Route` type. The associated type `View` must
/// match the `Router`'s associated `View` type.
public protocol RouteHandler {
    associatedtype ConcreteRoute: Route
    associatedtype View

    func view(for route: ConcreteRoute) -> View
}
