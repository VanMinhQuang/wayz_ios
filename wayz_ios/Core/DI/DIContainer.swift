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
}
