//
//  HomeView.swift
//  wayz_ios
//

import SwiftUI

struct HomeView: View {
    @State private var viewModel: HomeViewModel
    @Environment(AppRouter.self) private var router

    init(viewModel: HomeViewModel) {
        self._viewModel = State(initialValue: viewModel)
    }

    var body: some View {
        Group {
            if viewModel.isLoading {
                ProgressView()
            } else if let user = viewModel.user {
                VStack(spacing: 16) {
                    Text("👋 Hello, \(user.name)!")
                        .font(.title2.bold())
                    Text(user.email)
                        .foregroundStyle(.secondary)

                    Button("View Profile") {
                        router.push(.profile(userId: user.id))
                    }
                }
            } else if let error = viewModel.errorMessage {
                ErrorView(message: error) {
                    Task { await viewModel.onAppear() }
                }
            } else {
                ContentUnavailableView("No data", systemImage: "person.slash")
            }
        }
        .navigationTitle("Home")
        .task { await viewModel.onAppear() }
    }
}
