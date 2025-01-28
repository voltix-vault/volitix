//
//  NewWalletNameView.swift
//  VultisigApp
//
//  Created by Amol Kumar on 2024-05-12.
//

import SwiftUI
import SwiftData

struct NewWalletNameView: View {
    let tssType: TssType
    let selectedTab: SetupVaultState

    @State var name: String

    @State var didSet = false
    @State var isLinkActive = false
    @State var showAlert = false
    
    @Query var vaults: [Vault]
    
    var body: some View {
        content
    }
    
    var view: some View {
        VStack {
            fields
            Spacer()
            button
        }
        .alert(isPresented: $showAlert) {
            alert
        }
    }
    
    var textfield: some View {
        HStack {
            TextField(NSLocalizedString("enterVaultName", comment: "").capitalized, text: $name)
                .font(.body16Menlo)
                .foregroundColor(.neutral0)
                .submitLabel(.done)
            
            if !name.isEmpty {
                clearButton
            }
        }
        .padding(12)
        .background(Color.blue600)
        .cornerRadius(12)
        .colorScheme(.dark)
        .borderlessTextFieldStyle()
        .maxLength($name)
        .autocorrectionDisabled()
        .padding(.top, 32)
    }
    
    var clearButton: some View {
        Button {
            resetPlaceholderName()
        } label: {
            Image(systemName: "xmark.circle.fill")
                .foregroundColor(.neutral500)
        }
    }
    
    var button: some View {
        Button {
            verifyVault()
        } label: {
            FilledButton(title: "next")
        }
        .padding(.vertical, 40)
        .padding(.horizontal, 24)
        .navigationDestination(isPresented: $isLinkActive) {
            if selectedTab.isFastVault {
                FastVaultEmailView(tssType: tssType, vault: Vault(name: name), selectedTab: selectedTab)
            } else {
                PeerDiscoveryView(tssType: tssType, vault: Vault(name: name), selectedTab: selectedTab, fastSignConfig: nil)
            }
        }
    }
    
    var alert: Alert {
        Alert(
            title: Text(getVaultName() + NSLocalizedString("alreadyExists", comment: "")),
            message: Text(NSLocalizedString("vaultNameUnique", comment: "")),
            dismissButton: .default(Text(NSLocalizedString("dismiss", comment: "")))
        )
    }

    private func verifyVault() {
        for vault in vaults {
            if name.isEmpty || vault.name == name {
                showAlert = true
                return
            }
        }
        
        isLinkActive = true
    }
    
    private func getVaultName() -> String {
        if name.isEmpty {
            return "Vault "
        } else {
            return name + " "
        }
    }
    
    private func resetPlaceholderName() {
        guard !didSet else {
            return
        }
        
        name = ""
        didSet = true
    }
}

#Preview {
    NewWalletNameView(tssType: .Keygen, selectedTab: .fast, name: "Fast Vault #1")
}
