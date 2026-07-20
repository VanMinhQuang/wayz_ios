import Foundation
import SwiftUI


// MARK: - Models

struct Moment: Identifiable {
    let id = UUID()
    let friendName: String
    let friendInitial: String
    let avatarColor: Color
    let momentColor: Color
    let imageURL: URL?
    let timeAgo: String
    let caption: String?
    var isSeen: Bool = false
}


// MARK: - Sample data

extension Moment {
    static let samples: [Moment] = [
        Moment(friendName: "Alice Nguyen", friendInitial: "A",
               avatarColor: .pink, momentColor: .pink,
               imageURL: URL(string: "https://images.unsplash.com/photo-1626808642875-0aa545482dfb?w=800&q=80&auto=format&fit=crop"),
               timeAgo: "2m ago",
               caption: "Good morning! ☀️"),
        Moment(friendName: "Bob Tran", friendInitial: "B",
               avatarColor: .orange, momentColor: .orange,
               imageURL: URL(string: "https://images.unsplash.com/photo-1526779259212-939e64788e3c?w=800&q=80&auto=format&fit=crop"),
               timeAgo: "15m ago",
               caption: "Lunch time 🍜", isSeen: true),
        Moment(friendName: "Minh Le", friendInitial: "M",
               avatarColor: .purple, momentColor: .purple,
               imageURL: URL(string: "https://images.unsplash.com/photo-1591779051696-1c3fa1469a79?w=800&q=80&auto=format&fit=crop"),
               timeAgo: "1h ago",
               caption: nil, isSeen: true),
        Moment(friendName: "Linh Pham", friendInitial: "L",
               avatarColor: .teal, momentColor: .teal,
               imageURL: URL(string: "https://images.unsplash.com/photo-1544894079-e81a9eb1da8b?w=800&q=80&auto=format&fit=crop"),
               timeAgo: "2h ago",
               caption: "Beach day 🏖️"),
        Moment(friendName: "Huy Vo", friendInitial: "H",
               avatarColor: .green, momentColor: .green,
               imageURL: URL(string: "https://images.unsplash.com/photo-1499209974431-9dddcece7f88?w=800&q=80&auto=format&fit=crop"),
               timeAgo: "3h ago",
               caption: nil, isSeen: true)
    ]
}
