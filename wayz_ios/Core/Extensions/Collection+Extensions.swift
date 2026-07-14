//
//  Collection+Extensions.swift
//  wayz_ios
//

extension Collection {
    /// Returns the element at `index`, or `nil` if it's out of bounds.
    subscript(safe index: Index) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}
