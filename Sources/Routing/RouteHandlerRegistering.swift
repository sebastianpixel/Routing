/// Convenience protocol for registering `Route`s.
/// If `AppRouter` conforms to `RouteHandlerRegistering` `registerRoutes`
/// will be called when the `AppRouter`s `root` property is first accessed.
public protocol RouteHandlerRegistering {
    func registerRoutes()
}
