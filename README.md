# Routing

## `Route`s and `RouteHandler`s

Router is based on the idea of open navigation flows where any location inside an app can be reached from anywhere by passing instances of `Route` types to corresponding, preregistered `RouteHandler`s. While `Route`s provide necessary information about the desination, `RouteHandler`s will provide instances of a generic `View` type which can be specified as `AnyView`, `UIViewController`, `NSViewController` or any other type.

```Swift
public struct HomeRoute: Route {
    public static var transition: Transition = .root(
        route: HomeRoute(),
        rootItem: RootItem(
            title: "Home",
            image: UIImage(systemName: "house"),
            selectedImage: UIImage(systemName: "house.fill")
        )
    )
}

public struct HomeRouteHandler: RouteHandler {
    public func view(for route: HomeRoute) -> AnyView {
        AnyView(Home())
    }
}
```
`Route` types can be seen as part of the interface e.g. of a feature module like the home screen, whereas their corresponding handlers are an implementation detail that only needs to be accessible for registering to the `Router` like from a separate app module.

## `Transition`s
`Route`s provide a particular `Transition` which determines the way the view (as returned by the `RouteHandler`) will be presented. As of now possible transitions are
* `.root` -> The view is part of an initially shown set of views, e.g. tabs in a tab bar.
* `.stack` -> The view should be pushed on the current navigation stack.
* `.modal` -> The view should be presented modally.

## `AppRouter` and the registration of `RouteHandler`s
The framework provides an implementation of the `Router` protocol, `AppRouter`. While it's possible to register handlers via the `Router`'s `register` method it's the easiest to make `AppRouter` conform to `RouteHandlerRegistering`. `AppRouter` will then call `registerRoutes` once its `root` property is first accessed.

```Swift
extension AppRouter: RouteHandlerRegistering where View == AnyView {
    public func registerRoutes() {
        register(HomeRouteHandler())
    }
}
```

## Navigating and the `AppRouter`'s `Navigator` type
After registering `RouteHandler`s navigation actions are started by passing instances of `Route`s to the `Router`. `Router` itself is only responsible for matching `Route`s with their handler. `AppRouter` will continue to call the handlers' `view` method and pass the returned value to a `Navigator`. This can be seen as the UI component that will eventually execute the navigation action.

An example `Navigator` could be a `UITabBarController`. The particular implementation of the `Navigator` protocol is the place where the navigation logic is provided:

```Swift
import UIKit

extension UITabBarController: Navigator {
    public var root: UIViewController {
        self
    }

    public func setUp(rootElements: [(UIViewController, RootItem)]) {
        let navigationControllers = rootElements
            .map { viewController, rootItem -> UINavigationController in
                let navigationController = UINavigationController(rootViewController: viewController)
                navigationController.tabBarItem = .init(
                    title: rootItem.title,
                    image: rootItem.image,
                    selectedImage: rootItem.selectedImage
                )
                return navigationController
            }
        setViewControllers(navigationControllers, animated: false)
    }

    public func callAsFunction(view viewController: @autoclosure () -> UIViewController, transition: Transition) {
        switch transition {
        case .stack:
            let viewController = viewController()
            let push: () -> Void = {
                (self.selectedViewController as? UINavigationController)?.pushViewController(viewController, animated: true)
            }
            if presentedViewController != nil {
                dismiss(animated: true, completion: push)
            } else {
                push()
            }
        case .modal:
            present(viewController(), animated: true, completion: nil)
        case .root(route: _, rootItem: let rootItem):
            if let index = viewControllers?.firstIndex(where: { viewController in
                viewController.tabBarItem.title == rootItem.title
            }) {
                selectedIndex = index
            }
        }
    }
}
```
