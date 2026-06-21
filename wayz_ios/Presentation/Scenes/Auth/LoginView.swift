//
//  LoginView.swift
//  wayz_ios
//

import SwiftUI

struct LoginView: View {
    @State private var viewModel: LoginViewModel
    private let router: AppRouter

    init(viewModel: LoginViewModel, router: AppRouter) {
        self._viewModel = State(initialValue: viewModel)
        self.router = router
        viewModel.onLoginSuccess = { [weak router] in
            router?.logIn()
        }
    }

    var body: some View {
        VStack(spacing: 24) {
            Text("Welcome Back")
                .font(.largeTitle.bold())

            VStack(spacing: 16) {
                TextField("Email", text: $viewModel.email)
                    .textContentType(.emailAddress)
                    .keyboardType(.emailAddress)
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.never)
                    .padding()
                    .background(.quaternary, in: RoundedRectangle(cornerRadius: 12))

                SecureField("Password", text: $viewModel.password)
                    .textContentType(.password)
                    .padding()
                    .background(.quaternary, in: RoundedRectangle(cornerRadius: 12))
            }

            if let error = viewModel.errorMessage {
                Text(error)
                    .foregroundStyle(.red)
                    .font(.caption)
            }

            Button {
                Task { await viewModel.login() }
            } label: {
                Group {
                    if viewModel.isLoading {
                        ProgressView()
                    } else {
                        Text("Log In")
                            .fontWeight(.semibold)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding()
            }
            .buttonStyle(.borderedProminent)
            .disabled(viewModel.isLoading)
        }
        .padding(32)
    }
}
