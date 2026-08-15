//
//  ScreenStatus.swift
//  wayz_ios
//
//  Shared loading-state enum used by every ViewModel.
//
//  If a screen needs states beyond the four base ones (e.g. `.uploading`,
//  `.playing`, `.refreshing`), define your own enum with a `.common(ScreenStatus)`
//  case that wraps the base — see `StoryScreenStatus` at the bottom of this file
//  for the canonical pattern.
//

/// Base loading state shared across all ViewModels.
enum ScreenStatus: Equatable {
    case idle
    case loading
    case loaded
    case failed(String)

    var isIdle: Bool {
        if case .idle = self { return true }
        return false
    }

    var isLoading: Bool {
        if case .loading = self { return true }
        return false
    }

    var isLoaded: Bool {
        if case .loaded = self { return true }
        return false
    }

    var isFailed: Bool {
        if case .failed = self { return true }
        return false
    }

    var errorMessage: String? {
        if case .failed(let message) = self { return message }
        return nil
    }
}

/// Adopt this on any custom screen-status enum so callers can query base
/// flags (`isLoading`, `errorMessage`, …) uniformly regardless of which
/// specific enum a ViewModel exposes.
protocol ScreenStatusRepresenting: Equatable {
    var base: ScreenStatus? { get }
    var isLoading: Bool { get }
    var isLoaded: Bool { get }
    var isFailed: Bool { get }
    var errorMessage: String? { get }
}

extension ScreenStatus: ScreenStatusRepresenting {
    var base: ScreenStatus? { self }
}

// MARK: - Extension pattern
//
// To add screen-specific states, define your own enum with a `.common` case
// wrapping `ScreenStatus`, plus any extra cases you need. Conform to
// `ScreenStatusRepresenting` so views/helpers keep working uniformly.
//
// ```
// enum StoryScreenStatus: ScreenStatusRepresenting {
//     case common(ScreenStatus)
//     case playing
//     case paused
//     case buffering
//
//     var base: ScreenStatus? {
//         if case .common(let s) = self { return s }
//         return nil
//     }
//     var isLoading: Bool { base?.isLoading == true || self == .buffering }
//     var isLoaded: Bool  { base?.isLoaded  == true }
//     var isFailed: Bool  { base?.isFailed  == true }
//     var errorMessage: String? { base?.errorMessage }
// }
// ```
