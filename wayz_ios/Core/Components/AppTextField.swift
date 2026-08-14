//
//  AppTextField.swift
//  wayz_ios
//

import SwiftUI

// MARK: - Component

struct AppTextField: View {
    @Environment(\.appTheme) private var theme

    let label: String
    let placeholder: String
    @Binding var text: String
    var errorMessage: String? = nil
    var leadingIcon: String? = nil
    var trailingIcon: String? = nil
    var onTrailingIconTap: (() -> Void)? = nil
    var keyboardType: UIKeyboardType = .default
    var autocapitalization: TextInputAutocapitalization = .sentences
    var submitLabel: SubmitLabel = .done
    var onSubmit: (() -> Void)? = nil

    @FocusState private var isFocused: Bool

    private var hasError: Bool { errorMessage != nil }

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            // Label
            if !label.isEmpty {
                Text(label)
                    .font(theme.fonts.caption)
                    .foregroundStyle(hasError ? theme.colors.error : theme.colors.textSecondary)
            }

            // Input row
            HStack(spacing: 10) {
                if let icon = leadingIcon {
                    Image(systemName: icon)
                        .foregroundStyle(isFocused ? theme.colors.primary : theme.colors.textSecondary)
                        .font(.system(size: 16))
                }

                TextField(placeholder, text: $text)
                    .focused($isFocused)
                    .keyboardType(keyboardType)
                    .textInputAutocapitalization(autocapitalization)
                    .submitLabel(submitLabel)
                    .onSubmit { onSubmit?() }
                    .font(theme.fonts.body)
                    .foregroundStyle(theme.colors.textPrimary)

                if let icon = trailingIcon {
                    Button(action: { onTrailingIconTap?() }) {
                        Image(systemName: icon)
                            .foregroundStyle(theme.colors.textSecondary)
                            .font(.system(size: 16))
                    }
                }
            }
            .padding(.horizontal, 14)
            .frame(height: 48)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(theme.colors.surface)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(borderColor, lineWidth: 1.5)
            )
            .animation(.easeInOut(duration: 0.15), value: isFocused)
            .animation(.easeInOut(duration: 0.15), value: hasError)

            // Error message
            if let error = errorMessage {
                HStack(spacing: 4) {
                    Image(systemName: "exclamationmark.circle.fill")
                        .font(.system(size: 11))
                    Text(error)
                        .font(theme.fonts.caption)
                }
                .foregroundStyle(theme.colors.error)
                .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
        .animation(.easeInOut(duration: 0.2), value: errorMessage)
    }

    private var borderColor: Color {
        if hasError { return theme.colors.error }
        if isFocused { return theme.colors.primary }
        return Color(UIColor.separator)
    }
}

// MARK: - Secure Variant

struct AppSecureField: View {
    @Environment(\.appTheme) private var theme

    let label: String
    let placeholder: String
    @Binding var text: String
    var errorMessage: String? = nil
    var submitLabel: SubmitLabel = .done
    var onSubmit: (() -> Void)? = nil

    @FocusState private var isFocused: Bool
    @State private var isRevealed: Bool = false

    private var hasError: Bool { errorMessage != nil }

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(label)
                .font(theme.fonts.caption)
                .foregroundStyle(hasError ? theme.colors.error : theme.colors.textSecondary)

            HStack(spacing: 10) {
                Image(systemName: "lock")
                    .foregroundStyle(isFocused ? theme.colors.primary : theme.colors.textSecondary)
                    .font(.system(size: 16))

                Group {
                    if isRevealed {
                        TextField(placeholder, text: $text)
                    } else {
                        SecureField(placeholder, text: $text)
                    }
                }
                .focused($isFocused)
                .submitLabel(submitLabel)
                .onSubmit { onSubmit?() }
                .font(theme.fonts.body)
                .foregroundStyle(theme.colors.textPrimary)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()

                Button(action: { isRevealed.toggle() }) {
                    Image(systemName: isRevealed ? "eye.slash" : "eye")
                        .foregroundStyle(theme.colors.textSecondary)
                        .font(.system(size: 16))
                }
            }
            .padding(.horizontal, 14)
            .frame(height: 48)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(theme.colors.surface)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(borderColor, lineWidth: 1.5)
            )
            .animation(.easeInOut(duration: 0.15), value: isFocused)

            if let error = errorMessage {
                HStack(spacing: 4) {
                    Image(systemName: "exclamationmark.circle.fill")
                        .font(.system(size: 11))
                    Text(error)
                        .font(theme.fonts.caption)
                }
                .foregroundStyle(theme.colors.error)
                .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
        .animation(.easeInOut(duration: 0.2), value: errorMessage)
    }

    private var borderColor: Color {
        if hasError { return theme.colors.error }
        if isFocused { return theme.colors.primary }
        return Color(UIColor.separator)
    }
}

// MARK: - Previews

#Preview("Text Fields") {
    ScrollView {
        VStack(spacing: 24) {
            AppTextField(
                label: "Email",
                placeholder: "you@example.com",
                text: .constant(""),
                leadingIcon: "envelope"
            )
            AppTextField(
                label: "Username",
                placeholder: "Enter username",
                text: .constant("quang"),
                trailingIcon: "xmark.circle.fill"
            )
            AppTextField(
                label: "Email",
                placeholder: "you@example.com",
                text: .constant("bad-email"),
                errorMessage: "Please enter a valid email address",
                leadingIcon: "envelope",
            )
            AppSecureField(
                label: "Password",
                placeholder: "Min 8 characters",
                text: .constant("secret")
            )
            AppSecureField(
                label: "Password",
                placeholder: "Min 8 characters",
                text: .constant("123"),
                errorMessage: "Password must be at least 8 characters"
            )
        }
        .padding()
    }
    .theme(.default)
}
