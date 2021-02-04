import XCTest
@testable import Routing

final class AppRouterTests: XCTestCase {

    private let navigator = NavigatorMock()
    private lazy var router = AppRouter(navigator: navigator)

    func testRegister_routeWithRootTransition_routeHandlersAndRootElementsAreSet() {
        router.register(RootRouteHandlerMock())

        XCTAssertEqual(router.rootElements.count, 1)
        XCTAssertEqual((router.rootElements.first as? RootRouteMock)?.id, RootRouteMock.id)

        XCTAssertEqual(router.routeHandlers.count, 1)
        XCTAssertEqual(router.routeHandlers.first?.key, ObjectIdentifier(RootRouteMock.self))
        XCTAssertEqual(
            router.routeHandlers[ObjectIdentifier(RootRouteMock.self)]?.view(for: RootRouteMock.route),
            RootRouteMock.id
        )
    }

    func testRegister_routeWithStackTransition_onlyRouteHandlersIsSet() {
        router.register(StackRouteHandlerMock())

        XCTAssertTrue(router.rootElements.isEmpty)

        XCTAssertEqual(router.routeHandlers.count, 1)
        XCTAssertEqual(router.routeHandlers.first?.key, ObjectIdentifier(StackRouteMock.self))

        let route = StackRouteMock(id: .init())
        XCTAssertEqual(
            router.routeHandlers[ObjectIdentifier(StackRouteMock.self)]?.view(for: route),
            route.id
        )
    }

    func testRoot_onAccess_returnsNavigatorRoot() {
        XCTAssertEqual(router.root, router.navigator.root)
    }

    func testRoot_onFirstAccess_navigatorIsSetUp() {
        router.register(RootRouteHandlerMock())
        _ = router.root

        let invocations = navigator.invocations as! [(method: String, args: [(UUID, RootItem)])]
        XCTAssertEqual(invocations.count, 1)
        XCTAssertEqual(invocations.first?.method, "setUp(rootElements:)")
        let args = invocations.first?.args
        XCTAssertEqual(args?.count, 1)
        XCTAssertEqual(args?.first?.0, RootRouteMock.id)
        XCTAssertEqual(args?.first?.1, RootRouteMock.rootItem)
    }

    func testRoot_onFirstAccess_registerRoutesIsCalled() {
        registerRootRouteHandlerMock = true
        _ = router.root

        let invocations = navigator.invocations as! [(method: String, args: [(UUID, RootItem)])]
        XCTAssertEqual(invocations.count, 1)
        XCTAssertEqual(invocations.first?.method, "setUp(rootElements:)")
        let args = invocations.first?.args
        XCTAssertEqual(args?.count, 1)
        XCTAssertEqual(args?.first?.0, RootRouteMock.id)
        XCTAssertEqual(args?.first?.1, RootRouteMock.rootItem)
    }

    func testRoot_onAccess_routeHandlerRegisteringIsCalledOnlyOnce() {
        invocationCount = 0
        _ = router.root
        XCTAssertEqual(invocationCount, 1)
        _ = router.root
        XCTAssertEqual(invocationCount, 1)
    }

    func testCallAsFunction_noRouteRegistered_navigatorIsNotCalled() {
        _ = router.root
        router.callAsFunction(RootRouteMock(id: .init()))
        XCTAssertTrue(navigator.invocations.isEmpty)
    }

    func testCallAsFunction_routesRegistered_navigatorIsCalledWithViewFromCorrectHandler() {
        router.register(RootRouteHandlerMock())
        _ = router.root
        router.callAsFunction(RootRouteMock(id: RootRouteMock.id))
        let invocations = navigator.invocations
        XCTAssertEqual(invocations.count, 2)
        let callAsFunctionInvocation = invocations.last as? (method: String, args: (UUID, Transition))
        XCTAssertEqual(callAsFunctionInvocation?.method, "callAsFunction(view:transition:)")
        let args = callAsFunctionInvocation?.args
        XCTAssertEqual(args?.0, RootRouteMock.id)
        var rootRouteMockTransitionDump = ""
        dump(RootRouteMock.transition, to: &rootRouteMockTransitionDump)
        var callAsFunctionInvocationTransitionDump = ""
        dump(callAsFunctionInvocation!.args.1, to: &callAsFunctionInvocationTransitionDump)
        XCTAssertEqual(rootRouteMockTransitionDump, callAsFunctionInvocationTransitionDump)
    }
}

private var invocationCount = 0
private var registerRootRouteHandlerMock = false

extension AppRouter: RouteHandlerRegistering where View == UUID {
    public func registerRoutes() {
        invocationCount += 1
        if registerRootRouteHandlerMock {
            register(RootRouteHandlerMock())
        }
    }
}

private final class NavigatorMock: Navigator {

    var invocations = [(method: String, args: Any)]()

    let id = UUID()

    var root: UUID {
        id
    }

    func setUp(rootElements: [(UUID, RootItem)]) {
        log(args: rootElements)
    }

    func callAsFunction(view: @autoclosure () -> UUID, transition: Transition) {
        log(args: (view(), transition))
    }

    private func log(args: Any, method: String = #function) {
        invocations.append((method: method, args: args))
    }
}

private struct RootRouteMock: Route {
    static var transition: Transition = .root(
        route: route,
        rootItem: rootItem
    )

    static let id = UUID()
    static let route = RootRouteMock(id: id)
    static let rootItem = RootItem(
        title: String(describing: RootRouteMock.self),
        image: nil,
        selectedImage: nil
    )

    let id: UUID
}

private struct RootRouteHandlerMock: RouteHandler {
    func view(for route: RootRouteMock) -> UUID {
        route.id
    }
}

private struct StackRouteMock: Route {
    static var transition: Transition = .stack

    let id: UUID
}

private struct StackRouteHandlerMock: RouteHandler {
    func view(for route: StackRouteMock) -> UUID {
        route.id
    }
}
