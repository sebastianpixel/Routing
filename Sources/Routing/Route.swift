/// The Model that's used for routing. It can be part of the public
/// interface of a module whereas its corresponding `RouteHandler`
/// can be a private implementation detail.
public protocol Route {
    static var transition: Transition { get }
}
