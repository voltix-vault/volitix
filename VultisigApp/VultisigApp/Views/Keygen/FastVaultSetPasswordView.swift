//
//  FastVaultPasswordView.swift
//  VultisigApp
//
//  Created by Artur Guseinov on 10.09.2024.
//

import SwiftUI

struct FastVaultSetPasswordView: View {
    let tssType: TssType
    let vault: Vault
    let selectedTab: SetupVaultState
    let fastVaultEmail: String
    let fastVaultExist: Bool

    @State var password: String = ""
    @State var hint: String = ""
    @State var verifyPassword: String = ""
    @State var isLinkActive = false
    @State var isLoading: Bool = false
    @State var isWrongPassword: Bool = false
    @State var showTooltip = false

    private let fastVaultService: FastVaultService = .shared

    var disclaimerText: String {
        switch fastVaultExist {
        case false:
            return NSLocalizedString("fastVaultSetDisclaimer", comment: "")
        case true:
            return NSLocalizedString("fastVaultEnterDisclaimer", comment: "")
        }
    }

    var body: some View {
        content
            .animation(.easeInOut, value: showTooltip)
            .alert(NSLocalizedString("wrongPassword", comment: ""), isPresented: $isWrongPassword) {
                Button("OK", role: .cancel) { }
            }
    }

    var passwordField: some View {
        VStack(alignment: .leading, spacing: 12) {
            title
            disclaimer
            textfield
            verifyTextfield
        }
        .padding(.horizontal, 16)
        .padding(.top, 30)
        .onAppear {
            isLinkActive = false
        }
    }
    
    var title: some View {
        Text(NSLocalizedString("password", comment: ""))
            .font(.body34BrockmannMedium)
            .foregroundColor(.neutral0)
    }
    
    var disclaimer: some View {
        FastVaultPasswordDisclaimer(showTooltip: $showTooltip)
    }

    var hintField: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(NSLocalizedString("passwordHintTitle", comment: ""))
                .font(.body14MontserratMedium)
                .foregroundColor(.neutral0)

            hintTextfield
        }
        .padding(.horizontal, 16)
    }

    var textfield: some View {
        HiddenTextField(placeholder: "enterPassword", password: $password)
            .padding(.top, 32)
    }

    var verifyTextfield: some View {
        HiddenTextField(placeholder: "verifyPassword", password: $verifyPassword)
            .opacity(fastVaultExist ? 0 : 1)
    }

    var hintTextfield: some View {
        HiddenTextField(
            placeholder: "enterHint",
            password: $hint,
            showHideOption: false
        )
    }

    var buttons: some View {
        VStack(spacing: 20) {
            saveButton
        }
        .padding(.top, 16)
        .padding(.bottom, 40)
        .padding(.horizontal, 16)
    }

    var saveButton: some View {
        Button(action: {
            if fastVaultExist {
                Task { await checkPassword() }
            } else {
                isLinkActive = true
            }
        }) {
            FilledButton(title: "next")
        }
        .opacity(isSaveButtonDisabled ? 0.5 : 1)
        .disabled(isSaveButtonDisabled)
    }

    var isSaveButtonDisabled: Bool {
        switch fastVaultExist {
        case false:
            return password.isEmpty || password != verifyPassword
        case true:
            return password.isEmpty
        }
    }

    var fastSignConfig: FastSignConfig {
        return FastSignConfig(
            email: fastVaultEmail,
            password: password,
            hint: hint,
            isExist: fastVaultExist
        )
    }

    @MainActor func checkPassword() async {
        isLoading = true
        defer { isLoading = false }

        let isValid = await fastVaultService.get(
            pubKeyECDSA: vault.pubKeyECDSA,
            password: password
        )

        guard isValid else {
            isWrongPassword = true
            password = .empty
            return
        }

        isLinkActive = true
    }
}
