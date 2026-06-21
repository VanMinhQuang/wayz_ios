//
//  Publisher+Extensions.swift
//  wayz_ios
//

import Combine
import Foundation

extension Publisher {
    /// Receive output on the main thread.
    func receiveOnMain() -> Publishers.ReceiveOn<Self, DispatchQueue> {
        receive(on: DispatchQueue.main)
    }
}
