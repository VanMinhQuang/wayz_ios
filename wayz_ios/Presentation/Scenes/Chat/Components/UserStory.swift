//
//  UserStory.swift
//  wayz_ios
//
//  Created by Macbook on 12/8/26.
//

import SkeletonUI
import SwiftUI

struct UserStory: View {
    @Environment(\.appTheme) var theme

  
    let story: UserChat
    var isLoading: Bool = false
    var onClick: (() -> Void)? = nil
    
    init(story: UserChat, isLoading: Bool = false, onClick: (() -> Void)? = nil) {
         self.story = story
         self.isLoading = isLoading
         self.onClick = onClick
     }

    var body: some View {
        VStack(spacing: 8) {
            ZStack(alignment: .bottomTrailing) {
                Circle()
                    .strokeBorder(
                        story.hasStory
                            ? AnyShapeStyle(
                                LinearGradient(
                                    colors: [.pink, .orange, .purple],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            : AnyShapeStyle(Color.gray.opacity(0.3)),
                        lineWidth: story.hasStory ? 2.5 : 1
                    )
                    .frame(width: 62, height: 62)
                    .overlay(
                        AppImage(
                            source: .url(URL(string: story.avatar)),
                            cornerRadius: 999,
                            placeholder: .icon("person.fill")
                        )
                        .frame(width: 36, height: 36)
                        .skeleton(active: isLoading)
                        .padding(story.isMe ? 8 : 10)

                    )
                if story.isMe {
                    Image(systemName: "plus.circle.fill")
                        .resizable()
                        .frame(width: 20, height: 20)
                        .foregroundStyle(.white, .blue)
                        .background(Circle().fill(.white))
                }
            }
            Text(story.isMe ? "Tin của bạn" : story.name)
                .font(theme.fonts.caption)
                .lineLimit(1)
                .frame(width: 66)
                .foregroundStyle(.primary)
        }.onTapGesture {
            onClick?()
        }
    }
}

struct UserStoryList: View {
    let stories: [UserChat]
    @Environment(AppRouter.self) private var router
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 14) {
                ForEach(stories) { story in
                    UserStory(story: story){
                        router.push(.userStory(userId: story.id))
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
        }
    }
}
