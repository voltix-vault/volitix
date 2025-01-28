//
//  OnboardingView+iOS.swift
//  VultisigApp
//
//  Created by Amol Kumar on 2024-09-24.
//

#if os(iOS)
import SwiftUI

extension OnboardingView {
    private var idiom : UIUserInterfaceIdiom { UIDevice.current.userInterfaceIdiom }
    
    var container: some View {
        content
            .toolbar(.hidden, for: .navigationBar)
    }
    
    var text: some View {
        TabView(selection: $tabIndex) {
            ForEach(0..<totalTabCount, id: \.self) { index in
                VStack {
                    Spacer()
                    OnboardingTextCard(index: index, animationVM: animationVM)
                }
            }
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
        .frame(maxWidth: .infinity)
    }
    
    var button: some View {
        nextButton
            .padding(.horizontal, 40)
            .padding(.bottom, 10)
    }
    
    func getBottomPadding() -> CGFloat {
        idiom == .phone ? 0 : 50
    }
}
#endif
