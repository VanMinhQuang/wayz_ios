//
//  ProfileView.swift
//  wayz_ios
//

import SwiftUI

struct ProfileView: View {
    @State private var viewModel: ProfileViewModel
    let userId: String

    init(viewModel: ProfileViewModel, userId: String) {
        self._viewModel = State(initialValue: viewModel)
        self.userId = userId
    }

    var body: some View {
        Group {
            if viewModel.isLoading {
                ProgressView()
            } else if let user = viewModel.user {
                VStack(spacing: 12) {
                    Image(systemName: "person.circle.fill")
                        .font(.system(size: 72))
                        .foregroundStyle(.tint)
                    Text(user.name)
                        .font(.title2.bold())
                    Text(user.email)
                        .foregroundStyle(.secondary)
                }
            } else if let error = viewModel.errorMessage {
                ErrorView(message: error) {
                    Task { await viewModel.loadUser(id: userId) }
                }
            }
        }
        .navigationTitle("Profile")
        .task { await viewModel.loadUser(id: userId) }
    }
}
