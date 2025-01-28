//
//  SetupVaultState.swift
//  VultisigApp
//
//  Created by Amol Kumar on 2024-05-09.
//

import SwiftUI

enum SetupVaultState: CaseIterable {
    case fast
    case active
    case secure

    var isFastVault: Bool {
        switch self {
        case .fast, .active:
            return true
        case .secure:
            return false
        }
    }


    var hasOtherDevices: Bool {
        switch self {
        case .fast:
            return false
        case .active, .secure:
            return true
        }
    }

    var title: String {
        switch self {
        case .fast:
            return NSLocalizedString("fastModeTitle", comment: "")
        case .active:
            return NSLocalizedString("activeModeTitle", comment: "")
        case .secure:
            return NSLocalizedString("secureModeTitle", comment: "")
        }
    }

    var label: String {
        switch self {
        case .fast:
            return NSLocalizedString("fastModeDescription", comment: "")
        case .active:
            return NSLocalizedString("activeModeDescription", comment: "")
        case .secure:
            return NSLocalizedString("secureModeDescription", comment: "")
        }
    }
    
    var image: String {
        switch self {
        case .fast:
            return "SetupVaultImage1"
        case .active:
            return "SetupVaultImage2"
        case .secure:
            return "SetupVaultImage3"
        }
    }
    
    var loaderTitle: String {
        switch self {
        case .fast:
            return NSLocalizedString("fastLoaderTitle", comment: "")
        case .active:
            return NSLocalizedString("activeLoaderTitle", comment: "")
        case .secure:
            return NSLocalizedString("secureLoaderTitle", comment: "")
        }
    }
    
    var secureTextTitle: String {
        switch self {
        case .secure:
            return NSLocalizedString("ultimateSecurity", comment: "")
        case .fast, .active:
            return NSLocalizedString("fastSetUp", comment: "")
        }
    }
    
    var secureTextDecription: String {
        switch self {
        case .secure:
            return NSLocalizedString("secureVaultSecureTextDescription", comment: "")
        case .fast, .active:
            return NSLocalizedString("fastVaultSecureTextDescription", comment: "")
        }
    }
}
