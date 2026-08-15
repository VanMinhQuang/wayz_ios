//
//  DIContainer.swift
//  wayz_ios
//

import Swinject

/// Global DI container accessor.
/// Never call `resolve()` inside a View's `body` — inject at construction time instead.
final class DIContainer {
    static let shared = DIContainer()
    private let container: Container

    private init() {
        let assembler = AppAssembler.shared.assembler
        // Swinject's Assembler exposes the resolver; we cast back to Container
        // so we can register new types if needed at runtime.
        // swiftlint:disable force_cast
        self.container = assembler.resolver as! Container
        // swiftlint:enable force_cast
    }

    /// Resolve a registered type. Crashes early with a descriptive message if not registered.
    func resolve<T>(_ type: T.Type) -> T {
        guard let resolved = container.resolve(type) else {
            fatalError("❌ DIContainer: Could not resolve \(type). Did you register it in an Assembler?")
        }
        return resolved
    }

    /// Resolve a registered type whose factory takes a single runtime argument,
    /// e.g. `ChatViewModel(chatId:)` when pushing a chat route.
    func resolve<T, Arg1>(_ type: T.Type, argument arg1: Arg1) -> T {
        guard let resolved = container.resolve(type, argument: arg1) else {
            fatalError("❌ DIContainer: Could not resolve \(type). Did you register it in an Assembler?")
        }
        return resolved
    }

    /// Resolve a registered type whose factory takes runtime arguments,
    /// e.g. `NavigationViewModel` (destination name/address/coordinate).
    func resolve<T, Arg1, Arg2, Arg3>(_ type: T.Type, arguments arg1: Arg1, _ arg2: Arg2, _ arg3: Arg3) -> T {
        guard let resolved = container.resolve(type, arguments: arg1, arg2, arg3) else {
            fatalError("❌ DIContainer: Could not resolve \(type). Did you register it in an Assembler?")
        }
        return resolved
    }
}
