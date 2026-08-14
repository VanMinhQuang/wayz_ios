//
//  OnboardingView.swift
//  wayz_ios
//

import SwiftUI

struct OnboardingPage: Identifiable {
    let id = UUID()
    let icon: String
    let title: String
    let subtitle: String
}

struct OnboardingView: View {
    @Environment(\.appTheme) private var theme
    @Environment(AppRouter.self) private var router
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding: Bool = false

    @State private var currentIndex: Int = 0

    private let pages: [OnboardingPage] = [
        OnboardingPage(
            icon: "map.fill",
            title: "Chào mừng đến với Wayz",
            subtitle: "Ứng dụng bản đồ xã hội giúp bạn khám phá địa điểm, chia sẻ hành trình và kết nối bạn bè trên cùng một nền tảng."
        ),
        OnboardingPage(
            icon: "sparkles",
            title: "Lợi ích khi dùng Wayz",
            subtitle: "Dẫn đường thông minh, đề xuất địa điểm cá nhân hoá, review chân thực từ cộng đồng và trò chuyện realtime với bạn bè cùng chuyến đi."
        ),
        OnboardingPage(
            icon: "hand.thumbsup.fill",
            title: "Chúc bạn có trải nghiệm vui vẻ!",
            subtitle: "Mọi thứ đã sẵn sàng. Hãy bắt đầu khám phá và tạo nên hành trình của riêng bạn cùng Wayz."
        )
    ]

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Spacer()
                if !isLastPage {
                    Button("Bỏ qua") {
                        finishOnboarding()
                    }
                    .font(theme.fonts.body)
                    .foregroundStyle(theme.colors.textSecondary)
                }
            }
            .frame(height: 44)
            .padding(.horizontal, 20)

            TabView(selection: $currentIndex) {
                ForEach(Array(pages.enumerated()), id: \.offset) { index, page in
                    OnboardingPageView(page: page)
                        .tag(index)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .animation(.easeInOut, value: currentIndex)

            pageIndicator
                .padding(.top, 8)
                .padding(.bottom, 24)

            AppButton(
                title: isLastPage ? "Bắt đầu" : "Tiếp tục",
                style: .primary,
                size: .large
            ) {
                if isLastPage {
                    finishOnboarding()
                } else {
                    withAnimation {
                        currentIndex += 1
                    }
                }
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 32)
        }
        .background(theme.colors.background.ignoresSafeArea())
    }

    private var isLastPage: Bool {
        currentIndex == pages.count - 1
    }

    private var pageIndicator: some View {
        HStack(spacing: 8) {
            ForEach(pages.indices, id: \.self) { index in
                Capsule()
                    .fill(index == currentIndex ? theme.colors.primary : theme.colors.textDisabled)
                    .frame(width: index == currentIndex ? 24 : 8, height: 8)
                    .animation(.easeInOut(duration: 0.2), value: currentIndex)
            }
        }
    }

    private func finishOnboarding() {
        hasSeenOnboarding = true
        router.dismissFullScreenCover()
    }
}

private struct OnboardingPageView: View {
    @Environment(\.appTheme) private var theme
    let page: OnboardingPage

    var body: some View {
        VStack(spacing: 32) {
            Spacer()

            ZStack {
                Circle()
                    .fill(theme.colors.primary.opacity(0.12))
                    .frame(width: 220, height: 220)

                Image(systemName: page.icon)
                    .font(.system(size: 96, weight: .semibold))
                    .foregroundStyle(theme.gradients.primary)
            }

            VStack(spacing: 16) {
                Text(page.title)
                    .font(theme.fonts.heading1)
                    .multilineTextAlignment(.center)
                    .foregroundStyle(theme.colors.textPrimary)

                Text(page.subtitle)
                    .font(theme.fonts.body)
                    .multilineTextAlignment(.center)
                    .foregroundStyle(theme.colors.textSecondary)
                    .padding(.horizontal, 32)
            }

            Spacer()
            Spacer()
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    OnboardingView()
        .environment(AppRouter())
        .theme(.default)
}
