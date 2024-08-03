//
//  RiveAnimationView.swift
//  VultisigApp
//
//  Created by Amol Kumar on 2024-08-03.
//

import SwiftUI
import RiveRuntime

struct RiveAnimationView: View {
    var body: some View {
        VStack {
            RiveViewModel(fileName: "LoadingAnimation").view()
            RiveViewModel(fileName: "ScanAnimation").view()
        }
    }
}

#Preview {
    ZStack {
        Background()
        RiveAnimationView()
    }
}
